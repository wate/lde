require 'spec_helper'

describe 'role ruby' do
  property['ruby_packages'].each do |pkg|
    describe package(pkg) do
      it { should be_installed }
    end
  end
end
