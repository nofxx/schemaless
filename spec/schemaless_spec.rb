# -*- coding: utf-8 -*-
require 'spec_helper'

describe 'Schemaless' do

  it 'should get all models`s fields' do
    expect(Schemaless.schema.keys).to include("Bike")
  end

  it 'should get all models`s fields' do
    expect(Schemaless.schema["Bike"][:table]).to eq("bikes")
  end

  it 'should get attribute type string' do
    expect(Schemaless.schema["Bike"][:attributes]["name"]).to eq(:string)
  end

  it 'should get attribute type integer' do
    expect(Schemaless.schema["Bike"][:attributes]).to eq(:integer)
  end

  it 'should not include primary keys' do
    expect(Schemaless.schema["Bike"][:attributes]).to_not include("id")
  end

  it 'should not include primary keys' do
    expect(Schemaless.schema["Bike"][:schemaless]).to include("cc")
  end

  it 'should get schemaless types' do
    expect(Schemaless.schema["Bike"][:schemaless]["cc"]).to eq(:integer)
  end

  describe "Field mapping" do

    it 'should map field integer' do
      expect(Schemaless.map_field(Integer)).to eq(:integer)
    end

  end

end
