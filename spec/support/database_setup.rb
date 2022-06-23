# frozen_string_literal: true

def db
  @db ||= DatabaseHelper.client
end

def up_migrate # rubocop:disable Metrics/MethodLength
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
end

def down_migrate
  db.query("DROP TABLE IF EXISTS `posts`")
  db.query("DROP TABLE IF EXISTS `users`")
end
