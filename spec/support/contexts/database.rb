RSpec.shared_context :database, shared_context: :metadata do
  before(:all) do
    down_migrate
  end

  around(:each) do |example|
    up_migrate

    example.run

    down_migrate
  end
end
