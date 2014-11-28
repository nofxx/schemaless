require 'spec_helper'

describe 'Index' do

  it 'should instantiate' do
    expect { Schemaless::Index.new('bikes', :foo) }.to_not raise_error
  end

end
