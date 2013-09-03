require 'spec_helper'

describe 'Common Table Expression queries' do
  describe '.with(common_table_expression_hash)' do
    it 'generates an expression with the CTE' do
      query = Person.with(lucky_number_seven: Person.where(lucky_number: 7)).joins('JOIN lucky_number_seven ON lucky_number_seven.id = people.id')
      query.to_sql.should eq 'WITH lucky_number_seven AS (SELECT "people".* FROM "people"  WHERE "people"."lucky_number" = 7) SELECT "people".* FROM "people" JOIN lucky_number_seven ON lucky_number_seven.id = people.id'
    end

    it 'generates an expression with multiple CTEs' do
      query = Person.with(lucky_number_seven: Person.where(lucky_number: 7), lucky_number_three: Person.where(lucky_number: 3)).joins('JOIN lucky_number_seven ON lucky_number_seven.id = people.id').joins('JOIN lucky_number_three ON lucky_number_three.id = people.id')
      query.to_sql.should eq 'WITH lucky_number_seven AS (SELECT "people".* FROM "people"  WHERE "people"."lucky_number" = 7), lucky_number_three AS (SELECT "people".* FROM "people"  WHERE "people"."lucky_number" = 3) SELECT "people".* FROM "people" JOIN lucky_number_seven ON lucky_number_seven.id = people.id JOIN lucky_number_three ON lucky_number_three.id = people.id'
    end

    it 'generates an expression with multiple with calls' do
      query = Person.with(lucky_number_seven: Person.where(lucky_number: 7)).with(lucky_number_three: Person.where(lucky_number: 3)).joins('JOIN lucky_number_seven ON lucky_number_seven.id = people.id').joins('JOIN lucky_number_three ON lucky_number_three.id = people.id')
      query.to_sql.should eq 'WITH lucky_number_seven AS (SELECT "people".* FROM "people"  WHERE "people"."lucky_number" = 7), lucky_number_three AS (SELECT "people".* FROM "people"  WHERE "people"."lucky_number" = 3) SELECT "people".* FROM "people" JOIN lucky_number_seven ON lucky_number_seven.id = people.id JOIN lucky_number_three ON lucky_number_three.id = people.id'
    end
  end

  describe '.from_cte(common_table_expression_hash)' do
    it 'generates an expression with the CTE as the main table' do
      query = Person.from_cte('lucky_number_seven', Person.where(lucky_number: 7)).where(id: 5)
      query.to_sql.should eq 'WITH lucky_number_seven AS (SELECT "people".* FROM "people"  WHERE "people"."lucky_number" = 7) SELECT "lucky_number_seven".* FROM "lucky_number_seven"  WHERE "lucky_number_seven"."id" = 5'
    end

    it 'returns instances of the model' do
      3.times { Person.create! lucky_number: 7 }
      3.times { Person.create! lucky_number: 3 }
      people = Person.from_cte('lucky_number_seven', Person.where(lucky_number: 7))

      people.count.should eq 3
    end
  end
end
