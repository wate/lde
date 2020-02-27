require 'spec_helper'

describe 'Ruby' do
  %w[ruby ruby-devel rubygems].each do |pkg|
    describe package(pkg) do
      it { should be_installed }
    end
  end
end
