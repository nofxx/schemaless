require 'spec_helper'

describe 'Field' do

  describe 'Field mapping' do

    it 'should map field integer' do
      expect(Schemaless::Field.new('bikes', 'cc', Integer).type)
        .to eq(:integer)
    end

  end

end
