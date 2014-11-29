# -*- coding: utf-8 -*-
require 'spec_helper'

describe 'Schemaless' do

  it 'should get all models`s fields' do
    pending
    expect(Schemaless.schema.keys).to include('Bike')
  end

  # it 'should get all models`s fields' do
  #   expect(Schemaless.schema['Bike'][:model]).to eq(Bike)
  # end

  # it 'should not include primary keys' do
  #   expect(Schemaless.schema['Bike'][:attr_schema]).to include('cc')
  # end

  # it 'should get schemaless types' do
  #   expect(Schemaless.schema['Bike'][:attr_schema]['cc']).to eq(:integer)
  # end

  # it 'should get all models`s fields' do
  #   expect(Schemaless.schema['User'][:index_db]).to be_an(Array)
  # end

  # it 'should get all models`s fields' do
  #   expect(Schemaless.schema['User'][:index_schema]).to be_an(Array)
  # end

  # it 'should get all models`s fields' do
  #   expect(Schemaless.schema['User'][:index_schema]).to eq([])
  # end

end
