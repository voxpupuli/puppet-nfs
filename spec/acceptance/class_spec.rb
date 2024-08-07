# frozen_string_literal: true

require 'spec_helper_acceptance'

describe 'nfs class' do
  case fact('os.family')

  when 'Debian'
    server_servicehelpers = %w[nfs-idmapd]
    client_services = %w[rpcbind]
    server_packages = %w[nfs-common nfs-kernel-server nfs4-acl-tools rpcbind]
    client_packages = %w[nfs-common nfs4-acl-tools rpcbind]

  when 'RedHat'
    server_servicehelpers = %w[nfs-idmapd.service]
    client_services = %w[rpcbind.service rpcbind.socket]
    server_packages = %w[nfs-utils nfs4-acl-tools rpcbind]
    client_packages = %w[nfs-utils nfs4-acl-tools rpcbind]
  end

  describe 'include nfs without params' do
    context 'when default parameters' do
      let(:pp) { "class { 'nfs': }" }

      it 'applies without errors without params' do
        apply_manifest('include nfs', catch_failures: true)
      end
    end
  end

  describe 'include nfs with client params' do
    context 'when client params' do
      client_pp = <<-PUPPETCODE
        class { '::nfs':
          server_enabled => false,
          client_enabled => true,
          nfs_v4_client => true,
          nfs_v4_idmap_domain => 'example.org',
          manage_server_service => false,
        }
      PUPPETCODE

      it 'works with no errors based on the example' do
        expect(apply_manifest(client_pp).exit_code).not_to eq(1)
      end

      it 'runs a second time without changes' do
        expect(apply_manifest(client_pp).exit_code).to eq(0)
      end

      client_packages.each do |package|
        describe package(package) do
          it { is_expected.to be_installed }
        end
      end

      client_services.each do |service|
        # puppet reports wrong status for nfs-common on wheezy
        if service == 'nfs-common' && fact('os.distro.codename') == 'wheezy'
          puts 'puppet reports wrong status for nfs-common on wheezy'
        else
          describe service(service) do
            it { is_expected.to be_running }
          end
        end
      end

      puts 'server services can not be started due to container and kernel modules'
      # describe service(server_service) do
      #   it { is_expected.not_to be_running }
      # end

      server_packages_only = server_packages - client_packages
      server_packages_only.each do |package|
        describe package(package) do
          it { is_expected.not_to be_installed }
        end
      end
    end
  end

  describe 'include nfs with server params' do
    context 'when server params' do
      server_pp = <<-PUPPETCODE
        file { ['/export', '/data_folder', '/homeexport']:
          ensure => 'directory',
        }
        class { '::nfs':
          server_enabled => true,
          nfs_v4 => true,
          nfs_v4_idmap_domain => 'example.org',
          nfs_v4_export_root  => '/export',
          nfs_v4_export_root_clients => '*(rw,fsid=0,insecure,no_subtree_check,async,no_root_squash)',
        }
        nfs::server::export { '/data_folder':
          ensure  => 'mounted',
          clients => '*(rw,insecure,async,no_root_squash,no_subtree_check)',
          before => Class['nfs::server::service'],
        }
        nfs::server::export { '/homeexport':
          ensure  => 'mounted',
          clients => '*(rw,insecure,async,root_squash,no_subtree_check)',
          mount   => '/srv/home',
          before => Class['nfs::server::service'],
        }
      PUPPETCODE

      it 'works with no errors based on the example' do
        expect(apply_manifest(server_pp).exit_code).not_to eq(1)
      end

      it 'runs a second time without changes' do
        expect(apply_manifest(server_pp).exit_code).to eq(0)
      end

      server_packages.each do |package|
        describe package(package) do
          it { is_expected.to be_installed }
        end
      end

      # Buggy nfs-kernel-server does not run in docker with Ubuntu 14.04, Debian wheezy and CentOs 6 images
      if fact('os.distro.codename') == 'trusty' || fact('os.distro.codename') == 'wheezy' || (fact('os.family') == 'RedHat' && fact('os.release.major') == '6')
        puts 'Buggy nfs-kernel-server does not run in docker with Ubuntu 14.04, Debian wheezy and CentOs 6 images'
      else
        puts 'server services can not be started due to container and kernel modules'
        # describe service(server_service) do
        #   it { is_expected.to be_running }
        # end
      end

      if server_servicehelpers != ''
        server_servicehelpers.each do |server_servicehelper|
          # puppet reports wrong status for nfs-common on wheezy
          if server_servicehelper == 'nfs-common' && fact('os.distro.codename') == 'wheezy'
            puts 'puppet reports wrong status for nfs-common on wheezy'
          else
            puts 'server services can not be started due to container and kernel modules'
            # describe service(server_servicehelper) do
            #   it { is_expected.to be_running }
            # end
          end
        end
      end
    end
  end
end
