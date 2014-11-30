# -*- coding: utf-8 -*-
require 'spec_helper'

describe 'Schemaless' do

  it 'should get all models`s fields' do
    expect(Bike.schemaless_indexes).to be_an(Array)
  end

  it 'should get all models`s fields' do
    # bike_model = { 'Bike' => { cc: String } }
    expect(Bike.schemaless_indexes.map(&:fields)).to include([:cc])
  end

  it 'should respond to schemaless' do
    expect(ActiveRecord::Base).to respond_to :index
  end

  it 'should get current indexes' do
    expect(User.current_indexes).to be_an(Array)
  end

  #   u = User.create(name: 'Bob', other: :bar, status: :inactive, cool: false)
  #   expect(u.errors.messages).to be_blank
  # end

  # it 'should work fine on create' do
  #   u = User.create(name: 'Bob')
  #   expect(User.count).to eq 1
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
