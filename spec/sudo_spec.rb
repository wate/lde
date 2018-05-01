require 'spec_helper'

describe file('/etc/sudoers.d/wheel') do
  it { should exist }
  it { should be_file }
  if property['sudo_require_password']
    it { should contain '%wheel ALL=(ALL) ' }
    it { should_not contain '%wheel ALL=(ALL) NOPASSWD: ALL' }
  else
    it { should contain '%wheel ALL=(ALL) NOPASSWD: ALL' }
  end
end
