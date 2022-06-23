# frozen_string_literal: true

module DatabaseHelper
  # @param symbolize_keys [Boolean]
  # @return [Mysql2::Client]
  def self.client(symbolize_keys: true)
    Mysql2::Client.new(
      host: ENV.fetch("MYSQL_HOST", "127.0.0.1"),
      port: ENV.fetch("MYSQL_PORT", "3306"),
      username: ENV.fetch("MYSQL_USERNAME"),
      database: ENV.fetch("MYSQL_DATABASE"),
      password: ENV.fetch("MYSQL_PASSWORD", ""),
      charset: "utf8mb4",
      database_timezone: :local,
      cast_booleans: true,
      symbolize_keys: symbolize_keys,
      reconnect: true,
    )
  end
end
