require 'spec_helper'

describe 'nfs' do
  supported_os = %w(Ubuntu_default Ubuntu_16.04 Debian_default Debian_8 RedHat_default RedHat_7 Gentoo SLES Archlinux)
  supported_os.each do |os|
    context os do
      let(:default_facts) do {
        concat_basedir: '/tmp',
        clientcert: 'test.host',
        is_pe: false,
        id: 'root',
        path: '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
      }
      end

      ### vv switch case to set OS specific values vv ###
      case os

      when 'Ubuntu_default'

        let(:facts) do
          default_facts.merge(
            operatingsystem: 'Ubuntu',
            osfamily: 'Debian',
            operatingsystemmajrelease: '14.04',
            lsbdistcodename: 'trusty',
          )
        end
        server_service = 'nfs-kernel-server'
        server_servicehelper = 'idmapd'
        server_packages = %w(nfs-common nfs-kernel-server nfs4-acl-tools rpcbind)
        client_services = %w(rpcbind)
        client_nfs_vfour_services = %w(rpcbind)
        client_packages = %w(nfs-common nfs4-acl-tools)

      when 'Ubuntu_16.04'

        let(:facts) do
          default_facts.merge(
            operatingsystem: 'Ubuntu',
            osfamily: 'Debian',
            operatingsystemmajrelease: '16.04',
            lsbdistcodename: 'xenial',
          )
        end
        server_service = 'nfs-server'
        server_servicehelper = 'nfs-idmapd'
        server_packages = %w(nfs-common nfs-kernel-server nfs4-acl-tools rpcbind)
        client_services = %w(rpcbind)
        client_nfs_vfour_services = %w(rpcbind)
        client_packages = %w(nfs-common nfs4-acl-tools)

      when 'Debian_default'

        let(:facts) do
          default_facts.merge(
            operatingsystem: 'Debian',
            osfamily: 'Debian',
            operatingsystemmajrelease: '7',
            lsbdistcodename: 'wheezy',
          )
        end
        server_service = 'nfs-kernel-server'
        server_servicehelper = 'idmapd'
        server_packages = %w(nfs-common nfs-kernel-server nfs4-acl-tools rpcbind)
        client_services = %w(rpcbind)
        client_nfs_vfour_services = %w(rpcbind idmapd)
        client_packages = %w(nfs-common nfs4-acl-tools)

      when 'Debian_8'

        let(:facts) do
          default_facts.merge(
            operatingsystem: 'Debian',
            osfamily: 'Debian',
            operatingsystemmajrelease: '8',
            lsbdistcodename: 'jessie',
          )
        end
        server_service = 'nfs-kernel-server'
        server_servicehelper = 'nfs-common'
        server_packages = %w(nfs-common nfs-kernel-server nfs4-acl-tools rpcbind)
        client_services = %w(rpcbind)
        client_nfs_vfour_services = %w(rpcbind idmapd)
        client_packages = %w(nfs-common nfs4-acl-tools)

      when 'RedHat_default'

        let(:facts) do
          default_facts.merge(
            operatingsystem: 'RedHat',
            osfamily: 'RedHat',
            operatingsystemmajrelease: '8',
          )
        end
        server_service = 'nfs'
        server_servicehelper = 'rpcidmapd'
        server_packages = %w(nfs-utils nfs4-acl-tools rpcbind)
        client_services = %w(rpcbind)
        client_nfs_vfour_services = %w(rpcbind rpcidmapd)
        client_packages = %w(nfs-utils nfs4-acl-tools rpcbind)

      when 'RedHat_7'

        let(:facts) do
          default_facts.merge(
            operatingsystem: 'RedHat',
            osfamily: 'RedHat',
            operatingsystemmajrelease: '7',
          )
        end
        server_service = 'nfs-server.service'
        server_servicehelper = 'nfs-idmap.service'
        server_packages = %w(nfs-utils nfs4-acl-tools rpcbind)
        client_services = %w(rpcbind.service)
        client_nfs_vfour_services = %w(rpcbind.service)
        client_packages = %w(nfs-utils nfs4-acl-tools rpcbind)

      when 'Gentoo'

        let(:facts) do
          default_facts.merge(
            operatingsystem: 'Gentoo',
            osfamily: 'Gentoo',
            operatingsystemmajrelease: '1',
          )
        end
        server_service = 'nfs'
        server_servicehelper = 'rpc.idmapd'
        server_packages = %w(net-nds/rpcbind net-fs/nfs-utils net-libs/libnfsidmap)
        client_services = %w(rpcbind)
        client_nfs_vfour_services = %w(rpcbind rpc.idmapd)
        client_packages = %w(net-nds/rpcbind net-fs/nfs-utils net-libs/libnfsidmap)

      when 'SLES'

        let(:facts) do
          default_facts.merge(
            operatingsystem: 'SLES',
            osfamily: 'Suse',
            operatingsystemmajrelease: '12',
          )
        end
        server_service = 'nfsserver'
        server_servicehelper = ''
        server_packages = %w(nfs-kernel-server)
        client_services = %w(rpcbind nfs)
        client_nfs_vfour_services = %w(rpcbind nfs)
        client_packages = %w(nfsidmap nfs-client rpcbind)

      when 'Archlinux'

        let(:facts) do
          default_facts.merge(
            operatingsystem: 'Archlinux',
            osfamily: 'Archlinux',
            operatingsystemmajrelease: '3',
          )
        end
        server_service = 'nfs-server.service'
        server_servicehelper = 'rpc.idmapd'
        server_packages = %w(nfs-utils)
        client_services = %w(rpcbind)
        client_nfs_vfour_services = %w(rpcbind rpc.idmapd)
        client_packages = %w(nfsidmap rpcbind)

      end
      ### ^^ Switch Case to set OS specific values ^^ ###

      it { is_expected.to compile.with_all_deps }

      context 'server_enabled => true, client_enabled => false' do
        let(:params) { { server_enabled: true, client_enabled: false, } }
        it { should contain_class('nfs::server::config') }
        it { should contain_class('nfs::server::package') }
        it { should contain_class('nfs::server::service') }
        it { should contain_concat__fragment('nfs_exports_header').with('target' => '/etc/exports') }

        server_packages.each do |package|
          context os do
            it { should contain_package(package) }
          end
        end

        context 'nfs_v4 => true' do
          let(:params) { { nfs_v4: true, server_enabled: true, client_enabled: false, nfs_v4_idmap_domain: 'teststring' } }
          it { should contain_concat__fragment('nfs_exports_root').with('target' => '/etc/exports') }
          it { should contain_file('/export').with('ensure' => 'directory') }
          it { should contain_augeas('/etc/idmapd.conf').with_changes(/set Domain teststring/) }
          context os do
            if server_servicehelper != ''
              it { should contain_service(server_servicehelper)
                .with('ensure' => 'running')
                .with_subscribe(['Concat[/etc/exports]', 'Augeas[/etc/idmapd.conf]'])
              }
            end
          end
        end
      end

      context 'server_enabled => false, client_enabled => true' do
        let(:params) { { server_enabled: false, client_enabled: true, } }
        it { should contain_class('nfs::client::config') }
        it { should contain_class('nfs::client::package') }
        it { should contain_class('nfs::client::service') }
        context os do
          client_services.each do |service|
            it { should contain_service(service)
              .with('ensure' => 'running')
              .with_subscribe([])
            }
          end
        end

        context 'nfs_v4 => true' do
          let(:params) { { nfs_v4_client: true, server_enabled: false, client_enabled: true, } }
          it { should contain_augeas('/etc/idmapd.conf') }
          client_nfs_vfour_services.each do |service|
            context os do
              it { should contain_service(service)
                .with('ensure' => 'running')
                .with_subscribe(/Augeas/)
              }
            end
          end
          client_packages.each do |package|
            context os do
              client_nfs_vfour_services.each do |service|
                service = 'Service[' + service + ']'
                it { should contain_package(package).that_notifies(service) }
              end
            end
          end
        end
      end

      context 'server_enabled => true, client_enabled => true' do
        let(:params) { { server_enabled: true, client_enabled: true, } }
        it { should contain_class('nfs::server::config') }
        it { should contain_class('nfs::server::package') }
        it { should contain_class('nfs::server::service') }
        it { should contain_class('nfs::client::config') }
        it { should contain_class('nfs::client::package') }
        it { should contain_class('nfs::client::service') }
        it { should contain_concat__fragment('nfs_exports_header').with('target' => '/etc/exports') }

        context 'nfs_v4 => true, nfs_v4_client => true' do
          let(:params) { { nfs_v4: true, nfs_v4_client: true, server_enabled: true, client_enabled: true, nfs_v4_idmap_domain: 'teststring' } }
          it { should contain_augeas('/etc/idmapd.conf') }
          it { should contain_concat__fragment('nfs_exports_root').with('target' => '/etc/exports') }
          it { should contain_file('/export').with('ensure' => 'directory') }
          it { should contain_augeas('/etc/idmapd.conf').with_changes(/set Domain teststring/) }
          context os do
            if server_servicehelper != ''
              it { should contain_service(server_servicehelper)
                .with('ensure' => 'running')
                .with_subscribe(['Concat[/etc/exports]', 'Augeas[/etc/idmapd.conf]'])
              }
            end
          end
          server_packages.each do |package|
            context os do
              service = 'Service[' + server_service + ']'
              it { should contain_package(package).that_notifies(service) }
            end
          end
        end
      end

      context ':nfs_v4_client => true, :nfs_v4 => true, :server_enabled => true, :client_enabled => true, :manage_packages => false' do
        let(:params) { { nfs_v4_client: true, nfs_v4: true, client_enabled: true, server_enabled: true, manage_packages: false, } }
        client_packages.each do |package|
          context os do
            it { should_not contain_package(package) }
          end
        end
        server_packages.each do |package|
          context os do
            it { should_not contain_package(package) }
          end
        end
      end

      context ':nfs_v4_client => true, :nfs_v4 => true, :server_enabled => true, :manage_server_service => false, manage_server_servicehelper => false, :manage_client_service => false' do
        let(:params) { { nfs_v4_client: true, nfs_v4: true, client_enabled: true, server_enabled: true, manage_server_service: false, manage_server_servicehelper: false, manage_client_service: false, } }
        client_nfs_vfour_services.each do |service|
          context os do
            it { should_not contain_service(service) }
          end
        end
        context os do
          it { should_not contain_service(server_service) }
        end
        context os do
          it { should_not contain_service(server_servicehelper) }
        end
      end
    end
  end
end
