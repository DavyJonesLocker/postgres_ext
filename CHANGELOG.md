## 0.3.1

 * Fixes issue with array -> string code - Dan McClain
 * Adds support for ISN types - Ezekiel Templin
 * Fix for Squeel compatibility - Alexander Borovsky

## 0.3.0

 * Adds support to create indexes concurrently  -  Dan McClain
 * Changes using syntax, updates specs  -  Dan McClain
 * Empty strings are converted to nil by string_to_cidr_address -  Dan McClain
 * Replaced .symbolize with .to_sym in arel nodes.  -  OMCnet Development Team
 * Removes array_contains in favor of a column aware contains  -  Dan McClain
 * Renames Arel array_overlap to overlap  -  Dan McClain
 * Merge pull request #67 from jagregory/array_contains Array contains operator support -  Dan McClain
 * Update querying doc to include array_contains  -  James Gregory
 * Array contains operator ( @> ) support -  James Gregory
 * how to use SQL to convert string-delimited arrays in docs -  Turadg Aleahmad
 * Check if connection responds to #support_extensions? before invoking it  -  Dirk von Grünigen

## 0.2.2

 * Fixes issue with visit_Array monkey patch - Dan McClain (@danmcclain)

## 0.2.1

 * Fixes issue with citext change column calls - Dan McClain
(@danmcclain)

## 0.2.0

 * Introduces extensions to `ActiveRecord::Relation.where` to simplify
Array and INET/CIDR queries - Dan McClain (@danmcclain)
 * Fixes `where(:array => [1,2])` to use equailty instead of IN clauses
- Dan McClain (@danmcclain)
 * Adds Arel predicates for more network comparisons - Patrick Muldoon
(@doon)
 * Adds support for citext in migrations/schema.rb - Jonathan Younger
(@daikini)
 * Fixes text character encoding for text columns - Andy Monat (@amonat)
 * Cleans up alias_method_chains for better interoperability - Raido
Paaslepp (@legendetm)
 * Doc updates - Dan McClain, Caleb Woods (@danmcclain @calebwoods)

## 0.1.0

 * Performs PostgreSQL version check before attempting to dumpe
extensions - Dan McClain (@danmcclain)
 * Fixes issues with schema dumper when indexes have no index_opclass -
Mario Visic (@mariovisic)

## 0.0.10

 * Fixes parsing of number arrays when they are set from a string array - Alexey Noskov (@alno)
 * Cleans up spec organization  - Dan McClain (@danmcclain)
 * Adds support for index operator classes (:index_opclass) in
migrations and schema dumps - & Dan McClain (@danmcclain)
 * Fixes Arel Nodes created by postgres_ext  - Dan McClain (@danmcclain)
 * Add support to schema.rb to export and import extensions - Keenan
Brock (@kbrock)
 * Handles PostgreSQL strings when passed in as defaults by fixing the
quote method
 * Documentation updates. - Dan McClain & Doug Yun (@danmcclain
@duggieawesome)
 * Fixes #update_column calls - Dan McClain (@danmcclain)


## 0.0.9

 * Fixes #<attribute_name>?, Adds (pending) test case for #update_column - Dan McClain (@danmcclain)
 * Fix handing of pgsql arrays for the literal and argument-binding
cases - Michael Graff (@skandragon)
 * Fixes UTF-8 strings in string arrays are not returned as UTF-8
encoded strings - Michael Graff (@skandragon)
 * Documentation fixes - Michael Graff (@skandragon) and Dan McClain
(@danmcclain)
 * Properly encode strings stored in an array. - Michael Graff
(@skandragon)
 * Fixes integer array support - Keenan Brock (@kbrock)
 * Adds more robust index types with add_index options :index_type and :where. - Keenan Brock (@kbrock)

## 0.0.8

Fixes add and change column 

## 0.0.7

Adds Arel predicate functions for array overlap operator (`&&`) and
INET/CIDR contained within operator (`<<`)

## 0.0.6

Lots of array related fixes:
 * Model creation should no longer fail when not assigning a value to an
   array column
 * Array columns follow database defaults

Migration fix (rn0 and gilltots)  
Typos in README (bcardarella)
