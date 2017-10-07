require 'serverspec'

# Required by serverspec
set :backend, :exec

describe package('fail2ban') do
  it { should be_installed }
end

describe service('fail2ban') do
  it { should be_enabled }
  it { should be_running }
end

describe file('/etc/fail2ban/fail2ban.conf') do
  it { should exist }
  it { should be_file }
  it { should be_mode 644 }
  it { should be_owned_by 'root' }
  it { should be_grouped_into 'root' }
  if host_inventory['platform_version'] == "8"
    its(:content) { should match /^loglevel = 3/ }
  elsif host_inventory['platform_version'] == "9"
    its(:content) { should match /^loglevel = INFO/ }
  end
  its(:content) { should match /^logtarget = SYSLOG/ }
  its(:content) { should match /^socket = \/var\/run\/fail2ban\/fail2ban.sock/ }
  its(:content) { should match /^pidfile = \/var\/run\/fail2ban\/fail2ban.pid/ }
end

describe file('/etc/default/fail2ban') do
  it { should exist }
  it { should be_file }
  it { should be_mode 644 }
  it { should be_owned_by 'root' }
  it { should be_grouped_into 'root' }
  its(:content) { should match /^FAIL2BAN_OPTS=""/ }
end


describe file('/etc/fail2ban/jail.conf') do
  it { should exist }
  it { should be_file }
  it { should be_mode 644 }
  it { should be_owned_by 'root' }
  it { should be_grouped_into 'root' }
  if host_inventory['platform_version'] == "8"
    its(:content) { should match /nginx-internet-filter/ }
  end
end

describe file('/etc/fail2ban/filter.d/nginx-internet-filter.conf') do
  it { should exist }
  it { should be_file }
  it { should be_mode 644 }
  it { should be_owned_by 'root' }
  it { should be_grouped_into 'root' }
  its(:content) { should match /Author : Jonathan Leal/ }
end

describe file('/etc/fail2ban/filter.d/blacklist.conf') do
  it { should exist }
  it { should be_file }
  it { should be_mode 644 }
  it { should be_owned_by 'root' }
  it { should be_grouped_into 'root' }
  its(:content) { should match /failregex = NOTICE \\\[sshd\\\] Ban <HOST>/ }
end

describe file('/etc/fail2ban/jail.d/defaults-debian.conf') do
  it { should exist }
  it { should be_file }
  it { should be_mode 644 }
  it { should be_owned_by 'root' }
  it { should be_grouped_into 'root' }
  its(:content) { should match /\[sshd\]/ }
end

describe file('/etc/fail2ban/jail.d/blacklist.conf') do
  it { should exist }
  it { should be_file }
  it { should be_mode 644 }
  it { should be_owned_by 'root' }
  it { should be_grouped_into 'root' }
  its(:content) { should match /\[blacklist\]/ }
  its(:content) { should match /banaction = hostsdeny/ }
end

describe file('/etc/fail2ban/action.d/blacklist.conf') do
  it { should exist }
  it { should be_file }
  it { should be_mode 644 }
  it { should be_owned_by 'root' }
  it { should be_grouped_into 'root' }
  its(:content) { should match /\[Definition\]/ }
  its(:content) { should match /\[Init\]/ }
end
