require 'spec_helper_acceptance'

describe 'nfs class' do
  if fact('osfamily') == 'Debian'
    if fact('lsbdistcodename') == 'jessie'
      server_service = 'nfs-kernel-server'
      server_servicehelpers = %w[nfs-common]
    elsif fact('lsbdistcodename') == 'trusty'
      server_service = 'nfs-kernel-server'
      server_servicehelpers = %w[idmapd]
    else
      server_service = 'nfs-server'
      server_servicehelpers = %w[nfs-idmapd]
    end
    server_packages = %w[nfs-common nfs-kernel-server nfs4-acl-tools rpcbind]
  end

  if fact('osfamily') == 'RedHat'
    if fact('operatingsystemmajrelease') == '6'
      server_service = 'nfs'
      server_servicehelpers = %w[rpcidmapd rpcbind]
      server_packages = %w[nfs-utils nfs4-acl-tools rpcbind]
    end
    if fact('operatingsystemmajrelease') == '7'
      server_service = 'nfs-server.service'
      server_servicehelpers = %w[nfs-idmap.service]
      server_packages = %w[nfs-utils nfs4-acl-tools rpcbind]
    end
  end

  describe 'include nfs without params' do
    context 'default parameters' do
      let(:pp) { "class { 'nfs': }" }

      it 'applies without errors without params' do
        apply_manifest('include nfs', catch_failures: true)
      end
    end
  end

  describe 'include nfs with server params' do
    context 'server params' do
      server_pp = <<-PUPPETCODE
        file { ['/data_folder', '/homeexport']:
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
        }
        nfs::server::export { '/homeexport':
          ensure  => 'mounted',
          clients => '*(rw,insecure,async,root_squash,no_subtree_check)',
          mount   => '/srv/home',
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

      # Buggy nfs-kernel-server does not run in docker ubuntu 14.04 and Centos 6
      if fact('lsbdistcodename') != 'trusty' && (fact('osfamily') != 'RedHat' && fact('operatingsystemmajrelease') != '6')
        describe service(server_service) do
          it { is_expected.to be_running }
        end
      end

      server_servicehelpers.each do |server_servicehelper|
        describe service(server_servicehelper) do
          it { is_expected.to be_running }
        end
      end
    end
  end
end
