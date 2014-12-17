require 'spec_helper'

describe 'nfs' do
  let(:params) {{:client => true}}
  context "operatingsysten => ubuntu" do
    let(:facts) { {:operatingsystem => 'ubuntu', } }
    it { should contain_class('nfs::client::config') }
    it { should contain_class('nfs::client::package') }
    it { should contain_class('nfs::client::service') }
    it do
      should contain_service('rpcbind').with(
        'ensure' => 'running'
      )
      should contain_service('idmapd').with(
        'ensure' => 'stopped'
      )
      should contain_package('nfs-common')
      should contain_package('rpcbind')
      should contain_package('nfs4-acl-tools')
    end
    context ":nfs_v4 => true" do
      let(:params) {{ :nfs_v4 => true }}
      it do
        should contain_augeas('/etc/idmapd.conf')
        should contain_service('idmapd').with(
          'ensure' => 'running'
        )
      end
    end
  end
  context "operatingsysten => debian" do
    let(:facts) { {:operatingsystem => 'debian', } }
    it { should contain_class('nfs::client::config') }
    it { should contain_class('nfs::client::package') }
    it { should contain_class('nfs::client::service') }
    it do
      should contain_service('rpcbind').with(
        'ensure' => 'running'
      )
      should contain_service('idmapd').with(
        'ensure' => 'stopped'
      )
      should contain_package('nfs-common')
      should contain_package('rpcbind')
      should contain_package('nfs4-acl-tools')
    end
    context ":nfs_v4 => true" do
      let(:params) {{ :nfs_v4 => true }}
      it do
        should contain_augeas('/etc/idmapd.conf')
        should contain_service('idmapd').with(
          'ensure' => 'running'
        )
      end
    end
  end
  context "operatingsysten => redhat" do
    let(:facts) { {:operatingsystem => 'redhat', } }
    it { should contain_class('nfs::client::config') }
    it { should contain_class('nfs::client::package') }
    it { should contain_class('nfs::client::service') }
    it do
      should contain_class('nfs::client::redhat::install')
      should contain_class('nfs::client::redhat::configure')
      should contain_class('nfs::client::redhat::service')
      should contain_service('nfslock').with(
        'ensure' => 'running'
      )
      should contain_package('nfs-utils')
      should contain_class('nfs::client::redhat')
      should contain_package('rpcbind')
      should contain_service('rpcbind').with(
        'ensure' => 'running'
      )
    end
  end
  context "operatingsysten => gentoo" do
    let(:facts) { {:operatingsystem => 'gentoo', } }
    it { should contain_class('nfs::client::config') }
    it { should contain_class('nfs::client::package') }
    it { should contain_class('nfs::client::service') }
    it do
      should contain_class('nfs::client::gentoo')
      should contain_class('nfs::client::gentoo::install')
      should contain_class('nfs::client::gentoo::configure')
      should contain_class('nfs::client::gentoo::service')

      should contain_package('net-nds/rpcbind')
      should contain_package('net-fs/nfs-utils')
      should contain_package('net-libs/libnfsidmap')
    end
    context ":nfs_v4 => true" do
      let(:params) {{ :nfs_v4 => true }}
      it do
        should contain_augeas('/etc/conf.d/nfs')
        should contain_augeas('/etc/idmapd.conf')
      end
    end
  end
end
