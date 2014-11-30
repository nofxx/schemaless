# -*- coding: utf-8 -*-
require 'spec_helper'

describe 'Schemaless' do
  it 'should respond to schemaless' do
    expect(ActiveRecord::Base).to respond_to :field
  end

  it 'should get all models`s fields' do
    expect(Bike.schemaless_fields.map(&:name)).to include('cylinders')
  end

  it 'should get all models`s fields' do
    # bike_model = { 'Bike' => { cc: String } }
    expect(Bike.schemaless_indexes.map(&:name)).to include('cc')
  end

  it 'should get a model current attributes' do
    expect(Bike.current_attributes.first).to be_a(::Schemaless::Field)
  end

  # it 'should get attribute type string' do
  #   expect(Bike.schemaless_fields[:attr_db]['name']).to eq(:string)
  # end

  # it 'should get attribute type integer' do
  #   expect(Schemaless.schema['Bike'][:attr_db]['cylinders']).to eq(:integer)
  # end

  # it 'should not include primary keys' do
  #   expect(Schemaless.schema['Bike'][:attr_db]).to_not include('id')
  # end

  # it 'should get all models`s fields' do
  #   expect(Schemaless.schema['Bike'][:model]).to eq(Bike)
  # end

  # it 'should not include primary keys' do
  #   expect(Schemaless.schema['Bike'][:attr_schema]).to include('cc')
  # end

  # it 'should get schemaless types' do
  #   expect(Schemaless.schema['Bike'][:attr_schema]['cc']).to eq(:integer)
  # end
end
