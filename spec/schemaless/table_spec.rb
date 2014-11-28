require 'spec_helper'

describe 'Schemaless::Table' do

  it 'should instantiate' do
    test = ::ActiveRecord::Base.descendants.last
    expect { Schemaless::Table.new(test) }.to_not raise_error
  end

end
