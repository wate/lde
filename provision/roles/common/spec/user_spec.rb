require 'spec_helper'

property['common_groups'].each do |group|
  describe group(group['name']) do
    is_removed = group.key?('remove') && group['remove']
    if is_removed
      it { should_not exist }
    else
      it { should exist }
      it { should have_gid group['id'] } if group.key?('id')
    end
  end
end

property['common_users'].each do |user|
  describe user(user['name']) do
    is_removed = user.key?('remove') && user['remove']
    if is_removed
      it { should_not exist }
    else
      it { should exist }
      it { should have_login_shell user['shell'] } if user.key?('shell')
      if user.key?('groups')
        user['groups'].each do |group_name|
          it { should belong_to_group group_name }
        end
      end
      it { should have_uid user['id'] } if user.key?('id')
      it { should have_home_directory user['home'] } if user.key?('home')
      it { should belong_to_group 'wheel' } if user.key?('admin') && user['admin']
      its(:encrypted_password) { should match(/^!!$/) } if user.key?('system') && user['system']
      user_shell = user['shell'] || '/bin/bash'
      it { should have_login_shell user_shell }
    end
  end
end

describe user('root') do
  if property['common_root_lock']
    its(:encrypted_password) { should match(/^!/) }
  else
    its(:encrypted_password) { should_not match(/^!/) }
  end
end
