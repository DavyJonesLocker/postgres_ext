## 0.0.10

 * Fixes parsing of number arrays when they are set from a string array - Alexey Noskov (@alno)

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
