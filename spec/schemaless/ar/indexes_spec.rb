# -*- coding: utf-8 -*-
require 'spec_helper'

describe 'Schemaless' do
  it 'should get all models`s fields' do
    expect(Bike.schemaless_indexes).to be_an(Array)
  end


  it 'should respond to schemaless' do
    expect(ActiveRecord::Base).to respond_to :index
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

  #   u = User.create(name: 'Bob', other: :bar, status: :inactive, cool: false)
  #   expect(u.errors.messages).to be_blank
  # end

  # it 'should work fine on create' do
  #   u = User.create(name: 'Bob')
  #   expect(User.count).to eq 1
  # end
end
