require 'active_record'
require 'active_record/relation'
require 'postgres_ext/active_record/relation'
require 'postgres_ext/active_record/cte_proxy'

gdep = Gem::Dependency.new('activerecord', '~> 5.0.0')
ar_version_cutoff = gdep.matching_specs.sort_by(&:version).last

if ar_version_cutoff
  require 'postgres_ext/active_record/5.0/connection_adapters/postgresql_adapter'
  require 'postgres_ext/active_record/5.0/query_methods'
  require 'postgres_ext/active_record/5.0/querying'
  require 'postgres_ext/active_record/5.0/relation'
else
  require 'postgres_ext/active_record/4.x/query_methods'
  require 'postgres_ext/active_record/4.x/querying'
end