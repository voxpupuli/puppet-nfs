require 'spec_helper'

describe 'nfs', type: 'class' do
  context 'server => true' do
    let :params do {
      server_enabled: true,
      client_enabled: false,
    }
    end
    let(:facts) { {
      operatingsystem: 'Ubuntu',
      osfamily: 'Debian',
      operatingsystemmajrelease: '12.04',
      lsbdistcodename: 'precise',
      concat_basedir: '/tmp',
      is_pe: false,
      id: 'root',
      path: '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
    } }
    it { should contain_concat__fragment('nfs_exports_header').with('target' => '/etc/exports') }
    context 'nfs_v4 => true' do
      let(:params) { { nfs_v4: true, server_enabled: true } }
      it { should contain_concat__fragment('nfs_exports_root').with('target' => '/etc/exports') }
      it { should contain_file('/export').with('ensure' => 'directory') }
    end

    context 'operatingsystem => ubuntu' do
      let(:facts) { {
        operatingsystem: 'Ubuntu',
        osfamily: 'Debian',
        operatingsystemmajrelease: '12.04',
        lsbdistcodename: 'precise',
        concat_basedir: '/tmp',
        clientcert: 'test.host',
        is_pe: false,
        id: 'root',
        path: '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
      } }
      it { should contain_class('nfs::server::config') }
      it { should contain_class('nfs::server::package') }
      it { should contain_class('nfs::server::service') }
      it do
        should contain_package('nfs-kernel-server')
        should contain_service('nfs-kernel-server').with('ensure' => 'running')
      end
      context ':nfs_v4 => true' do
        let(:params) { { nfs_v4: true, server_enabled: true, nfs_v4_idmap_domain: 'teststring' } }
        it { should contain_service('idmapd').with('ensure' => 'running') }
        it { should contain_augeas('/etc/idmapd.conf').with_changes(/set Domain teststring/) }
      end
    end
    context 'operatingsystem => debian' do
      let(:facts) { {
        operatingsystem: 'Debian',
        osfamily: 'Debian',
        operatingsystemmajrelease: '7',
        lsbdistcodename: 'wheezy',
        concat_basedir: '/tmp',
        clientcert: 'test.host',
        is_pe: false,
        id: 'root',
        path: '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
      } }
      it { should contain_class('nfs::server::config') }
      it { should contain_class('nfs::server::package') }
      it { should contain_class('nfs::server::service') }
      it do
        should contain_package('nfs-kernel-server')
        should contain_service('nfs-kernel-server').with('ensure' => 'running')
      end
      context ':nfs_v4 => true' do
        let(:params) { { nfs_v4: true, server_enabled: true, nfs_v4_idmap_domain: 'teststring' } }
        it { should contain_service('idmapd').with('ensure' => 'running') }
        it { should contain_augeas('/etc/idmapd.conf').with_changes(/set Domain teststring/) }
      end
    end
    context 'operatingsystem => redhat' do
      let(:facts) { {
        operatingsystem: 'RedHat',
        osfamily: 'RedHat',
        operatingsystemmajrelease: '6',
        concat_basedir: '/tmp',
        clientcert: 'test.host',
        is_pe: false,
        id: 'root',
        path: '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
      } }
      it { should contain_class('nfs::server::config') }
      it { should contain_class('nfs::server::package') }
      it { should contain_class('nfs::server::service') }
      it do
        should contain_service('nfs').with('ensure' => 'running')
      end
      it do
        should contain_package('rpcbind').with('ensure' => 'installed')
      end
      it do
        should contain_package('nfs-utils').with('ensure' => 'installed')
      end
      it do
        should contain_package('nfs4-acl-tools').with('ensure' => 'installed')
      end
      context ':nfs_v4 => true' do
        let(:params) { { nfs_v4: true, server_enabled: true, nfs_v4_idmap_domain: 'teststring' } }
        it { should contain_service('rpcidmapd').with('ensure' => 'running') }
        it { should contain_augeas('/etc/idmapd.conf').with_changes(/set Domain teststring/) }
      end
    end
    context 'operatingsystem => debian' do
      let(:facts) { {
        operatingsystem: 'Debian',
        osfamily: 'Debian',
        operatingsystemmajrelease: '8',
        lsbdistcodename: 'jessie',
        concat_basedir: '/tmp',
        clientcert: 'test.host',
        is_pe: false,
        id: 'root',
        path: '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
      } }
      it { should contain_class('nfs::server::config') }
      it { should contain_class('nfs::server::package') }
      it { should contain_class('nfs::server::service') }
      it do
        should contain_package('nfs-kernel-server')
        should contain_service('nfs-kernel-server').with('ensure' => 'running')
      end
      context ':nfs_v4 => true' do
        let(:params) { { nfs_v4: true, server_enabled: true, nfs_v4_idmap_domain: 'teststring' } }
        it { should contain_service('nfs-common').with('ensure' => 'running') }
        it { should contain_augeas('/etc/idmapd.conf').with_changes(/set Domain teststring/) }
      end
    end
    context 'operatingsystem => redhat' do
      let(:facts) { {
        operatingsystem: 'RedHat',
        osfamily: 'RedHat',
        operatingsystemmajrelease: '6',
        concat_basedir: '/tmp',
        clientcert: 'test.host',
        is_pe: false,
        id: 'root',
        path: '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
      } }
      it { should contain_class('nfs::server::config') }
      it { should contain_class('nfs::server::package') }
      it { should contain_class('nfs::server::service') }
      it do
        should contain_service('nfs').with('ensure' => 'running')
      end
      it do
        should contain_package('rpcbind').with('ensure' => 'installed')
      end
      it do
        should contain_package('nfs-utils').with('ensure' => 'installed')
      end
      it do
        should contain_package('nfs4-acl-tools').with('ensure' => 'installed')
      end
      context ':nfs_v4 => true' do
        let(:params) { { nfs_v4: true, server_enabled: true, nfs_v4_idmap_domain: 'teststring' } }
        it { should contain_service('rpcidmapd').with('ensure' => 'running') }
        it { should contain_augeas('/etc/idmapd.conf').with_changes(/set Domain teststring/) }
      end
    end
    context 'operatingsystem => redhat' do
      let(:facts) { {
        operatingsystem: 'RedHat',
        osfamily: 'RedHat',
        operatingsystemmajrelease: '7',
        concat_basedir: '/tmp',
        clientcert: 'test.host',
        is_pe: false,
        id: 'root',
        path: '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
      } }
      it { should contain_class('nfs::server::config') }
      it { should contain_class('nfs::server::package') }
      it { should contain_class('nfs::server::service') }
      it do
        should contain_service('nfs-server.service').with('ensure' => 'running')
      end
      context ':nfs_v4 => true' do
        let(:params) { { nfs_v4: true, server_enabled: true, nfs_v4_idmap_domain: 'teststring' } }
        it { should contain_service('nfs-idmap.service').with('ensure' => 'running') }
        it { should contain_augeas('/etc/idmapd.conf').with_changes(/set Domain teststring/) }
      end
    end
    context 'operatingsystem => gentoo' do
      let(:facts) { {
        operatingsystem: 'Gentoo',
        osfamily: 'Gentoo',
        operatingsystemmajrelease: '7',
        concat_basedir: '/tmp',
        clientcert: 'test.host',
        is_pe: false,
        id: 'root',
        path: '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
      } }
      it { should contain_class('nfs::server::config') }
      it { should contain_class('nfs::server::package') }
      it { should contain_class('nfs::server::service') }
      it do
        should contain_service('nfs').with('ensure' => 'running')
      end
      context ':nfs_v4 => true' do
        let(:params) { { nfs_v4: true, server_enabled: true, nfs_v4_idmap_domain: 'teststring' } }
        it { should contain_service('rpc.idmapd').with('ensure' => 'running') }
        it { should contain_augeas('/etc/idmapd.conf').with_changes(/set Domain teststring/) }
      end
    end
    context 'operatingsystem => SLES' do
      let(:facts) { {
        operatingsystem: 'SLES',
        osfamily: 'Suse',
        operatingsystemmajrelease: '12',
        concat_basedir: '/tmp',
        clientcert: 'test.host',
        is_pe: false,
        id: 'root',
        path: '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
      } }
      it { should contain_class('nfs::server::config') }
      it { should contain_class('nfs::server::package') }
      it { should contain_class('nfs::server::service') }
      it do
        should contain_service('nfsserver').with('ensure' => 'running')
      end
      context ':nfs_v4 => true' do
        let(:params) { { nfs_v4: true, server_enabled: true, nfs_v4_idmap_domain: 'teststring' } }
        it { should contain_augeas('/etc/idmapd.conf').with_changes(/set Domain teststring/) }
      end
    end
  end
  context 'client => true' do
    context 'operatingsystem => ubuntu' do
      let(:params) { { client_enabled: true, server_enabled: false } }
      let(:facts) { {
        operatingsystem: 'Ubuntu',
        osfamily: 'Debian',
        operatingsystemmajrelease: '12.04',
        lsbdistcodename: 'precise',
        concat_basedir: '/tmp',
        is_pe: false,
        id: 'root',
        path: '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
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
      context ':nfs_v4_client => true, server_enabled => false' do
        let(:params) { { client_enabled: true, nfs_v4_client: true, } }
        it { should contain_augeas('/etc/default/nfs-common') }
        it { should contain_augeas('/etc/idmapd.conf') }
        it do
          should contain_service('rpcbind')\
            .with('ensure' => 'running')\
            .with_subscribe(/Augeas/)
        end
        it do
          is_expected.to contain_package('nfs-common')\
            .that_notifies('Service[rpcbind]')\
            .that_notifies('Service[idmapd]')
          is_expected.to contain_package('nfs4-acl-tools')\
            .that_notifies('Service[rpcbind]')\
            .that_notifies('Service[idmapd]')
        end
      end
      context ':nfs_v4_client => true, :nfs_v4 => true, server_enabled => true' do
        let(:params) { { nfs_v4_client: true, nfs_v4: true, client_enabled: true, server_enabled: true } }
        it { should contain_augeas('/etc/default/nfs-common') }
        it do
          should contain_service('rpcbind')\
            .with('ensure' => 'running')\
            .with_subscribe(['Concat[/etc/exports]', 'Augeas[/etc/idmapd.conf]'])
        end
        it do
          should contain_package('nfs-kernel-server')\
            .with('ensure' => 'installed')\
            .that_notifies('Service[nfs-kernel-server]')
        end
      end
      context ':nfs_v4_client => true, :nfs_v4 => true, server_enabled => true, :manage_server_service => false, :manage_server_servicehelper => false, :manage_client_service => false, server_package_ensure => latest' do
        let(:params) { { nfs_v4_client: true, nfs_v4: true, client_enabled: true, server_enabled: true, manage_server_service: false, manage_server_servicehelper: false, manage_client_service: false, server_package_ensure: 'latest', } }
        it do
          should_not contain_service('rpcbind')
        end
        it do
          should_not contain_service('idmapd')
        end
        it do
          should_not contain_service('nfs-kernel-server')
        end
        it do
          should contain_package('nfs-kernel-server').with('ensure' => 'latest')
        end
      end
      context ':nfs_v4_client => true, :nfs_v4 => true, server_enabled => true, :manage_packages => false' do
        let(:params) { { nfs_v4_client: true, nfs_v4: true, client_enabled: true, server_enabled: true, manage_packages: false, } }
        it do
          should_not contain_package('nfs-common')
          should_not contain_package('nfs-kernel-server')
          should_not contain_package('nfs4-acl-tools')
          should_not contain_package('rpcbind')
        end
      end
    end
    context 'operatingsystem => debian' do
      let(:params) { { client_enabled: true, server_enabled: false } }
      let(:facts) { {
        operatingsystem: 'Debian',
        osfamily: 'Debian',
        operatingsystemmajrelease: '7',
        lsbdistcodename: 'wheezy',
        concat_basedir: '/tmp',
        is_pe: false,
        id: 'root',
        path: '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
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
      context ':nfs_v4_client => true' do
        let(:params) { { nfs_v4_client: true, client_enabled: true } }
        it { should contain_augeas('/etc/default/nfs-common') }
        it { should contain_augeas('/etc/idmapd.conf') }
        it do
          should contain_service('rpcbind')\
            .with('ensure' => 'running')\
            .with_subscribe(/Augeas/)
        end
        it do
          is_expected.to contain_package('nfs-common')\
            .that_notifies('Service[rpcbind]')\
            .that_notifies('Service[idmapd]')
          is_expected.to contain_package('nfs4-acl-tools')\
            .that_notifies('Service[rpcbind]')\
            .that_notifies('Service[idmapd]')
        end
      end
      context ':nfs_v4_client => true, :nfs_v4 => true, server_enabled => true' do
        let(:params) { { nfs_v4_client: true, nfs_v4: true, client_enabled: true, server_enabled: true } }
        it { should contain_augeas('/etc/default/nfs-common') }
        it do
          should contain_service('rpcbind')\
            .with('ensure' => 'running')\
            .with_subscribe(['Concat[/etc/exports]', 'Augeas[/etc/idmapd.conf]'])
        end
        it do
          should contain_package('nfs-kernel-server')\
            .with('ensure' => 'installed')\
            .with('notify' => 'Service[nfs-kernel-server]')
        end
      end
      context ':nfs_v4_client => true, :nfs_v4 => true, server_enabled => true, :manage_server_service => false, :manage_server_servicehelper => false, :manage_client_service => false, server_package_ensure => latest' do
        let(:params) { { nfs_v4_client: true, nfs_v4: true, client_enabled: true, server_enabled: true, manage_server_service: false, manage_server_servicehelper: false, manage_client_service: false, server_package_ensure: 'latest', } }
        it do
          should_not contain_service('rpcbind')
        end
        it do
          should_not contain_service('idmapd')
        end
        it do
          should_not contain_service('nfs-kernel-server')
        end
        it do
          should contain_package('nfs-kernel-server')\
            .with('ensure' => 'latest')\
        end
      end
      context ':nfs_v4_client => true, :nfs_v4 => true, server_enabled => true, :manage_packages => false' do
        let(:params) { { nfs_v4_client: true, nfs_v4: true, client_enabled: true, server_enabled: true, manage_packages: false, } }
        it do
          should_not contain_package('nfs-common')
          should_not contain_package('nfs-kernel-server')
          should_not contain_package('nfs4-acl-tools')
          should_not contain_package('rpcbind')
        end
      end
    end
    context 'operatingsystem => debian' do
      let(:params) { { client_enabled: true, server_enabled: false } }
      let(:facts) { {
        operatingsystem: 'Debian',
        osfamily: 'Debian',
        operatingsystemmajrelease: '8',
        lsbdistcodename: 'jessie',
        concat_basedir: '/tmp',
        is_pe: false,
        id: 'root',
        path: '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
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
      context ':nfs_v4_client => true' do
        let(:params) { { nfs_v4_client: true, client_enabled: true } }
        it { should contain_augeas('/etc/default/nfs-common') }
        it { should contain_augeas('/etc/idmapd.conf') }
        it do
          should contain_service('rpcbind')\
            .with('ensure' => 'running')\
            .with_subscribe(/Augeas/)
        end
        it do
          is_expected.to contain_package('nfs-common')\
            .that_notifies('Service[rpcbind]')\
            .that_notifies('Service[idmapd]')
          is_expected.to contain_package('nfs4-acl-tools')\
            .that_notifies('Service[rpcbind]')\
            .that_notifies('Service[idmapd]')
        end
      end
      context ':nfs_v4_client => true, :nfs_v4 => true, server_enabled => true' do
        let(:params) { { nfs_v4_client: true, nfs_v4: true, client_enabled: true, server_enabled: true } }
        it { should contain_augeas('/etc/default/nfs-common') }
        it do
          should contain_service('rpcbind')\
            .with('ensure' => 'running')\
            .with_subscribe(['Concat[/etc/exports]', 'Augeas[/etc/idmapd.conf]'])
        end
        it do
          should contain_package('nfs-kernel-server')\
            .with('ensure' => 'installed')\
            .that_notifies('Service[nfs-kernel-server]')
        end
      end
      context ':nfs_v4_client => true, :nfs_v4 => true, server_enabled => true, :manage_server_service => false, :manage_server_servicehelper => false, :manage_client_service => false, server_package_ensure => latest,' do
        let(:params) { { nfs_v4_client: true, nfs_v4: true, client_enabled: true, server_enabled: true, manage_server_service: false, manage_server_servicehelper: false, manage_client_service: false, server_package_ensure: 'latest', } }
        it do
          should_not contain_service('rpcbind')
        end
        it do
          should_not contain_service('idmapd')
        end
        it do
          should_not contain_service('nfs-common')
        end
        it do
          should_not contain_service('nfs-kernel-server')
        end
        it do
          should contain_package('nfs-kernel-server').with('ensure' => 'latest')
        end
      end
      context ':nfs_v4_client => true, :nfs_v4 => true, server_enabled => true, :manage_packages => false' do
        let(:params) { { nfs_v4_client: true, nfs_v4: true, client_enabled: true, server_enabled: true, manage_packages: false, } }
        it do
          should_not contain_package('nfs-common')
          should_not contain_package('nfs-kernel-server')
          should_not contain_package('nfs4-acl-tools')
          should_not contain_package('rpcbind')
        end
      end
    end
    context 'operatingsystem => redhat' do
      let(:params) { { client_enabled: true, server_enabled: false } }
      let(:facts) { {
        operatingsystem: 'RedHat',
        osfamily: 'RedHat',
        operatingsystemmajrelease: '7',
        concat_basedir: '/tmp',
        is_pe: false,
        id: 'root',
        path: '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
      } }
      it { should contain_class('nfs::client::config') }
      it { should contain_class('nfs::client::package') }
      it { should contain_class('nfs::client::service') }
      it { should contain_package('nfs-utils') }
      it { should contain_package('nfs4-acl-tools') }
      it { should contain_package('rpcbind') }
      it do
        should contain_service('rpcbind.service')\
          .with('ensure' => 'running')\
          .with_subscribe([])
      end
      context ':nfs_v4_client => true' do
        let(:params) { { nfs_v4_client: true, client_enabled: true } }
        it { should contain_augeas('/etc/default/nfs-common') }
        it { should contain_augeas('/etc/idmapd.conf') }
        it do
          should contain_service('rpcbind.service')\
            .with('ensure' => 'running')\
            .with_subscribe(/Augeas/)
        end
        it do
          is_expected.to contain_package('nfs-utils')\
            .that_notifies('Service[rpcbind.service]')
          is_expected.to contain_package('nfs4-acl-tools')\
            .that_notifies('Service[rpcbind.service]')
          is_expected.to contain_package('rpcbind')\
            .that_notifies('Service[rpcbind.service]')
        end
      end
      context ':nfs_v4_client => true, :nfs_v4 => true, server_enabled => true' do
        let(:params) { { nfs_v4_client: true, nfs_v4: true, client_enabled: true, server_enabled: true } }
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
        it do
          should contain_package('nfs-utils')\
            .with('ensure' => 'installed')\
            .that_notifies('Service[nfs-server.service]')
        end
      end
      context ':nfs_v4_client => true, :nfs_v4 => true, server_enabled => true, :manage_server_service => false, :manage_server_servicehelper => false, :manage_client_service => false, server_package_ensure => latest,' do
        let(:params) { { nfs_v4_client: true, nfs_v4: true, client_enabled: true, server_enabled: true, manage_server_service: false, manage_server_servicehelper: false, manage_client_service: false, server_package_ensure: 'latest', } }
        it do
          should_not contain_service('rpcbind.service')
        end
        it do
          should_not contain_service('nfs-idmap.service')
        end
        it do
          should_not contain_service('nfs-server.service')
        end
        it do
          should contain_package('nfs-utils').with('ensure' => 'latest')
        end
      end
      context ':nfs_v4_client => true, :nfs_v4 => true, server_enabled => true, :manage_packages => false' do
        let(:params) { { nfs_v4_client: true, nfs_v4: true, client_enabled: true, server_enabled: true, manage_packages: false, } }
        it do
          should_not contain_package('nfs-utils')
          should_not contain_package('nfs4-acl-tools')
          should_not contain_package('rpcbind')
        end
      end
    end
    context 'operatingsystem => gentoo' do
      let(:params) { { client_enabled: true, } }
      let(:facts) { {
        operatingsystem: 'Gentoo',
        osfamily: 'Gentoo',
        operatingsystemmajrelease: '7',
        concat_basedir: '/tmp',
        is_pe: false,
        id: 'root',
        path: '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
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
      context ':nfs_v4_client => true' do
        let(:params) { { nfs_v4_client: true, client_enabled: true, } }
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
        it do
          is_expected.to contain_package('net-nds/rpcbind')\
            .that_notifies('Service[rpcbind]')\
            .that_notifies('Service[rpc.idmapd]')
          is_expected.to contain_package('net-fs/nfs-utils')\
            .that_notifies('Service[rpcbind]')\
            .that_notifies('Service[rpc.idmapd]')
          is_expected.to contain_package('net-libs/libnfsidmap')\
            .that_notifies('Service[rpcbind]')\
            .that_notifies('Service[rpc.idmapd]')
        end
      end
      context ':nfs_v4_client => true, :nfs_v4 => true, server_enabled => true' do
        let(:params) { { nfs_v4_client: true, nfs_v4: true, client_enabled: true, server_enabled: true } }
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
        it do
          should contain_package('net-fs/nfs-utils')\
            .with('ensure' => 'installed')\
            .that_notifies('Service[nfs]')
        end
      end
      context ':nfs_v4_client => true, :nfs_v4 => true, server_enabled => true, :manage_server_service => false, :manage_server_servicehelper => false, :manage_client_service => false, server_package_ensure => latest' do
        let(:params) { { nfs_v4_client: true, nfs_v4: true, client_enabled: true, server_enabled: true, manage_server_service: false, manage_server_servicehelper: false, manage_client_service: false, server_package_ensure: 'latest', } }
        it do
          should_not contain_service('rpcbind')
        end
        it do
          should_not contain_service('rpc.idmapd')
        end
        it do
          should_not contain_service('nfs')
        end
        it do
          should contain_package('net-fs/nfs-utils').with('ensure' => 'latest')
        end
      end
      context ':nfs_v4_client => true, :nfs_v4 => true, server_enabled => true, :manage_packages => false' do
        let(:params) { { nfs_v4_client: true, nfs_v4: true, client_enabled: true, server_enabled: true, manage_packages: false, } }
        it do
          should_not contain_package('net-fs/nfs-utils')
          should_not contain_package('net-nds/rpcbind')
          should_not contain_package('net-libs/libnfsidmap')
        end
      end
    end
    context ':operatingsystem => SLES' do
      let(:params) { { client_enabled: true, } }
      let(:facts) { {
        operatingsystem: 'SLES',
        osfamily: 'Suse',
        operatingsystemmajrelease: '12',
        concat_basedir: '/tmp',
        is_pe: false,
        id: 'root',
        path: '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
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
      context ':nfs_v4_client => true' do
        let(:params) { { nfs_v4_client: true, client_enabled: true, } }
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
        it do
          is_expected.to contain_package('nfsidmap')\
            .that_notifies('Service[rpcbind]')\
            .that_notifies('Service[nfs]')
          is_expected.to contain_package('nfs-client')\
            .that_notifies('Service[rpcbind]')\
            .that_notifies('Service[nfs]')
          is_expected.to contain_package('rpcbind')\
            .that_notifies('Service[rpcbind]')\
            .that_notifies('Service[nfs]')
        end
      end
      context ':nfs_v4_client => true, :nfs_v4 => true, server_enabled => true' do
        let(:params) { { nfs_v4_client: true, nfs_v4: true, client_enabled: true, server_enabled: true } }
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
        it do
          should contain_package('nfs-kernel-server')\
            .with('ensure' => 'installed')\
            .that_notifies('Service[nfsserver]')
        end
      end
      context ':nfs_v4_client => true, :nfs_v4 => true, server_enabled => true, :manage_server_service => false, :manage_server_servicehelper => false, :manage_client_service => false, server_package_ensure => latest' do
        let(:params) { { nfs_v4_client: true, nfs_v4: true, client_enabled: true, server_enabled: true, manage_server_service: false, manage_server_servicehelper: false, manage_client_service: false, server_package_ensure: 'latest', } }
        it do
          should_not contain_service('rpcbind')
        end
        it do
          should_not contain_service('nfsserver')
        end
        it do
          should contain_package('nfs-kernel-server').with('ensure' => 'latest')
        end
      end
      context ':nfs_v4_client => true, :nfs_v4 => true, server_enabled => true, :manage_packages => false' do
        let(:params) { { nfs_v4_client: true, nfs_v4: true, client_enabled: true, server_enabled: true, manage_packages: false, } }
        it do
          should_not contain_package('nfs-kernel-server')
          should_not contain_package('rpcbind')
          should_not contain_package('nfs-client')
          should_not contain_package('nfsidmap')
        end
      end
    end
  end
end
