module PostgresExt
  module ActiveRecord
    module ConnectionAdapters
      module PostgreSQLAdapter
        def add_function(name, definition, options)
          return_type = "RETURNS #{options[:returns] || 'VOID'}"
          language = "LANGUAGE #{options[:language] || 'plpgsql'}"
          execute <<-SQL
CREATE FUNCTION #{name}() #{return_type}
  #{language}
  AS $$
#{definition}
$$;
SQL
# DECLARE
  # subcategory_name varchar(255);
  # skills_list text;
  # highest_education_details text;
  # instructor_name varchar(255);
# BEGIN
  # SELECT first_name || last_name INTO instructor_name FROM users WHERE id = new.user_id;
  # SELECT name INTO subcategory_name FROM subcategories WHERE id = new.subcategory_id;
  # SELECT title || COALESCE(institution, '') || COALESCE(description, '') INTO highest_education_details FROM education_levels WHERE id = new.highest_education_level_id;
  # SELECT COALESCE(array_to_string(array_agg(name), ' '), '') INTO skills_list FROM skills WHERE instructor_profile_id = new.id;

  # new.search_vector :=
     # setweight(to_tsvector('pg_catalog.english', COALESCE(new.title, '')), 'A') ||
     # setweight(to_tsvector('pg_catalog.english', COALESCE(subcategory_name, '')), 'A') ||
     # setweight(to_tsvector('pg_catalog.english', COALESCE(instructor_name, '')), 'A') ||
     # setweight(to_tsvector('pg_catalog.english', COALESCE(new.selling_point, '')), 'B') ||
     # setweight(to_tsvector('pg_catalog.english', COALESCE(new.why_do_you_love_this, '')), 'B') ||
     # setweight(to_tsvector('pg_catalog.english', COALESCE(new.working_on_now, '')), 'B') ||
     # setweight(to_tsvector('pg_catalog.english', COALESCE(new.neatest_personal_achievement, '')), 'B') ||
     # setweight(to_tsvector('pg_catalog.english', COALESCE(new.neatest_student_achievement, '')), 'B') ||
     # setweight(to_tsvector('pg_catalog.english', COALESCE(skills_list, '')), 'B') ||
     # setweight(to_tsvector('pg_catalog.english', COALESCE(new.session_description, '')), 'B') ||
     # setweight(to_tsvector('pg_catalog.english', COALESCE(highest_education_details, '')), 'B')
     # ;
  # return new;
# END
# $$;

        end
      end
    end
  end
end
