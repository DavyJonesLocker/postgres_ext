module ActiveRecord
  class Result

    private
    def hash_rows
      @hash_rows ||=
        begin
          columns = @columns.map { |c| c.dup.freeze }
          @rows.map { |row|
            Hash[columns.zip(row)].inject({}) { |memo, (k, v)|
              memo[k] = @column_types[k].type_cast(v)
              memo
            }
          }
        end
    end
  end
end
