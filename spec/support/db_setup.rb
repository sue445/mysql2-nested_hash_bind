def db
  @db ||= Mysql2::Client.new(
    host: ENV.fetch("MYSQL_HOST", "127.0.0.1"),
    port: ENV.fetch("MYSQL_PORT", "3306"),
    username: ENV.fetch("MYSQL_USERNAME"),
    database: ENV.fetch("MYSQL_DATABASE"),
    password: ENV.fetch("MYSQL_PASSWORD", ""),
    charset: "utf8mb4",
    database_timezone: :local,
    cast_booleans: true,
    symbolize_keys: true,
    reconnect: true,
  )
end

def up_migrate
  db.query(<<~SQL)
    CREATE TABLE `users` (
      `id` int NOT NULL AUTO_INCREMENT,
      `account_name` varchar(64) NOT NULL,
      `passhash` varchar(128) NOT NULL,
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
      `mime` varchar(64) NOT NULL,
      `imgdata` mediumblob NOT NULL,
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
