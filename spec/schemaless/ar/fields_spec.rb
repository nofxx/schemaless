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
end
