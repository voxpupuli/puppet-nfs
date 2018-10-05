# frozen_string_literal: true

require 'spec_helper'

describe 'nfs::client::mount', type: 'define' do
  context 'when nfs_v4 => false, minimal arguments' do
    let(:facts) do
      {
        operatingsystem: 'Ubuntu',
        osfamily: 'Debian',
        operatingsystemmajrelease: '12.04',
        lsbdistcodename: 'precise',
        concat_basedir: '/dne',
        clientcert: 'example.com',
        is_pe: false,
        id: 'root',
        path: '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin'
      }
    end
    let(:title) { '/srv/test' }

    let(:pre_condition) { 'class { "nfs": client_enabled => true }' }

    let(:params) { { server: '1.2.3.4' } }

    it { is_expected.to contain_nfs__functions__mkdir('/srv/test') }
    it do
      is_expected.to contain_mount('shared /srv/test by 1.2.3.4 on /srv/test').
        that_requires(['Nfs::Functions::Mkdir[/srv/test]', 'Package[nfs-common]', 'Package[nfs4-acl-tools]'])
    end
  end

  context 'when nfs_v4 => false, specified mountpoint and sharename' do
    let(:facts) do
      {
        operatingsystem: 'Ubuntu',
        osfamily: 'Debian',
        operatingsystemmajrelease: '12.04',
        lsbdistcodename: 'precise',
        concat_basedir: '/dne',
        clientcert: 'example.com',
        is_pe: false,
        id: 'root',
        path: '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin'
      }
    end
    let(:title) { 'Import /srv' }

    let(:pre_condition) { 'class {"nfs": client_enabled => true,}' }

    let(:params) { { share: '/export/srv', mount: '/srv', server: '1.2.3.4' } }

    it { is_expected.to contain_nfs__functions__mkdir('/srv') }
    it do
      is_expected.to contain_mount('shared /export/srv by 1.2.3.4 on /srv').
        that_requires(['Nfs::Functions::Mkdir[/srv]', 'Package[nfs-common]', 'Package[nfs4-acl-tools]'])
    end
  end

  context 'when nfs_v4 => true, specified share' do
    let(:facts) do
      {
        operatingsystem: 'Ubuntu',
        osfamily: 'Debian',
        operatingsystemmajrelease: '12.04',
        lsbdistcodename: 'precise',
        concat_basedir: '/dne',
        clientcert: 'example.com',
        is_pe: false,
        id: 'root',
        path: '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin'
      }
    end
    let(:title) { '/srv/test' }

    let(:pre_condition) { 'class {"nfs": client_enabled => true, nfs_v4_client => true }' }

    let(:params) { { share: 'test', server: '1.2.3.4' } }

    it { is_expected.to contain_nfs__functions__mkdir('/srv/test') }
    it do
      is_expected.to contain_mount('shared /test by 1.2.3.4 on /srv/test').
        that_requires(['Nfs::Functions::Mkdir[/srv/test]', 'Package[nfs-common]', 'Package[nfs4-acl-tools]'])
    end
  end

  context 'when nfs_v4 => true, minimal arguments' do
    let(:facts) do
      {
        operatingsystem: 'Ubuntu',
        osfamily: 'Debian',
        operatingsystemmajrelease: '12.04',
        lsbdistcodename: 'precise',
        concat_basedir: '/dne',
        clientcert: 'example.com',
        is_pe: false,
        id: 'root',
        path: '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin'
      }
    end
    let(:title) { '/srv/test' }

    let(:pre_condition) { 'class {"nfs": client_enabled => true, nfs_v4_client => true }' }

    let(:params) { { server: '1.2.3.4' } }

    it { is_expected.to contain_nfs__functions__mkdir('/srv/test') }
    it { is_expected.to contain_mount('shared /test by 1.2.3.4 on /srv/test') }
    it do
      is_expected.to contain_mount('shared /test by 1.2.3.4 on /srv/test').
        that_requires(['Nfs::Functions::Mkdir[/srv/test]', 'Package[nfs-common]', 'Package[nfs4-acl-tools]'])
    end
  end

  context 'when nfs_v4 => true, non-default mountpoints' do
    let(:facts) do
      {
        operatingsystem: 'Ubuntu',
        osfamily: 'Debian',
        operatingsystemmajrelease: '12.04',
        lsbdistcodename: 'precise',
        concat_basedir: '/dne',
        clientcert: 'example.com',
        is_pe: false,
        id: 'root',
        path: '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin'
      }
    end
    let(:title) { '/opt/sample' }

    let(:pre_condition) { 'class {"nfs": client_enabled => true, nfs_v4_client => true }' }

    let(:params) { { share: 'test', server: '1.2.3.4' } }

    it { is_expected.to contain_nfs__functions__mkdir('/opt/sample') }
    it do
      is_expected.to contain_mount('shared /test by 1.2.3.4 on /opt/sample').
        that_requires(['Nfs::Functions::Mkdir[/opt/sample]', 'Package[nfs-common]', 'Package[nfs4-acl-tools]'])
    end
  end

  context 'when nfs_v4 => true, non-default mountpoints, not managing packages' do
    let(:facts) do
      {
        operatingsystem: 'Ubuntu',
        osfamily: 'Debian',
        operatingsystemmajrelease: '12.04',
        lsbdistcodename: 'precise',
        concat_basedir: '/dne',
        clientcert: 'example.com',
        is_pe: false,
        id: 'root',
        path: '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin'
      }
    end
    let(:title) { '/opt/sample' }

    let(:pre_condition) { 'class {"nfs": client_enabled => true, nfs_v4_client => true, manage_packages => false }' }

    let(:params) { { share: 'test', server: '1.2.3.4' } }

    it { is_expected.to contain_nfs__functions__mkdir('/opt/sample') }
    it do
      is_expected.to contain_mount('shared /test by 1.2.3.4 on /opt/sample').
        that_requires(['Nfs::Functions::Mkdir[/opt/sample]'])
    end
  end
end
