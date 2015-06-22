require 'spec_helper'

describe 'nfs::client::mount', :type => 'define' do

  context "nvs_v4 => false" do
    let(:facts) {{
      :operatingsystem => 'Ubuntu',
      :osfamily => 'Debian',
      :operatingsystemmajrelease => '12.04',
      :concat_basedir => '/dne',
      :clientcert => 'example.com',
      :is_pe => false,
      :id => 'root',
      :path => '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
    }}
    let(:title) { '/srv/test' }

    let(:pre_condition) { 'class {"nfs": client_enabled => true,}'}

    let(:params) {{ :share => 'test', :server => '1.2.3.4' } }
    it { should contain_nfs__functions__mkdir('/srv/test') }
    it { should contain_mount('shared test by example.com on /srv/test') }
  end

  context "nvs_v4 => true" do
    let(:facts) {{
      :operatingsystem => 'Ubuntu',
      :osfamily => 'Debian',
      :operatingsystemmajrelease => '12.04',
      :concat_basedir => '/dne',
      :clientcert => 'example.com',
      :is_pe => false,
      :id => 'root',
      :path => '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
    }}
    let(:title) { '/srv/test' }

    let(:pre_condition) { 'class {"nfs": client_enabled => true, nfs_v4 => true }'}

    let(:params) {{ :share => 'test', :server => '1.2.3.4' } }
    it { should contain_nfs__functions__mkdir('/srv/test') }
    it { should contain_mount('shared test by example.com on /srv/test') }
  end

end