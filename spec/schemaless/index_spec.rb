require 'spec_helper'

describe 'Schemaless::Index' do

  it 'should instantiate' do
    expect { Schemaless::Index.new(:foo) }.to_not raise_error
  end

end
