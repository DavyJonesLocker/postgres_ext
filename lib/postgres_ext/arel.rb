gdep4 = Gem::Dependency.new('activerecord', '~> 4.2.0')
ar_version_cutoff4 = gdep4.matching_specs.sort_by(&:version).last

gdep5 = Gem::Dependency.new('activerecord', '~> 5.0.0')
ar_version_cutoff5 = gdep5.matching_specs.sort_by(&:version).last

require 'postgres_ext/arel/nodes'

if ar_version_cutoff5
  require 'postgres_ext/arel/5.0/predications'
  require 'postgres_ext/arel/5.0/visitors'
elsif ar_version_cutoff4
  require 'postgres_ext/arel/4.2/predications'
  require 'postgres_ext/arel/4.2/visitors'
else
  require 'postgres_ext/arel/4.1/predications'
  require 'postgres_ext/arel/4.1/visitors'
end
