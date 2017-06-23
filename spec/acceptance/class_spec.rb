require 'spec_helper_acceptance'

describe 'nfs class' do
  if fact('osfamily') == 'Debian'
    if fact('lsbdistcodename') == 'trusty'
      server_service = 'nfs-kernel-server'
      server_servicehelper = 'idmapd'
      server_packages = %w[nfs-common nfs-kernel-server nfs4-acl-tools rpcbind]
    end

    if fact('lsbdistcodename') == 'xenial'
      server_service = 'nfs-server'
      server_servicehelper = 'nfs-idmapd'
      server_packages = %w[nfs-common nfs-kernel-server nfs4-acl-tools rpcbind]
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
      server_pp = <<-EOS
        file { ['/data_folder', '/homeexport']:
          ensure => 'directory',
        }
        class { '::nfs':
          server_enabled => true,
          nfs_v4 => true,
          nfs_v4_idmap_domain => 'example.com',
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
      EOS

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

      # Buggy nfs-kernel-server does not run in docker ubuntu 14.04
      if fact('lsbdistcodename') == 'xenial'
        describe service(server_service) do
          it { is_expected.to be_running }
        end
      end

      describe service(server_servicehelper) do
        it { is_expected.to be_running }
      end
    end
  end
end
