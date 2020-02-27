require 'spec_helper'

describe 'Python' do
  %w[python-setuptools python2-pip python-devel].each do |pkg|
    describe package(pkg) do
      it { should be_installed }
    end
  end
end
