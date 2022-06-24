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
          return rows unless rows&.first&.keys&.any? { |column_name| __include_column_name_dot?(column_name) }

          # NOTE: Caching result of `column_name.split`
          columns_cache = __split_columns(rows.first.keys)

          rows.map { |row| __transform_row(row: row, columns_cache: columns_cache) }
        end

        # @param column_names [Array<String,Symbol>]
        # @return [Hash{String,Symbol=>Array<String,Symbol>}]
        def __split_columns(column_names)
          column_names.each_with_object({}) do |column_name, hash|
            str_key = column_name.respond_to?(:name) ? column_name.name : column_name
            parent_key, child_key = *str_key.split(".", 2)

            next unless child_key

            if query_options[:symbolize_keys]
              parent_key = parent_key.to_sym
              child_key = child_key.to_sym
            end

            hash[column_name] = { parent_key: parent_key, child_key: child_key }
          end
        end

        # @param column_name [String,Symbol]
        # @return [Boolean]
        def __include_column_name_dot?(column_name)
          # NOTE: Call Symbol#name if possible
          return column_name.name.include?(".") if column_name.respond_to?(:name)

          column_name.include?(".")
        end

        # @param row [Hash]
        # @param columns_cache [Hash{String,Symbol=>Array<String,Symbol>}]
        #
        # @return [Hash]
        def __transform_row(row:, columns_cache:)
          row.each_with_object({}) do |(k, v), new_row|
            if columns_cache[k]
              __update_for_nested_hash(row: new_row, key: k, value: v, columns_cache: columns_cache)
            else
              new_row[k] = v
            end
          end
        end

        # @param row [Hash]
        # @param key [String,Symbol]
        # @param value [Object]
        # @param columns_cache [Hash{String,Symbol=>Array<String,Symbol>}]
        def __update_for_nested_hash(row:, key:, value:, columns_cache:)
          parent_key = columns_cache[key][:parent_key]
          child_key = columns_cache[key][:child_key]

          row[parent_key] ||= {}
          row[parent_key][child_key] = value
        end
      end
    end
  end
end
