require 'spec_helper'

describe 'role python' do
  property['python_packages'].each do |pkg|
    describe package(pkg) do
      it { should be_installed }
    end
  end
end
