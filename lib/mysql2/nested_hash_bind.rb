# frozen_string_literal: true

require "mysql2"
require "mysql2-cs-bind"

require_relative "nested_hash_bind/version"
require_relative "nested_hash_bind/query_extension"

module Mysql2
  module NestedHashBind
    class Error < StandardError; end
    # Your code goes here...
  end
end
