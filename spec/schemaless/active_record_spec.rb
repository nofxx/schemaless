# -*- coding: utf-8 -*-
require 'spec_helper'

describe 'Schemaless' do

  it 'should respond to schemaless' do
    expect(ActiveRecord::Base).to respond_to :field
  end

  it 'should get all models`s fields' do
    bike_model = { "Bike" => { cc: String } }
    expect(Schemaless.schema.keys).to include("Bike")
  end

  it 'should get all models`s fields' do
    bike_model = { "Bike" => { cc: String } }
    expect(Schemaless.schema.keys).to include("Bike")
  end

  #   u = User.create(name: 'Bob', other: :bar, status: :inactive, so: :mac, gui: :gtk, language: :en, sex: false, cool: false)
  #   expect(u.errors.messages).to be_blank
  # end

  # it 'should work fine on create' do
  #   u = User.create(name: 'Bob', other: :bar, status: :inactive, so: :mac, gui: :gtk, language: :en, sex: false, cool: false)
  #   expect(User.count).to eq 1
  # end
  # it 'should work nice with default values from active model' do
  #   u = User.create(name: 'Niu', other: :bar, so: :mac, gui: :gtk, language: :en, sex: false, cool: false)
  #   expect(u.errors.messages).to be_blank
  #   expect(u.status).to eql(:active)
  #   expect(u).to be_active
  # end

  # describe 'User Instantiated' do
  #   subject do
  #     User.create(:name => 'Anna', :other => :fo, :status => status, :so => so, :gui => :qt, :language => :pt, :sex => true, :cool => true)
  #   end
  #   let(:status) { :active }
  #   let(:so) { :linux }

end
