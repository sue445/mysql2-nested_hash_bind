module Mysql2
  module Response
    module Bind
      module QueryExtension
        refine(Mysql2::Client) do
          # @param sql [String]
          # @param options [Array]
          # @return [Array,nil]
          def query_with_bind(sql, **options)
            rows = query_without_bind(sql, options)

            return rows.map { |row| transform_row(row) } if rows

            rows
          end

          alias_method :query_without_bind, :query
          alias_method :query, :query_with_bind

          private

          def transform_row(row)
            row.each_with_object({}) do |(k, v), new_row|
              str_key = k.to_s
              if str_key.include?(".")
                parent_key, child_key = *str_key.split(".", 2)

                if query_options[:symbolize_keys]
                  parent_key = parent_key.to_sym
                  child_key = child_key.to_sym
                end

                new_row[parent_key] ||= {}
                new_row[parent_key][child_key] = v
              else
                new_row[k] = v
              end
            end
          end
        end
      end
    end
  end
end
