# frozen_string_literal: true

require 'spec_helper'

describe 'nfs' do
  supported_os = %w[Ubuntu_default Ubuntu_16.04 Debian_default Debian_8 RedHat_default RedHat_7 RedHat_75 Gentoo SLES Archlinux]
  supported_os.each do |os|
    context os do
      let(:default_facts) do
        {
          concat_basedir: '/tmp',
          clientcert: 'test.host',
          is_pe: false,
          id: 'root',
          path: '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin'
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
            lsbdistcodename: 'trusty'
          )
        end

        server_service = 'nfs-kernel-server'
        server_servicehelpers = ''
        server_packages = %w[nfs-common nfs-kernel-server nfs4-acl-tools rpcbind]
        client_services = %w[rpcbind]
        client_nfs_vfour_services = %w[rpcbind]
        client_packages = %w[nfs-common nfs4-acl-tools]
        client_gssdopt_name = 'RPCGSSDOPTS'
        defaults_file = '/etc/default/nfs-common'
        idmapd_file = '/etc/idmapd.conf'
        client_rpcbind_config = '/etc/default/rpcbind'
        client_rpcbind_optname = 'OPTIONS'

      when 'Ubuntu_16.04'

        let(:facts) do
          default_facts.merge(
            operatingsystem: 'Ubuntu',
            osfamily: 'Debian',
            operatingsystemmajrelease: '16.04',
            lsbdistcodename: 'xenial'
          )
        end

        server_service = 'nfs-kernel-server'
        server_servicehelpers = %w[nfs-idmapd]
        server_packages = %w[nfs-common nfs-kernel-server nfs4-acl-tools rpcbind]
        client_services = %w[rpcbind]
        client_nfs_vfour_services = %w[rpcbind]
        client_packages = %w[nfs-common nfs4-acl-tools]
        client_gssdopt_name = 'GSSDARGS'
        defaults_file = '/etc/default/nfs-common'
        idmapd_file = '/etc/idmapd.conf'
        client_rpcbind_config = '/etc/default/rpcbind'
        client_rpcbind_optname = 'OPTIONS'

      when 'Ubuntu_18.04'

        let(:facts) do
          default_facts.merge(
            operatingsystem: 'Ubuntu',
            osfamily: 'Debian',
            operatingsystemmajrelease: '18.04',
            lsbdistcodename: 'bionic'
          )
        end

        server_service = 'nfs-server'
        server_servicehelpers = %w[nfs-idmapd]
        server_packages = %w[nfs-common nfs-kernel-server nfs4-acl-tools rpcbind]
        client_services = %w[rpcbind]
        client_nfs_vfour_services = %w[rpcbind nfs-server]
        client_packages = %w[nfs-common nfs4-acl-tools]
        client_gssdopt_name = 'GSSDARGS'
        defaults_file = '/etc/default/nfs-common'
        idmapd_file = '/etc/idmapd.conf'
        client_rpcbind_config = '/etc/default/rpcbind'
        client_rpcbind_optname = 'OPTIONS'

      when 'Debian_default'

        let(:facts) do
          default_facts.merge(
            operatingsystem: 'Debian',
            osfamily: 'Debian',
            operatingsystemmajrelease: '7',
            lsbdistcodename: 'wheezy'
          )
        end

        server_service = 'nfs-kernel-server'
        server_servicehelpers = %w[nfs-common]
        server_packages = %w[nfs-common nfs-kernel-server nfs4-acl-tools rpcbind]
        client_services = %w[rpcbind]
        client_nfs_vfour_services = %w[rpcbind nfs-common]
        client_packages = %w[nfs-common nfs4-acl-tools]
        client_gssdopt_name = 'RPCGSSDOPTS'
        defaults_file = '/etc/default/nfs-common'
        idmapd_file = '/etc/idmapd.conf'
        client_rpcbind_config = '/etc/default/rpcbind'
        client_rpcbind_optname = 'OPTIONS'

      when 'Debian_8'

        let(:facts) do
          default_facts.merge(
            operatingsystem: 'Debian',
            osfamily: 'Debian',
            operatingsystemmajrelease: '8',
            lsbdistcodename: 'jessie'
          )
        end

        server_service = 'nfs-kernel-server'
        server_servicehelpers = %w[nfs-common]
        server_packages = %w[nfs-common nfs-kernel-server nfs4-acl-tools rpcbind]
        client_services = %w[rpcbind]
        client_nfs_vfour_services = %w[rpcbind nfs-common]
        client_packages = %w[nfs-common nfs4-acl-tools]
        client_gssdopt_name = 'RPCGSSDOPTS'
        defaults_file = '/etc/default/nfs-common'
        idmapd_file = '/etc/idmapd.conf'
        client_rpcbind_config = '/etc/default/rpcbind'
        client_rpcbind_optname = 'OPTIONS'

      when 'Debian_9'

        let(:facts) do
          default_facts.merge(
            operatingsystem: 'Debian',
            osfamily: 'Debian',
            operatingsystemmajrelease: '9',
            lsbdistcodename: 'stretch'
          )
        end

        server_service = 'nfs-kernel-server'
        server_servicehelpers = %w[nfs-idmapd]
        server_packages = %w[nfs-common nfs-kernel-server nfs4-acl-tools rpcbind]
        client_services = %w[rpcbind]
        client_nfs_vfour_services = %w[rpcbind]
        client_packages = %w[nfs-common nfs4-acl-tools]
        client_gssdopt_name = 'GSSDARGS'
        defaults_file = '/etc/default/nfs-common'
        idmapd_file = '/etc/idmapd.conf'
        client_rpcbind_config = '/etc/default/rpcbind'
        client_rpcbind_optname = 'OPTIONS'

      when 'RedHat_default'

        let(:facts) do
          default_facts.merge(
            operatingsystem: 'RedHat',
            osfamily: 'RedHat',
            operatingsystemmajrelease: '8'
          )
        end

        server_service = 'nfs'
        server_servicehelpers = %w[rpcidmapd rpcbind]
        server_packages = %w[nfs-utils nfs4-acl-tools rpcbind]
        client_services = %w[rpcbind]
        client_nfs_vfour_services = %w[rpcbind rpcidmapd]
        client_packages = %w[nfs-utils nfs4-acl-tools rpcbind]
        client_gssdopt_name = 'RPCGSSDARGS'
        defaults_file = '/etc/sysconfig/nfs'
        idmapd_file = '/etc/idmapd.conf'
        client_rpcbind_config = '/etc/sysconfig/rpcbind'
        client_rpcbind_optname = 'RPCBIND_ARGS'

      when 'RedHat_7'

        let(:facts) do
          default_facts.merge(
            operatingsystem: 'RedHat',
            osfamily: 'RedHat',
            operatingsystemmajrelease: '7',
            operatingsystemrelease: '7.4'
          )
        end

        server_service = 'nfs-server.service'
        server_servicehelpers = %w[nfs-idmap.service]
        server_packages = %w[nfs-utils nfs4-acl-tools rpcbind]
        client_services = %w[rpcbind.service rpcbind.socket]
        client_nfs_vfour_services = %w[rpcbind.service rpcbind.socket]
        client_packages = %w[nfs-utils nfs4-acl-tools rpcbind]
        client_gssdopt_name = 'RPCGSSDARGS'
        defaults_file = '/etc/sysconfig/nfs'
        idmapd_file = '/etc/idmapd.conf'
        client_rpcbind_config = '/etc/sysconfig/rpcbind'
        client_rpcbind_optname = 'RPCBIND_ARGS'

      when 'RedHat_75'

        let(:facts) do
          default_facts.merge(
            operatingsystem: 'RedHat',
            osfamily: 'RedHat',
            operatingsystemmajrelease: '7',
            operatingsystemrelease: '7.5'
          )
        end

        server_service = 'nfs-server.service'
        server_servicehelpers = %w[nfs-idmap.service]
        server_packages = %w[nfs-utils nfs4-acl-tools rpcbind]
        client_services = %w[rpcbind.service]
        client_nfs_vfour_services = %w[rpcbind]
        client_packages = %w[nfs-utils nfs4-acl-tools rpcbind]
        client_gssdopt_name = 'RPCGSSDARGS'
        defaults_file = '/etc/sysconfig/nfs'
        idmapd_file = '/etc/idmapd.conf'
        client_rpcbind_config = '/etc/sysconfig/rpcbind'
        client_rpcbind_optname = 'RPCBIND_ARGS'

      when 'Gentoo'

        let(:facts) do
          default_facts.merge(
            operatingsystem: 'Gentoo',
            osfamily: 'Gentoo',
            operatingsystemmajrelease: '1'
          )
        end

        server_service = 'nfs'
        server_servicehelpers = %w[rpc.idmapd]
        server_packages = %w[net-nds/rpcbind net-fs/nfs-utils net-libs/libnfsidmap]
        client_services = %w[rpcbind]
        client_nfs_vfour_services = %w[rpcbind rpc.idmapd]
        client_packages = %w[net-nds/rpcbind net-fs/nfs-utils net-libs/libnfsidmap]
        client_gssdopt_name = 'RPCGSSDARGS'
        defaults_file = '/etc/conf.d/nfs'
        idmapd_file = '/etc/idmapd.conf'
        client_rpcbind_optname  = 'OPTS_RPC_NFSD'
      when 'SLES'

        let(:facts) do
          default_facts.merge(
            operatingsystem: 'SLES',
            osfamily: 'Suse',
            operatingsystemmajrelease: '12'
          )
        end

        server_service = 'nfsserver'
        server_servicehelpers = ''
        server_packages = %w[nfs-kernel-server]
        client_services = %w[rpcbind nfs]
        client_nfs_vfour_services = %w[rpcbind nfs]
        client_packages = %w[nfsidmap nfs-client rpcbind]
        client_gssdopt_name = 'GSSD_OPTIONS'
        defaults_file = ''
        idmapd_file = '/etc/idmapd.conf'
        client_rpcbind_optname = 'RPCNFSDARGS'

      when 'Archlinux'

        let(:facts) do
          default_facts.merge(
            operatingsystem: 'Archlinux',
            osfamily: 'Archlinux',
            operatingsystemmajrelease: '3'
          )
        end

        server_service = 'nfs-server.service'
        server_servicehelpers = %w[nfs-idmapd]
        server_packages = %w[nfs-utils]
        client_services = %w[rpcbind]
        client_nfs_vfour_services = %w[rpcbind]
        client_packages = %w[nfsidmap rpcbind]
        client_gssdopt_name = 'RPCGSSDARGS'
        defaults_file = ''
        idmapd_file = '/etc/idmapd.conf'
        client_rpcbind_optname  = 'RPCNFSDARGS'

      end
      ### ^^ Switch Case to set OS specific values ^^ ###

      it { is_expected.to compile.with_all_deps }

      context 'when server_enabled => true, client_enabled => false' do
        let(:params) { { server_enabled: true, client_enabled: false } }

        it { is_expected.to contain_class('nfs::server::config') }
        it { is_expected.to contain_class('nfs::server::package') }
        it { is_expected.to contain_class('nfs::server::service') }
        it { is_expected.to contain_concat__fragment('nfs_exports_header').with('target' => '/etc/exports') }

        server_packages.each do |package|
          context os do
            it { is_expected.to contain_package(package) }
          end
        end

        context 'when nfs_v4 => true' do
          let(:params) { { nfs_v4: true, server_enabled: true, client_enabled: false, nfs_v4_idmap_domain: 'teststring' } }

          it { is_expected.to contain_concat__fragment('nfs_exports_root').with('target' => '/etc/exports') }
          it { is_expected.to contain_file('/export').with('ensure' => 'directory') }
          it { is_expected.to contain_augeas('/etc/idmapd.conf').with_changes(%r{set General/Domain teststring}) }
          context os do
            if server_servicehelpers != ''
              server_servicehelpers.each do |server_servicehelper|
                it do
                  is_expected.to contain_service(server_servicehelper).
                    with('ensure' => 'running').
                    with_subscribe(['Concat[/etc/exports]', 'Augeas[/etc/idmapd.conf]'])
                end
              end
            end
          end
        end
      end

      context 'when server_enabled => false, client_enabled => true' do
        let(:params) { { server_enabled: false, client_enabled: true } }

        it { is_expected.to contain_class('nfs::client::config') }
        it { is_expected.to contain_class('nfs::client::package') }
        it { is_expected.to contain_class('nfs::client::service') }

        context os do
          case os
          when 'RedHat_7'
            it do
              is_expected.to contain_service('rpcbind.service').
                with('ensure' => 'running').
                with('enable' => false).
                without_subscribe
            end
            it do
              is_expected.to contain_service('rpcbind.socket').
                with('ensure' => 'running').
                with('enable' => true).
                without_subscribe
            end
          else
            client_services.each do |service|
              it do
                is_expected.to contain_service(service).
                  with('ensure' => 'running').
                  without_subscribe
              end
            end
          end
        end

        context 'when nfs_v4 => true' do
          let(:params) { { nfs_v4_client: true, server_enabled: false, client_enabled: true } }

          it { is_expected.to contain_augeas('/etc/idmapd.conf') }
          client_nfs_vfour_services.each do |service|
            context os do
              it do
                is_expected.to contain_service(service).
                  with('ensure' => 'running').
                  with_subscribe(%r{Augeas})
              end
            end
          end
          client_packages.each do |package|
            context os do
              client_nfs_vfour_services.each do |service|
                service = 'Service[' + service + ']'
                it { is_expected.to contain_package(package).that_notifies(service) }
              end
            end
          end
        end
      end

      context 'when server_enabled => true, client_enabled => true' do
        let(:params) { { server_enabled: true, client_enabled: true } }

        it { is_expected.to contain_class('nfs::server::config') }
        it { is_expected.to contain_class('nfs::server::package') }
        it { is_expected.to contain_class('nfs::server::service') }
        it { is_expected.to contain_class('nfs::client::config') }
        it { is_expected.to contain_class('nfs::client::package') }
        it { is_expected.to contain_class('nfs::client::service') }
        it { is_expected.to contain_concat__fragment('nfs_exports_header').with('target' => '/etc/exports') }

        context 'when nfs_v4 => true, nfs_v4_client => true' do
          let(:params) { { nfs_v4: true, nfs_v4_client: true, server_enabled: true, client_enabled: true, nfs_v4_idmap_domain: 'teststring' } }

          it { is_expected.to contain_augeas('/etc/idmapd.conf') }
          it { is_expected.to contain_concat__fragment('nfs_exports_root').with('target' => '/etc/exports') }
          it { is_expected.to contain_file('/export').with('ensure' => 'directory') }
          it { is_expected.to contain_augeas('/etc/idmapd.conf').with_changes(%r{set General/Domain teststring}) }
          context os do
            if server_servicehelpers != ''
              server_servicehelpers.each do |server_servicehelper|
                it do
                  is_expected.to contain_service(server_servicehelper).
                    with('ensure' => 'running').
                    with_subscribe(['Concat[/etc/exports]', 'Augeas[/etc/idmapd.conf]'])
                end
              end
            end
          end
          server_packages.each do |package|
            context os do
              service = 'Service[' + server_service + ']'
              it { is_expected.to contain_package(package).that_notifies(service) }
            end
          end
        end
      end

      context 'when :nfs_v4_client => true, :nfs_v4 => true, :server_enabled => true, :client_enabled => true, :manage_packages => false' do
        let(:params) { { nfs_v4_client: true, nfs_v4: true, client_enabled: true, server_enabled: true, manage_packages: false } }

        client_packages.each do |package|
          context os do
            it { is_expected.not_to contain_package(package) }
          end
        end
        server_packages.each do |package|
          context os do
            it { is_expected.not_to contain_package(package) }
          end
        end
      end

      context 'when :nfs_v4_client => true, :nfs_v4 => true, :server_enabled => true, :manage_server_service => false, manage_server_servicehelper => false, :manage_client_service => false' do
        let(:params) { { nfs_v4_client: true, nfs_v4: true, client_enabled: true, server_enabled: true, manage_server_service: false, manage_server_servicehelper: false, manage_client_service: false } }

        client_nfs_vfour_services.each do |service|
          context os do
            it { is_expected.not_to contain_service(service) }
          end
        end
        context os do
          it { is_expected.not_to contain_service(server_service) }
        end
        context os do
          if server_servicehelpers != ''
            server_servicehelpers.each do |server_servicehelper|
              it { is_expected.not_to contain_service(server_servicehelper) }
            end
          end
        end
      end

      context 'when nfs_v4 => true, storeconfigs_enabled => true' do
        let(:params) { { nfs_v4: true, storeconfigs_enabled: true, server_enabled: true, nfs_v4_idmap_domain: 'teststring' } }

        context os do
          it { expect(exported_resources).to contain_nfs__client__mount('/srv') }
        end
      end

      context 'when nfs_v4 => true, storeconfigs_enabled => false' do
        let(:params) { { nfs_v4: true, storeconfigs_enabled: false, server_enabled: true, nfs_v4_idmap_domain: 'teststring' } }

        context os do
          it { expect(exported_resources).not_to contain_nfs__client__mount('/srv') }
        end
      end

      context 'when nfs_v4 => false, storeconfigs_enabled => true' do
        let(:params) { { nfs_v4: false, storeconfigs_enabled: true, server_enabled: true, nfs_v4_idmap_domain: 'teststring' } }

        context os do
          it { expect(exported_resources).not_to contain_nfs__client__mount('/srv') }
        end
      end

      context 'when server_enabled => true, client_enabled => true, nfs_v4_client => true' do
        let(:params) { { server_enabled: true, client_enabled: true, nfs_v4: false, nfs_v4_client: true } }

        context os do
          it { is_expected.to contain_augeas('/etc/idmapd.conf') }
        end
      end

      context 'when server_enabled => true, nfs_v4 => true, nfsv4_bindmount_enable => false' do
        let(:params) { { nfs_v4: true, nfsv4_bindmount_enable: false, server_enabled: true, nfs_v4_idmap_domain: 'teststring' } }

        it { is_expected.to contain_class('nfs::server::config') }
        it { is_expected.to contain_class('nfs::server::package') }
        it { is_expected.to contain_class('nfs::server::service') }
        it { is_expected.to contain_concat__fragment('nfs_exports_header').with('target' => '/etc/exports') }

        context 'when nfs_v4 => true, nfs_v4_client => true' do
          let(:params) { { nfs_v4: true, nfsv4_bindmount_enable: false, nfs_v4_client: true, server_enabled: true, client_enabled: true, nfs_v4_idmap_domain: 'teststring' } }

          it { is_expected.to contain_augeas('/etc/idmapd.conf') }
          it { is_expected.to contain_concat__fragment('nfs_exports_root').with('target' => '/etc/exports') }
          it { is_expected.to contain_file('/export').with('ensure' => 'directory') }
          it { is_expected.to contain_augeas('/etc/idmapd.conf').with_changes(%r{set General/Domain teststring}) }
        end
      end


      context 'when :nfs_v4_client => true, :client_enabled => true, nfs_v4 => true' do
        let(:params) { { nfs_v4: true, nfs_v4_client: true, client_enabled: true } }

        if defaults_file != ''
          it { is_expected.not_to contain_augeas(defaults_file).with_changes(%r{.*set #{client_gssdopt_name}.*}) }
        end

        if idmapd_file != ''
          it { is_expected.to contain_augeas(idmapd_file) }
          it { is_expected.not_to contain_augeas(idmapd_file).with_changes(%r{.*set General/Local-Realms.*}) }
          it { is_expected.not_to contain_augeas(idmapd_file).with_changes(%r{.*set General/Cache-Expiration.*}) }
          it { is_expected.not_to contain_augeas(idmapd_file).with_changes(%r{.*set Mapping/Nobody-User.*}) }
          it { is_expected.not_to contain_augeas(idmapd_file).with_changes(%r{.*set Mapping/Nobody-Group.*}) }
        end

        if client_rpcbind_config != ''
          it { is_expected.not_to contain_augeas(client_rpcbind_config) }
        end

      end


      context 'when :nfs_v4_client => true, :client_enabled => true, nfs_v4 => true, client_gssd_options => gssd_option_1' do
        let(:params) { { nfs_v4: true, nfs_v4_client: true, client_enabled: true, client_gssd_options: 'gssd_option_1' } }

        if defaults_file != ''
          it { is_expected.to contain_augeas(defaults_file) }
          it { is_expected.to contain_augeas(defaults_file).with_changes(%r{.*set #{client_gssdopt_name}.*gssd_option_1.*}) }
        end
      end

      context 'when :nfs_v4_client => true, :client_enabled => true, nfs_v4 => true, nfs_v4_idmap_localrealms => testrealm' do
        let(:params) { { nfs_v4: true, nfs_v4_client: true, client_enabled: true, nfs_v4_idmap_localrealms: 'testrealm' } }

        if idmapd_file != ''
          it { is_expected.to contain_augeas(idmapd_file) }
          it { is_expected.to contain_augeas(idmapd_file).with_changes(%r{.*set General/Local-Realms testrealm}) }
        end
      end

      context 'when :nfs_v4_client => true, :client_enabled => true, nfs_v4 => true, nfs_v4_idmap_cache => 30' do
        let(:params) { { nfs_v4: true, nfs_v4_client: true, client_enabled: true, nfs_v4_idmap_cache: 30 } }

        if idmapd_file != ''
          it { is_expected.to contain_augeas(idmapd_file) }
          it { is_expected.to contain_augeas(idmapd_file).with_changes(%r{.*set General/Cache-Expiration 30}) }
        end
      end

      context 'when :nfs_v4_client => true, :client_enabled => true, nfs_v4 => true, manage_nfs_v4_idmap_nobody_mapping => true, nfs_v4_idmap_nobody_user => user, nfs_v4_idmap_nobody_group => group' do
        let(:params) { { nfs_v4: true, nfs_v4_client: true, client_enabled: true, manage_nfs_v4_idmap_nobody_mapping: true, nfs_v4_idmap_nobody_user: 'user', nfs_v4_idmap_nobody_group: 'group' } }

        if idmapd_file != ''
          it { is_expected.to contain_augeas(idmapd_file) }
          it { is_expected.to contain_augeas(idmapd_file).with_changes(%r{.*set Mapping/Nobody-User user}) }
          it { is_expected.to contain_augeas(idmapd_file).with_changes(%r{.*set Mapping/Nobody-Group group}) }
        end
      end

      if !client_rpcbind_config.is_a? String
        client_rpcbind_config = '/etc/default/rpcbind'
      end

      context 'when :nfs_v4_client => true, :client_enabled => true, nfs_v4 => true, client_rpcbind_config => #{client_rpcbind_config}' do
        let(:params) { { nfs_v4: true, nfs_v4_client: true, client_enabled: true, client_rpcbind_config: client_rpcbind_config, client_rpcbind_optname: client_rpcbind_optname, client_rpcbind_opts: 'rpcbind_option' } }

        it { is_expected.to contain_augeas(client_rpcbind_config) }
        it { is_expected.to contain_augeas(client_rpcbind_config).with_changes(%r{.*set #{client_rpcbind_optname}.*rpcbind_option}) }
      end

    end
  end
end
