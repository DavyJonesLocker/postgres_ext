module PostgresExt
  module PgArrayConvert
    def convert_pg_array(pg_array)
      pg_array.gsub(/[(^\{)|(\}$)|(")]/, '').split(',').map(&:strip)
    end
  end

  module PgArrayRevert
    def revert_pg_array(array)
      if array.empty?
        nil
      else
        "{#{array.join(', ')}}"
      end
    end
  end
end
