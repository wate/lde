require 'spec_helper'

describe file('/etc/skel/public') do
  it { should exist }
  it { should be_directory }
  it { should be_mode 755 }
end

puts property['postfix_cfg']
if property.key?('postfix_cfg') && property['postfix_cfg'].key?('home_mailbox')
  if property['postfix_cfg']['home_mailbox'] == 'Maildir/'
    %w[Maildir Maildir/new Maildir/cur Maildir/tmp].each do |dir_name|
      describe file('/etc/skel/' + dir_name) do
        it { should exist }
        it { should be_directory }
        it { should be_mode 700 }
      end
    end
  end
end
