# rubocop:disable all

require "mysql2-nested_hash_bind"
require "benchmark/ips"
require "dotenv/load"
require "securerandom"

require_relative "../spec/support/database_helper"

class BenchmarkContext
  attr_reader :db

  SELECT_SQL = <<~SQL
    SELECT 
      `posts`.`id`,
      `posts`.`user_id`,
      `posts`.`body`,
      `users`.`account_name` AS `users.account_name`,
      `users`.`authority` AS `users.authority`,
      `users`.`del_flg` AS `users.del_flg`
    FROM `posts`
    INNER JOIN `users` ON `posts`.`user_id` = `users`.`id`
  SQL

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

  def perform
    db.xquery(SELECT_SQL)
  end
end

class BenchmarkContextWithQueryExtension < BenchmarkContext
  using Mysql2::NestedHashBind::QueryExtension

  def perform
    db.xquery(SELECT_SQL)
  end
end

context1 = BenchmarkContext.new
context2 = BenchmarkContextWithQueryExtension.new

begin
  context1.setup

  Benchmark.ips do |x|
    x.report("Mysql2::Client#xquery") do
      context1.perform
    end

    x.report("Mysql2::Client#xquery with Mysql2::NestedHashBind::QueryExtension") do
      context2.perform
    end
  end
ensure
  context1.teardown
end
