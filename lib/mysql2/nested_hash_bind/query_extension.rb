# frozen_string_literal: true

module Mysql2
  module NestedHashBind
    # Apply patches to `Mysql2::Client#query` and `Mysql2::Client#xquery`
    module QueryExtension
      # @!method query(sql, **options)
      #
      # @param sql [String]
      # @param options [Hash]
      #
      # @return [Array<Hash>] Exists columns containing dots
      # @return [Mysql2::Result] No columns containing dots (This is the original behavior of `Mysql2::Client#query`)
      # @return [nil] No response was returned. (e.g. `ROLLBACK`)
      #
      # @see https://www.rubydoc.info/gems/mysql2/Mysql2/Client#query-instance_method

      # @!method xquery(sql, *args, **options)
      #
      # @param sql [String]
      # @param args [Array]
      # @param options [Hash]
      #
      # @return [Array<Hash>] Exists columns containing dots
      # @return [Mysql2::Result] No columns containing dots (This is the original behavior of `Mysql2::Client#xquery`)
      # @return [nil] No response was returned. (e.g. `ROLLBACK`)
      #
      # @see https://rubydoc.info/gems/mysql2-cs-bind/Mysql2/Client#xquery-instance_method

      refine(Mysql2::Client) do
        # @param sql [String]
        # @param options [Hash]
        #
        # @return [Array<Hash>] Exists columns containing dots
        # @return [Mysql2::Result] No columns containing dots (This is the original behavior of `Mysql2::Client#query`)
        # @return [nil] No response was returned. (e.g. `ROLLBACK`)
        def query_with_bind(sql, **options)
          rows = query_without_bind(sql, **options)

          __transform_rows(rows)
        end

        alias_method :query_without_bind, :query
        alias_method :query, :query_with_bind

        # @param sql [String]
        # @param args [Array]
        # @param options [Hash]
        #
        # @return [Array<Hash>] Exists columns containing dots
        # @return [Mysql2::Result] No columns containing dots (This is the original behavior of `Mysql2::Client#xquery`)
        # @return [nil] No response was returned. (e.g. `ROLLBACK`)
        def xquery_with_bind(sql, *args, **options)
          rows = xquery_without_bind(sql, *args, **options)

          __transform_rows(rows)
        end

        alias_method :xquery_without_bind, :xquery
        alias_method :xquery, :xquery_with_bind

        private

        # @param [Mysql2::Result,nil] rows
        #
        # @return [Array<Hash>] Exists columns containing dots
        # @return [Mysql2::Result] No columns containing dots
        #                          (This is the original behavior of `Mysql2::Client#query` and `Mysql2::Client#xquery`)
        # @return [nil] No response was returned. (e.g. `ROLLBACK`)
        def __transform_rows(rows)
          # No columns containing dots
          return rows unless rows&.first&.keys&.any? { |column_name| column_name.to_s.include?(".") }

          rows.map { |row| __transform_row(row) }
        end

        # @param row [Hash]
        #
        # @return [Hash]
        def __transform_row(row)
          row.each_with_object({}) do |(k, v), new_row|
            str_key = k.to_s
            if str_key.include?(".")
              __update_for_nested_hash(row: new_row, key: str_key, value: v)
            else
              new_row[k] = v
            end
          end
        end

        # @param row [Hash]
        # @param key [String]
        # @param value [Object]
        def __update_for_nested_hash(row:, key:, value:)
          parent_key, child_key = *key.split(".", 2)

          if query_options[:symbolize_keys]
            parent_key = parent_key.to_sym
            child_key = child_key.to_sym
          end

          row[parent_key] ||= {}
          row[parent_key][child_key] = value
        end
      end
    end
  end
end
