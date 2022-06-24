# rubocop:disable all

require "mysql2-nested_hash_bind"
require "dotenv"
require "securerandom"
require "stackprof"

Dotenv.load(File.join(__dir__, "..", ".env"))

using Mysql2::NestedHashBind::QueryExtension

require_relative "../spec/support/database_helper"

@db = DatabaseHelper.client

def setup
  @db.query(<<~SQL)
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

  @db.query(<<~SQL)
    CREATE TABLE `posts` (
      `id` int NOT NULL AUTO_INCREMENT,
      `user_id` int NOT NULL,
      `body` text NOT NULL,
      `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
      PRIMARY KEY (`id`)
    )
  SQL

  (1000...1100).each do |id|
    @db.xquery(<<~SQL, id, SecureRandom.uuid)
      INSERT INTO `users` (`id`, `account_name`) VALUES(?, ?)
    SQL

    @db.xquery(<<~SQL, id, id)
      INSERT INTO `posts` (`id`, `user_id`, `body`) VALUES(?, ?, 'test')
    SQL
  end
end

def perform
  1000.times do
    @db.query(<<~SQL)
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
  end
end

def teardown
  @db.query("DROP TABLE IF EXISTS `posts`")
  @db.query("DROP TABLE IF EXISTS `users`")
end

begin
  setup

  StackProf.run(mode: :cpu, raw: true, out: "#{__dir__}/tmp/stackprof_#{Time.now.strftime("%Y%m%d_%H%M%S")}.dump") do
    perform
  end

ensure
  teardown
end
