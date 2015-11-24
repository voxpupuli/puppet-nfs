require 'spec_helper'

describe 'nfs', :type => 'class' do
  context "server => true" do
    let :params do {
      :server_enabled => true,
      :client_enabled => false,
    } end
    let(:facts) { {
      :operatingsystem => 'Ubuntu',
      :osfamily => 'Debian',
      :operatingsystemmajrelease => '12.04',
      :concat_basedir => '/tmp',
      :is_pe => false,
      :id => 'root',
      :path => '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
    } }
    it { should contain_concat__fragment('nfs_exports_header').with( 'target' => '/etc/exports' ) }
    context "nfs_v4 => true" do
      let(:params) { {:nfs_v4 => true, :server_enabled => true } }
      it { should contain_concat__fragment('nfs_exports_root').with( 'target' => '/etc/exports' ) }
      it { should contain_file('/export').with( 'ensure' => 'directory' ) }
    end

    context "operatingsysten => ubuntu" do
      let(:facts) { {
        :operatingsystem => 'Ubuntu',
        :osfamily => 'Debian',
        :operatingsystemmajrelease => '12.04',
        :concat_basedir => '/tmp',
        :clientcert => 'test.host',
        :is_pe => false,
        :id => 'root',
        :path => '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
      } }
      it { should contain_class('nfs::server::config') }
      it { should contain_class('nfs::server::package') }
      it { should contain_class('nfs::server::service') }
      it do
        should contain_package('nfs-kernel-server')
        should contain_service('nfs-kernel-server').with( 'ensure' => 'running'  )
      end
      context ":nfs_v4 => true" do
        let(:params) {{ :nfs_v4 => true, :server_enabled => true, :nfs_v4_idmap_domain => 'teststring'}}
        it { should contain_service('idmapd').with( 'ensure' => 'running'  ) }
        it { should contain_augeas('/etc/idmapd.conf').with_changes(/set Domain teststring/) }
      end
    end
    context "operatingsysten => debian" do
      let(:facts) { {
        :operatingsystem => 'Debian',
        :osfamily => 'Debian',
        :operatingsystemmajrelease => '7',
        :concat_basedir => '/tmp',
        :clientcert => 'test.host',
        :is_pe => false,
        :id => 'root',
        :path => '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
      } }
      it { should contain_class('nfs::server::config') }
      it { should contain_class('nfs::server::package') }
      it { should contain_class('nfs::server::service') }
      it do
        should contain_package('nfs-kernel-server')
        should contain_service('nfs-kernel-server').with( 'ensure' => 'running'  )
      end
      context ":nfs_v4 => true" do
        let(:params) {{ :nfs_v4 => true, :server_enabled => true, :nfs_v4_idmap_domain => 'teststring' }}
        it { should contain_service('idmapd').with( 'ensure' => 'running'  ) }
        it { should contain_augeas('/etc/idmapd.conf').with_changes(/set Domain teststring/) }
      end
    end
    context "operatingsysten => redhat" do
      let(:facts) { {
        :operatingsystem => 'RedHat',
        :osfamily => 'RedHat',
        :operatingsystemmajrelease => '6',
        :concat_basedir => '/tmp',
        :clientcert => 'test.host',
        :is_pe => false,
        :id => 'root',
        :path => '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
      } }
      it { should contain_class('nfs::server::config') }
      it { should contain_class('nfs::server::package') }
      it { should contain_class('nfs::server::service') }
      it do
        should contain_service('nfs').with( 'ensure' => 'running'  )
      end
      it do
        should contain_package('rpcbind').with( 'ensure' => 'installed'  )
      end
      it do
        should contain_package('nfs-utils').with( 'ensure' => 'installed'  )
      end
      it do
        should contain_package('nfs4-acl-tools').with( 'ensure' => 'installed'  )
      end
      context ":nfs_v4 => true" do
        let(:params) {{ :nfs_v4 => true, :server_enabled => true, :nfs_v4_idmap_domain => 'teststring' }}
        it { should contain_service('rpcidmapd').with( 'ensure' => 'running'  ) }
        it { should contain_augeas('/etc/idmapd.conf').with_changes(/set Domain teststring/) }
      end
    end
    context "operatingsysten => redhat" do
      let(:facts) { {
        :operatingsystem => 'RedHat',
        :osfamily => 'RedHat',
        :operatingsystemmajrelease => '7',
        :concat_basedir => '/tmp',
        :clientcert => 'test.host',
        :is_pe => false,
        :id => 'root',
        :path => '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
      } }
      it { should contain_class('nfs::server::config') }
      it { should contain_class('nfs::server::package') }
      it { should contain_class('nfs::server::service') }
      it do
        should contain_service('nfs-server.service').with( 'ensure' => 'running'  )
      end
      context ":nfs_v4 => true" do
        let(:params) {{ :nfs_v4 => true, :server_enabled => true, :nfs_v4_idmap_domain => 'teststring' }}
        it { should contain_service('nfs-idmap.service').with( 'ensure' => 'running'  ) }
        it { should contain_augeas('/etc/idmapd.conf').with_changes(/set Domain teststring/) }
      end
    end
    context "operatingsysten => gentoo" do
      let(:facts) { {
        :operatingsystem => 'Gentoo',
        :osfamily => 'Gentoo',
        :operatingsystemmajrelease => '7',
        :concat_basedir => '/tmp',
        :clientcert => 'test.host',
        :is_pe => false,
        :id => 'root',
        :path => '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
      } }
      it { should contain_class('nfs::server::config') }
      it { should contain_class('nfs::server::package') }
      it { should contain_class('nfs::server::service') }
      it do
        should contain_service('nfs').with( 'ensure' => 'running'  )
      end
      context ":nfs_v4 => true" do
        let(:params) {{ :nfs_v4 => true, :server_enabled => true, :nfs_v4_idmap_domain => 'teststring'}}
        it { should contain_service('rpc.idmapd').with( 'ensure' => 'running'  ) }
        it { should contain_augeas('/etc/idmapd.conf').with_changes(/set Domain teststring/) }
      end
    end
    context "operatingsysten => SLES" do
      let(:facts) { {
        :operatingsystem => 'SLES',
        :osfamily => 'Suse',
        :operatingsystemmajrelease => '12',
        :concat_basedir => '/tmp',
        :clientcert => 'test.host',
        :is_pe => false,
        :id => 'root',
        :path => '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
      } }
      it { should contain_class('nfs::server::config') }
      it { should contain_class('nfs::server::package') }
      it { should contain_class('nfs::server::service') }
      it do
        should contain_service('nfsserver').with( 'ensure' => 'running'  )
      end
      context ":nfs_v4 => true" do
        let(:params) {{ :nfs_v4 => true, :server_enabled => true, :nfs_v4_idmap_domain => 'teststring'}}
        it { should contain_augeas('/etc/idmapd.conf').with_changes(/set Domain teststring/) }
      end
    end
  end
  context "client => true" do
    context "operatingsysten => ubuntu" do
      let(:params) {{ :client_enabled => true, :server_enabled => false  }}
      let(:facts) { {
        :operatingsystem => 'Ubuntu',
        :osfamily => 'Debian',
        :operatingsystemmajrelease => '12.04',
        :concat_basedir => '/tmp',
        :is_pe => false,
        :id => 'root',
        :path => '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
      } }
      it { should contain_class('nfs::client::config') }
      it { should contain_class('nfs::client::package') }
      it { should contain_class('nfs::client::service') }
      it do
        should contain_service('rpcbind')\
          .with('ensure' => 'running')\
          .with_subscribe([])
      end
      it { should contain_package('nfs-common') }
      it { should contain_package('nfs4-acl-tools') }
      context ":nfs_v4_client => true, server_enabled => false" do
        let(:params) {{ :client_enabled => true, :nfs_v4_client => true, }}
        it { should contain_augeas('/etc/default/nfs-common') }
        it { should contain_augeas('/etc/idmapd.conf') }
        it do
          should contain_service('rpcbind')\
            .with('ensure' => 'running')\
            .with_subscribe(/Augeas/)
        end
      end
      context ":nfs_v4_client => true, :nfs_v4 => true, server_enabled => true" do
        let(:params) {{ :nfs_v4_client => true, :nfs_v4 => true, :client_enabled => true, :server_enabled => true }}
        it { should contain_augeas('/etc/default/nfs-common') }
        it do
          should contain_service('rpcbind')\
            .with('ensure' => 'running')\
            .with_subscribe(['Concat[/etc/exports]', 'Augeas[/etc/idmapd.conf]'])
        end
      end
    end
    context "operatingsysten => debian" do
      let(:params) {{ :client_enabled => true, :server_enabled => false  }}
        let(:facts) { {
          :operatingsystem => 'Ubuntu',
          :osfamily => 'Debian',
          :operatingsystemmajrelease => '12.04',
          :concat_basedir => '/tmp',
          :is_pe => false,
          :id => 'root',
          :path => '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
        } }
        it { should contain_class('nfs::client::config') }
        it { should contain_class('nfs::client::package') }
        it { should contain_class('nfs::client::service') }
        it do
          should contain_service('rpcbind')\
            .with('ensure' => 'running')\
            .with_subscribe([])
        end
        it { should contain_package('nfs-common') }
        it { should contain_package('nfs4-acl-tools') }
        context ":nfs_v4_client => true" do
          let(:params) {{ :nfs_v4_client => true, :client_enabled => true }}
          it { should contain_augeas('/etc/default/nfs-common') }
          it { should contain_augeas('/etc/idmapd.conf') }
          it do
            should contain_service('rpcbind')\
              .with('ensure' => 'running')\
              .with_subscribe(/Augeas/)
          end
        end
        context ":nfs_v4_client => true, :nfs_v4 => true, server_enabled => true" do
          let(:params) {{ :nfs_v4_client => true, :nfs_v4 => true, :client_enabled => true, :server_enabled => true }}
          it { should contain_augeas('/etc/default/nfs-common') }
          it do
            should contain_service('rpcbind')\
              .with('ensure' => 'running')\
              .with_subscribe(['Concat[/etc/exports]', 'Augeas[/etc/idmapd.conf]'])
          end
        end
    end
    context "operatingsysten => redhat" do
      let(:params) {{ :client_enabled => true, :server_enabled => false  }}
      let(:facts) { {
        :operatingsystem => 'RedHat',
        :osfamily => 'RedHat',
        :operatingsystemmajrelease => '7',
        :concat_basedir => '/tmp',
        :is_pe => false,
        :id => 'root',
        :path => '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
      } }
      it { should contain_class('nfs::client::config') }
      it { should contain_class('nfs::client::package') }
      it { should contain_class('nfs::client::service') }
      it { should contain_package('nfs-utils') }
      it { should contain_package('nfs4-acl-tools') }
      it {  should contain_package('rpcbind') }
      it do
        should contain_service('rpcbind.service')\
          .with('ensure' => 'running')\
          .with_subscribe([])
      end
      context ":nfs_v4_client => true" do
        let(:params) {{ :nfs_v4_client => true, :client_enabled => true }}
        it { should contain_augeas('/etc/default/nfs-common') }
        it { should contain_augeas('/etc/idmapd.conf') }
        it do
          should contain_service('rpcbind.service')\
            .with('ensure' => 'running')\
            .with_subscribe(/Augeas/)
        end
        it do
          should contain_service('nfs-idmap.service')\
            .with('ensure' => 'running')\
            .with_subscribe(/Augeas/)
        end
      end
      context ":nfs_v4_client => true, :nfs_v4 => true, server_enabled => true" do
        let(:params) {{ :nfs_v4_client => true, :nfs_v4 => true, :client_enabled => true, :server_enabled => true }}
        it { should contain_augeas('/etc/default/nfs-common') }
        it do
          should contain_service('rpcbind.service')\
            .with('ensure' => 'running')\
            .with_subscribe(['Concat[/etc/exports]', 'Augeas[/etc/idmapd.conf]'])
        end
        it do
          should contain_service('nfs-idmap.service')\
            .with('ensure' => 'running')
        end
      end
    end
    context "operatingsysten => gentoo" do
      let(:params) {{ :client_enabled => true, }}
      let(:facts) { {
        :operatingsystem => 'Gentoo',
        :osfamily => 'Gentoo',
        :operatingsystemmajrelease => '7',
        :concat_basedir => '/tmp',
        :is_pe => false,
        :id => 'root',
        :path => '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
      } }
      it { should contain_class('nfs::client::config') }
      it { should contain_class('nfs::client::package') }
      it { should contain_class('nfs::client::service') }
      it { should contain_package('net-nds/rpcbind') }
      it { should contain_package('net-fs/nfs-utils') }
      it { should contain_package('net-libs/libnfsidmap') }
      it do
        should contain_service('rpcbind')\
          .with('ensure' => 'running')\
          .with_subscribe([])
      end
      context ":nfs_v4_client => true" do
        let(:params) {{ :nfs_v4_client => true, :client_enabled => true, }}
        it { should contain_augeas('/etc/conf.d/nfs') }
        it { should contain_augeas('/etc/idmapd.conf') }
        it do
          should contain_service('rpcbind')\
            .with('ensure' => 'running')\
            .with_subscribe(/Augeas/)
        end
        it do
          should contain_service('rpc.idmapd')\
            .with('ensure' => 'running')\
            .with_subscribe(/Augeas/)
        end
      end
      context ":nfs_v4_client => true, :nfs_v4 => true, server_enabled => true" do
        let(:params) {{ :nfs_v4_client => true, :nfs_v4 => true, :client_enabled => true, :server_enabled => true }}
        it { should contain_augeas('/etc/conf.d/nfs') }
        it do
          should contain_service('rpcbind')\
            .with('ensure' => 'running')\
            .with_subscribe(['Concat[/etc/exports]', 'Augeas[/etc/idmapd.conf]'])
        end
        it do
          should contain_service('rpc.idmapd')\
            .with('ensure' => 'running')
        end
      end
    end
    context "operatingsysten => SLES" do
      let(:params) {{ :client_enabled => true, }}
      let(:facts) { {
        :operatingsystem => 'SLES',
        :osfamily => 'Suse',
        :operatingsystemmajrelease => '12',
        :concat_basedir => '/tmp',
        :is_pe => false,
        :id => 'root',
        :path => '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
      } }
      it { should contain_class('nfs::client::config') }
      it { should contain_class('nfs::client::package') }
      it { should contain_class('nfs::client::service') }
      it { should contain_package('rpcbind') }
      it { should contain_package('nfs-client') }
      it { should contain_package('nfsidmap') }
      it do
        should contain_service('rpcbind')\
          .with('ensure' => 'running')\
          .with_subscribe([])\
          .that_comes_before('Service[nfs]')
      end
      context ":nfs_v4_client => true" do
        let(:params) {{ :nfs_v4_client => true, :client_enabled => true, }}
        it { should contain_augeas('/etc/idmapd.conf') }
        it do
          should contain_service('rpcbind')\
            .with('ensure' => 'running')\
            .with_subscribe(/Augeas/)\
            .that_comes_before('Service[nfs]')
        end
        it do
          should contain_service('nfs')\
            .with('ensure' => 'running')\
            .with_subscribe(/Augeas/)
        end
      end
      context ":nfs_v4_client => true, :nfs_v4 => true, server_enabled => true" do
        let(:params) {{ :nfs_v4_client => true, :nfs_v4 => true, :client_enabled => true, :server_enabled => true }}
        it do
          should contain_service('rpcbind')\
            .with('ensure' => 'running')\
            .with_subscribe(['Concat[/etc/exports]', 'Augeas[/etc/idmapd.conf]'])\
            .that_comes_before('Service[nfs]')
        end
        it do
          should contain_service('nfsserver')\
            .with('ensure' => 'running')
        end
      end
    end
  end
end
