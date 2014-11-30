require 'spec_helper'

describe 'MigrationGenerator' do

  it 'should generate a nice migration for the app' do
    expect { Schemaless::Worker.generate! }.to_not raise_error
  end

  it 'should generate a nice migration for the app' do
    pending
    Schemaless::MigrationGenerator.new(['rock'], data).invoke
  end

end
