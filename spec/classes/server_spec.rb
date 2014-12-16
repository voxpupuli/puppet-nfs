require 'spec_helper'

describe 'nfs::server' do
  let(:facts) { {:operatingsystem => 'ubuntu', :concat_basedir => '/tmp', } }
  it do
    should contain_concat__fragment('nfs_exports_header').with( 'target' => '/etc/exports' )
  end
  context "nfs_v4 => true" do
    let(:params) { {:nfs_v4 => true, } }
    it do
      should contain_concat__fragment('nfs_exports_root').with( 'target' => '/etc/exports' )
      should contain_file('/export').with( 'ensure' => 'directory' )
    end
  end

  context "operatingsysten => ubuntu" do
    let(:facts) { {:operatingsystem => 'ubuntu', :concat_basedir => '/tmp', } }
    it { should contain_class('nfs::server::config') }
    it { should contain_class('nfs::server::package') }
    it { should contain_class('nfs::server::service') }
    it do
      should contain_class('nfs::client::debian')
      should contain_package('nfs-kernel-server')
      should contain_service('nfs-kernel-server').with( 'ensure' => 'running'  )
    end
    context ":nfs_v4 => true" do
      let(:params) {{ :nfs_v4 => true }}
      it do
        should contain_service('idmapd').with( 'ensure' => 'running'  )
      end
    end
  end
  context "operatingsysten => debian" do
    let(:facts) { {:operatingsystem => 'debian', :concat_basedir => '/tmp',} }
    it { should contain_class('nfs::server::config') }
    it { should contain_class('nfs::server::package') }
    it { should contain_class('nfs::server::service') }
    it do
      should contain_class('nfs::client::debian')
      should contain_package('nfs-kernel-server')
      should contain_service('nfs-kernel-server').with( 'ensure' => 'running'  )
    end
    context ":nfs_v4 => true" do
      let(:params) {{ :nfs_v4 => true }}
      it do
        should contain_service('idmapd').with( 'ensure' => 'running'  )
      end
    end
  end
  context "operatingsysten => redhat" do
    let(:facts) { {:operatingsystem => 'redhat', :concat_basedir => '/tmp',} }
    it { should contain_class('nfs::server::config') }
    it { should contain_class('nfs::server::package') }
    it { should contain_class('nfs::server::service') }
    it do
      should contain_service('nfs').with( 'ensure' => 'running'  )
    end
    context ":nfs_v4 => true" do
      let(:params) {{ :nfs_v4 => true , :nfs_v4_idmap_domain => 'teststring' }}
      it do
        should contain_augeas('/etc/idmapd.conf').with_changes(/set Domain teststring/)
      end
    end
  end
  context "operatingsysten => gentoo" do
    let(:facts) { {:operatingsystem => 'gentoo', :concat_basedir => '/tmp',} }
    it { should contain_class('nfs::server::config') }
    it { should contain_class('nfs::server::package') }
    it { should contain_class('nfs::server::service') }
    it do
      should contain_class('nfs::client::gentoo')
      should contain_service('nfs').with( 'ensure' => 'running'  )
    end
    context ":nfs_v4 => true" do
      let(:params) {{ :nfs_v4 => true , :nfs_v4_idmap_domain => 'teststring' }}
      it do
        should contain_augeas('/etc/idmapd.conf').with_changes(/set Domain teststring/)
      end
    end
  end
end
