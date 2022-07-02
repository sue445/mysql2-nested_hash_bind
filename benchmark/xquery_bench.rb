# rubocop:disable all

require "mysql2-nested_hash_bind"
require "benchmark/ips"
require "dotenv"
require "securerandom"

Dotenv.load(File.join(__dir__, "..", ".env"))

require_relative "../spec/support/database_helper"

class DatabaseClient
  SELECT_SQL_WITH_DOT_FORMAT = <<~SQL
    SELECT 
      `posts`.`id`,
      `posts`.`user_id`,
      `posts`.`body`,
      `users`.`account_name` AS `users.account_name`,
      `users`.`authority` AS `users.authority`,
      `users`.`del_flg` AS `users.del_flg`
    FROM `posts`
    INNER JOIN `users` ON `posts`.`user_id` = `users`.`id`
    LIMIT %d
  SQL

  SELECT_SQL_WITHOUT_DOT_FORMAT = <<~SQL
    SELECT 
      `posts`.`id`,
      `posts`.`user_id`,
      `posts`.`body`,
      `users`.`account_name` AS `users_account_name`,
      `users`.`authority` AS `users_authority`,
      `users`.`del_flg` AS `users_del_flg`
    FROM `posts`
    INNER JOIN `users` ON `posts`.`user_id` = `users`.`id`
    LIMIT %d
  SQL

  attr_reader :db

  def initialize
    @db = DatabaseHelper.client
  end

  def setup
    db.query(<<~SQL)
      CREATE TABLE `users` (
        `id` int NOT NULL AUTO_INCREMENT,
        `account_name` varchar(64) NOT NULL,
        `authority` tinyint(1) NOT NULL DEFAULT '0',
        `del_flg` tinyint(1) NOT NULL DEFAULT '0',
        `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
        PRIMARY KEY (`id`),
        UNIQUE KEY `account_name` (`account_name`)
      )
    SQL

    db.query(<<~SQL)
      CREATE TABLE `posts` (
        `id` int NOT NULL AUTO_INCREMENT,
        `user_id` int NOT NULL,
        `body` text NOT NULL,
        `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
        PRIMARY KEY (`id`)
    )
    SQL

    (1000...1100).each do |id|
      db.xquery(<<~SQL, id, SecureRandom.uuid)
        INSERT INTO `users` (`id`, `account_name`) VALUES(?, ?)
      SQL

      db.xquery(<<~SQL, id, id)
        INSERT INTO `posts` (`id`, `user_id`, `body`) VALUES(?, ?, 'test')
      SQL
    end
  end

  def teardown
    db.query("DROP TABLE IF EXISTS `posts`")
    db.query("DROP TABLE IF EXISTS `users`")
  end

  def select_with_dot(limit)
    db.xquery(SELECT_SQL_WITH_DOT_FORMAT % limit)
  end

  def select_without_dot(limit)
    db.xquery(SELECT_SQL_WITHOUT_DOT_FORMAT % limit)
  end
end

class DatabaseClientWithQueryExtension < DatabaseClient
  using Mysql2::NestedHashBind::QueryExtension

  def select_with_dot(limit)
    db.xquery(SELECT_SQL_WITH_DOT_FORMAT % limit)
  end

  def select_without_dot(limit)
    db.xquery(SELECT_SQL_WITHOUT_DOT_FORMAT % limit)
  end
end

client = DatabaseClient.new
patched_client = DatabaseClientWithQueryExtension.new

begin
  client.setup

  [10, 100].each do |limit|
    puts "============== Benchmark with LIMIT #{limit}, without to_a =============="
    Benchmark.ips do |x|
      x.report("Mysql2::Client#xquery") do
        client.select_with_dot(limit)
      end

      x.report("Mysql2::Client#xquery(sql_with_dot) using Mysql2::NestedHashBind::QueryExtension") do
        patched_client.select_with_dot(limit)
      end

      x.report("Mysql2::Client#xquery(sql_without_dot) using Mysql2::NestedHashBind::QueryExtension") do
        patched_client.select_without_dot(limit)
      end

      x.compare!
    end

    puts "============== Benchmark with LIMIT #{limit}, with to_a =============="
    Benchmark.ips do |x|
      x.report("Mysql2::Client#xquery.to_a") do
        client.select_with_dot(limit).to_a
      end

      x.report("Mysql2::Client#xquery(sql_with_dot).to_a using Mysql2::NestedHashBind::QueryExtension") do
        patched_client.select_with_dot(limit).to_a
      end

      x.report("Mysql2::Client#xquery(sql_without_dot).to_a using Mysql2::NestedHashBind::QueryExtension") do
        patched_client.select_without_dot(limit).to_a
      end

      x.compare!
    end
  end
ensure
  client.teardown
end
