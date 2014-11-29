# -*- coding: utf-8 -*-
require 'spec_helper'

describe 'Schemaless::Worker' do

  it 'should create cc on bikes' do
    Schemaless::Worker.run!
    expect { Bike.create!(name: 'Gina', cc: 600) }.to_not raise_error
    expect(Bike.count).to eq(1)
  end

  it 'should work in sandbox mode' do
    # Schemaless.sandbox = true
    Schemaless::Worker.generate!
    expect { Bike.create!(name: 'Gina', cc: 600) }.to raise_error
    expect(Bike.count).to be_zero
  end

  it 'should create a foreign key with belongs_to' do
    Schemaless::Worker.run!
    user = User.create!(name: 'Lemmy')
    expect { Bike.create(name: 'Dark', user: user)  }.to_not raise_error
  end

  describe 'Field creation' do

    it 'should create table if inexistant' do
      # ActiveRecord::Migration.drop_table(:bikes)
      Schemaless::Worker.run!
      expect { Bike.create!(name: 'Gina', cc: 600) }.to_not raise_error
      expect(Bike.count).to eq(1)
    end

  end
end
