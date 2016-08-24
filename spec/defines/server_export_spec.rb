require 'spec_helper'

describe 'nfs::server::export', type: 'define' do
  context 'nvs_v4 => false' do
    let(:facts) { {
      operatingsystem: 'Ubuntu',
      osfamily: 'Debian',
      operatingsystemmajrelease: '12.04',
      lsbdistcodename: 'precise',
      concat_basedir: '/dne',
      is_pe: false,
      id: 'root',
      path: '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
    } }
    let(:title) { '/srv/test' }

    let(:pre_condition) { 'class {"nfs": server_enabled => true,}' }

    let(:params) { { clients: '1.2.3.4(rw)' } }
    it do
      should contain_nfs__functions__create_export('/srv/test').with('ensure' => 'mounted', 'clients' => '1.2.3.4(rw)')
    end
  end
  context 'nvs_v4 => true' do
    let(:facts) { {
      operatingsystem: 'Ubuntu',
      osfamily: 'Debian',
      operatingsystemmajrelease: '12.04',
      lsbdistcodename: 'precise',
      concat_basedir: '/dne',
      is_pe: false,
      id: 'root',
      path: '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
    } }
    let(:title) { '/srv/test' }
    let(:pre_condition) { 'class {"nfs": server_enabled => true, nfs_v4 => true}' }

    let(:params) { { clients: '1.2.3.4(rw)', bind: 'sbind' } }
    it do
      should contain_nfs__functions__nfsv4_bindmount('/srv/test').with('ensure' => 'mounted', 'v4_export_name' => 'test', 'bind' => 'sbind')
    end
    it do
      should contain_nfs__functions__create_export('/export/test').with('ensure' => 'mounted', 'clients' => '1.2.3.4(rw)')
    end
  end
end
