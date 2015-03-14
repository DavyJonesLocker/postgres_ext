require 'spec_helper'

describe '#add_extension' do
  let!(:connection) { ActiveRecord::Base.connection }
  before(:each) do
    connection.execute("DROP EXTENSION IF EXISTS #{extension}")
  end

  context 'pg_trgm' do
    let(:extension) { 'pg_trgm' }

    it 'adds the extension' do
      expect{connection.add_extension(extension)}
        .to change(&extension_exists?)
        .from(false)
        .to(true)
    end

    it 'clears the available index opclasses' do
      expect{connection.add_extension(extension)}
        .to change(&trigram_opclasses_available?)
        .from(false)
        .to(true)
    end

    def trigram_opclasses_available?
      lambda do
        trigram_opclasses = %w[gist_trgm_ops gin_trgm_ops]
        (connection.opclasses & trigram_opclasses).any?
      end
    end
  end

  def extension_exists?
    lambda do
      connection.select_rows("select * from pg_extension where extname='#{extension}'").any?
    end
  end
end
