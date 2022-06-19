# frozen_string_literal: true

require_relative "bind/version"
require_relative "bind/query_extension"

module Mysql2
  module Response
    module Bind
      class Error < StandardError; end
      # Your code goes here...
    end
  end
end
