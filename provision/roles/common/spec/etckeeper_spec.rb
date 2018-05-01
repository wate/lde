require 'spec_helper'

describe package('etckeeper') do
  it { should be_installed }
end
