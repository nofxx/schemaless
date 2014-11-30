require 'spec_helper'

describe 'Schemaless::Table' do

  before do
    @app = ::ActiveRecord::Base.descendants
  end

  it 'should instantiate' do
    expect { Schemaless::Table.new(@app.last) }.to_not raise_error
  end

  # it "should create tables nice" do
  #   expect(Schemaless::Table.new(@app.last)).to include(Bike)
  # end

  it 'should create tables nice' do
    expect(Schemaless::Table.new(@app[1]).model).to eq(Place)
  end

  it 'should create tables nice' do
    expect(Schemaless::Table.new(@app[1]).name).to eq('places')
  end

end
