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
