RSpec.shared_context :database, shared_context: :metadata do
  let(:db) do
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

  let(:symbolize_keys) { true }

  around(:each) do |example|
    db_transaction do
      example.run
    end
  end

  def db_transaction
    db.query("BEGIN")
    yield
  ensure
    db.query('ROLLBACK')
  end
end
