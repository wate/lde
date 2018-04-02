require 'spec_helper'

describe file(property['pagegenerator_dest'] + '/README.md') do
  it { should exist }
  it { should be_file }
  it { should contain 'Bootstrap Page Generator' }
end
