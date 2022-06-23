# frozen_string_literal: true

RSpec.shared_context :database, shared_context: :metadata do
  let(:db) do
    DatabaseHelper.client(symbolize_keys: symbolize_keys)
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
    # Clear records after test
    db.query("ROLLBACK")
  end
end
