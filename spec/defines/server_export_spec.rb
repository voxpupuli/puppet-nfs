# frozen_string_literal: true

require 'spec_helper'

describe 'nfs::server::export', type: 'define' do
  context 'when nvs_v4 => false' do
    let(:facts) do
      {
        'networking' => {
          'domain' => 'example.com'
        },
        'operatingsystem' => 'Ubuntu',
        'os' => {
          'family' => 'Debian',
          'distro' => {
            'codename' => 'focal'
          },
          'release' => {
            'major' => '20',
            'minor' => '04',
            'full' => '20.04'
          }
        },
        'concat_basedir' => '/tmp',

        'is_pe' => false,
        'id' => 'root',
        'path' => '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin'
      }
    end
    let(:title) { '/srv/test' }

    let(:pre_condition) { 'class {"nfs": server_enabled => true,}' }

    let(:params) { { clients: '1.2.3.4(rw)' } }

    it do
      is_expected.to contain_nfs__functions__create_export('/srv/test').with(
        'ensure'           => 'mounted',
        'clients'          => '1.2.3.4(rw)',
        'manage_directory' => true
      )
    end

    it { is_expected.to contain_file('/srv/test').with('ensure' => 'directory') }

    it do
      expect(exported_resources).to contain_nfs__client__mount('/srv/test')
    end
  end

  context 'when nvs_v4 => false, nfs::storeconfigs_enabled => false' do
    let(:facts) do
      {
        'networking' => {
          'domain' => 'example.com'
        },
        'operatingsystem' => 'Ubuntu',
        'os' => {
          'family' => 'Debian',
          'distro' => {
            'codename' => 'focal'
          },
          'release' => {
            'major' => '20',
            'minor' => '04',
            'full' => '20.04'
          }
        },
        'concat_basedir' => '/tmp',

        'is_pe' => false,
        'id' => 'root',
        'path' => '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin'
      }
    end
    let(:title) { '/srv/test' }

    let(:pre_condition) { 'class {"nfs": server_enabled => true, nfs_v4 => false, storeconfigs_enabled => false}' }

    let(:params) { { clients: '1.2.3.4(rw)', manage_directory: false } }

    it { is_expected.to contain_nfs__functions__create_export('/srv/test').with('ensure' => 'mounted', 'clients' => '1.2.3.4(rw)') }

    it { is_expected.not_to contain_file('/srv/test') }

    it { expect(exported_resources).not_to contain_nfs__client__mount('/srv/test') }
  end

  context 'when nfs_v4 => true' do
    let(:facts) do
      {
        'networking' => {
          'domain' => 'example.com'
        },
        'operatingsystem' => 'Ubuntu',
        'os' => {
          'family' => 'Debian',
          'distro' => {
            'codename' => 'focal'
          },
          'release' => {
            'major' => '20',
            'minor' => '04',
            'full' => '20.04'
          }
        },
        'concat_basedir' => '/tmp',

        'is_pe' => false,
        'id' => 'root',
        'path' => '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin'
      }
    end
    let(:title) { '/srv/test' }
    let(:pre_condition) { 'class {"nfs": server_enabled => true, nfs_v4 => true}' }

    let(:params) { { clients: '1.2.3.4(rw)', bind: 'sbind' } }

    it { is_expected.to contain_nfs__functions__nfsv4_bindmount('/srv/test').with('ensure' => 'mounted', 'v4_export_name' => 'test', 'bind' => 'sbind') }

    it { is_expected.to contain_nfs__functions__create_export('/export/test').with('ensure' => 'mounted', 'clients' => '1.2.3.4(rw)') }

    it { expect(exported_resources).to contain_nfs__client__mount('test') }
  end

  context 'when nfs_v4 => true, nfs::storeconfigs_enabled => false' do
    let(:facts) do
      {
        'networking' => {
          'domain' => 'example.com'
        },
        'operatingsystem' => 'Ubuntu',
        'os' => {
          'family' => 'Debian',
          'distro' => {
            'codename' => 'focal'
          },
          'release' => {
            'major' => '20',
            'minor' => '04',
            'full' => '20.04'
          }
        },
        'concat_basedir' => '/tmp',

        'is_pe' => false,
        'id' => 'root',
        'path' => '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin'
      }
    end
    let(:title) { '/srv/test' }
    let(:pre_condition) { 'class {"nfs": server_enabled => true, nfs_v4 => true, storeconfigs_enabled => false}' }
    let(:params) { { clients: '1.2.3.4(rw)', bind: 'sbind' } }

    it { is_expected.to contain_nfs__functions__nfsv4_bindmount('/srv/test').with('ensure' => 'mounted', 'v4_export_name' => 'test', 'bind' => 'sbind') }

    it { is_expected.to contain_nfs__functions__create_export('/export/test').with('ensure' => 'mounted', 'clients' => '1.2.3.4(rw)') }

    it { expect(exported_resources).not_to contain_nfs__client__mount('test') }
  end

  context 'when nfs_v4 => true, nfs::nfsv4_bindmount_enable => true' do
    let(:facts) do
      {
        'networking' => {
          'domain' => 'example.com'
        },
        'operatingsystem' => 'Ubuntu',
        'os' => {
          'family' => 'Debian',
          'distro' => {
            'codename' => 'focal'
          },
          'release' => {
            'major' => '20',
            'minor' => '04',
            'full' => '20.04'
          }
        },
        'concat_basedir' => '/tmp',

        'is_pe' => false,
        'id' => 'root',
        'path' => '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin'
      }
    end
    let(:title) { '/srv/test' }
    let(:pre_condition) { 'class {"nfs": server_enabled => true, nfs_v4 => true, nfsv4_bindmount_enable => true}' }
    let(:params) { { clients: '1.2.3.4(rw)', bind: 'sbind' } }

    it { is_expected.to contain_nfs__functions__nfsv4_bindmount('/srv/test').with('ensure' => 'mounted', 'v4_export_name' => 'test', 'bind' => 'sbind') }

    it { is_expected.to contain_nfs__functions__create_export('/export/test').with('ensure' => 'mounted', 'clients' => '1.2.3.4(rw)') }

    it { expect(exported_resources).to contain_nfs__client__mount('test') }
  end

  context 'when nfs_v4 => true, nfs::nfsv4_bindmount_enable => false' do
    let(:facts) do
      {
        'networking' => {
          'domain' => 'example.com'
        },
        'operatingsystem' => 'Ubuntu',
        'os' => {
          'family' => 'Debian',
          'distro' => {
            'codename' => 'focal'
          },
          'release' => {
            'major' => '20',
            'minor' => '04',
            'full' => '20.04'
          }
        },
        'concat_basedir' => '/tmp',

        'is_pe' => false,
        'id' => 'root',
        'path' => '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin'
      }
    end
    let(:title) { '/srv/test' }
    let(:pre_condition) { 'class {"nfs": server_enabled => true, nfs_v4 => true, nfsv4_bindmount_enable => false}' }
    let(:params) { { clients: '1.2.3.4(rw)', bind: 'sbind' } }

    it { is_expected.not_to contain_nfs__functions__nfsv4_bindmount('/srv/test').with('ensure' => 'mounted', 'v4_export_name' => 'test', 'bind' => 'sbind') }

    it { is_expected.to contain_nfs__functions__create_export('/srv/test').with('ensure' => 'mounted', 'clients' => '1.2.3.4(rw)') }

    it { expect(exported_resources).to contain_nfs__client__mount('/srv/test') }
  end
end
