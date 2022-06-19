RSpec.shared_context :database, shared_context: :metadata do
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
