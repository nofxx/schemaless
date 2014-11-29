# -*- coding: utf-8 -*-
require 'spec_helper'

describe 'Schemaless' do

  it 'should get all models`s fields' do
    expect(Schemaless).to be_an(Module)
  end

  it 'should have a sandbox mode' do
    Schemaless.sandbox = true
    expect(Schemaless.sandbox).to eq(true)
  end

end
