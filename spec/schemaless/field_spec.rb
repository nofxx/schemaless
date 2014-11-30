require 'spec_helper'

describe 'Field' do

  it 'should have a name' do
    expect(Schemaless::Field.new('cc', Integer).name).to eq('cc')
  end

  it 'should have a type' do
    expect(Schemaless::Field.new('cc', Integer).type).to eq('cc')
  end


  describe 'Field mapping' do

    it 'should map field integer' do
      expect(Schemaless::Field.new('cc', Integer).type).to eq(:integer)
    end

    it 'should map field decimal' do
      expect(Schemaless::Field.new('cc', BigDecimal).type).to eq(:decimal)
    end

    it 'should map field float' do
      expect(Schemaless::Field.new('cc', Float).type).to eq(:float)
    end

  end

end
