RSpec.shared_context :database, shared_context: :metadata do
  around(:each) do |example|
    # TODO: up migrate

    example.run

    # TODO: down migrate
  end
end
