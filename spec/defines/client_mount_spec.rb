require 'spec_helper'

describe 'nfs::client::mount', type: 'define' do
  context 'nfs_v4 => false, minimal arguments' do
    let(:facts) { {
      operatingsystem: 'Ubuntu',
      osfamily: 'Debian',
      operatingsystemmajrelease: '12.04',
      lsbdistcodename: 'precise',
      concat_basedir: '/dne',
      clientcert: 'example.com',
      is_pe: false,
      id: 'root',
      path: '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
    } }
    let(:title) { '/srv/test' }

    let(:pre_condition) { 'class {"nfs": client_enabled => true,}' }

    let(:params) { { server: '1.2.3.4' } }
    it { should contain_nfs__functions__mkdir('/srv/test') }
    it { should contain_mount('shared /srv/test by 1.2.3.4 on /srv/test') }
  end

  context 'nfs_v4 => false, specified mountpoint and sharename' do
    let(:facts) { {
      operatingsystem: 'Ubuntu',
      osfamily: 'Debian',
      operatingsystemmajrelease: '12.04',
      lsbdistcodename: 'precise',
      concat_basedir: '/dne',
      clientcert: 'example.com',
      is_pe: false,
      id: 'root',
      path: '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
    } }
    let(:title) { 'Import /srv' }

    let(:pre_condition) { 'class {"nfs": client_enabled => true,}' }

    let(:params) { { share: '/export/srv', mount: '/srv', server: '1.2.3.4' } }
    it { should contain_nfs__functions__mkdir('/srv') }
    it { should contain_mount('shared /export/srv by 1.2.3.4 on /srv') }
  end

  context 'nfs_v4 => true, specified share' do
    let(:facts) { {
      operatingsystem: 'Ubuntu',
      osfamily: 'Debian',
      operatingsystemmajrelease: '12.04',
      lsbdistcodename: 'precise',
      concat_basedir: '/dne',
      clientcert: 'example.com',
      is_pe: false,
      id: 'root',
      path: '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
    } }
    let(:title) { '/srv/test' }

    let(:pre_condition) { 'class {"nfs": client_enabled => true, nfs_v4_client => true }' }

    let(:params) { { share: 'test', server: '1.2.3.4' } }
    it { should contain_nfs__functions__mkdir('/srv/test') }
    it { should contain_mount('shared /test by 1.2.3.4 on /srv/test') }
  end

  context 'nfs_v4 => true, minimal arguments' do
    let(:facts) { {
      operatingsystem: 'Ubuntu',
      osfamily: 'Debian',
      operatingsystemmajrelease: '12.04',
      lsbdistcodename: 'precise',
      concat_basedir: '/dne',
      clientcert: 'example.com',
      is_pe: false,
      id: 'root',
      path: '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
    } }
    let(:title) { '/srv/test' }

    let(:pre_condition) { 'class {"nfs": client_enabled => true, nfs_v4_client => true }' }

    let(:params) { { server: '1.2.3.4' } }
    it { should contain_nfs__functions__mkdir('/srv/test') }
    it { should contain_mount('shared /test by 1.2.3.4 on /srv/test') }
  end

  context 'nfs_v4 => true, non-default mountpoints' do
    let(:facts) { {
      operatingsystem: 'Ubuntu',
      osfamily: 'Debian',
      operatingsystemmajrelease: '12.04',
      lsbdistcodename: 'precise',
      concat_basedir: '/dne',
      clientcert: 'example.com',
      is_pe: false,
      id: 'root',
      path: '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
    } }
    let(:title) { '/opt/sample' }

    let(:pre_condition) { 'class {"nfs": client_enabled => true, nfs_v4_client => true }' }

    let(:params) { { share: 'test', server: '1.2.3.4' } }
    it { should contain_nfs__functions__mkdir('/opt/sample') }
    it { should contain_mount('shared /test by 1.2.3.4 on /opt/sample') }
  end
end
