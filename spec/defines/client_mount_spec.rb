# frozen_string_literal: true

require 'spec_helper'

describe 'nfs::client::mount', type: 'define' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts
      end

      client_packages = {
        'Debian' => [
          'Package[nfs-common]',
          'Package[nfs4-acl-tools]',
        ],
        'RedHat' => [
          'Package[nfs-utils]',
          'Package[nfs4-acl-tools]',
        ],
        'Suse' => [
          'Package[nfs-client]',
        ],
      }[facts[:os]['family']]

      context 'when nfs_v4 => false, minimal arguments' do
        let(:title) { '/srv/test' }

        let(:pre_condition) { 'class { "nfs": client_enabled => true }' }

        let(:params) { { server: '1.2.3.4' } }

        it { is_expected.to contain_nfs__functions__mkdir('/srv/test') }

        it do
          is_expected.to contain_mount('shared /srv/test by 1.2.3.4 on /srv/test').that_requires(
            [
              'Nfs::Functions::Mkdir[/srv/test]',
            ] + client_packages
          )
        end
      end

      context 'when nfs_v4 => false, specified mountpoint and sharename' do
        let(:title) { 'Import /srv' }

        let(:pre_condition) { 'class {"nfs": client_enabled => true,}' }

        let(:params) { { share: '/export/srv', mount: '/srv', server: '1.2.3.4' } }

        it { is_expected.to contain_nfs__functions__mkdir('/srv') }

        it do
          is_expected.to contain_mount('shared /export/srv by 1.2.3.4 on /srv').that_requires(
            [
              'Nfs::Functions::Mkdir[/srv]',
            ] + client_packages
          )
        end
      end

      context 'when nfs_v4 => true, specified share' do
        let(:title) { '/srv/test' }

        let(:pre_condition) { 'class {"nfs": client_enabled => true, nfs_v4_client => true }' }

        let(:params) { { share: 'test', server: '1.2.3.4' } }

        it { is_expected.to contain_nfs__functions__mkdir('/srv/test') }

        it do
          is_expected.to contain_mount('shared /test by 1.2.3.4 on /srv/test').that_requires(
            [
              'Nfs::Functions::Mkdir[/srv/test]',
            ] + client_packages
          )
        end
      end

      context 'when nfs_v4 => true, minimal arguments' do
        let(:title) { '/srv/test' }

        let(:pre_condition) { 'class {"nfs": client_enabled => true, nfs_v4_client => true }' }

        let(:params) { { server: '1.2.3.4' } }

        it { is_expected.to contain_nfs__functions__mkdir('/srv/test') }
        it { is_expected.to contain_mount('shared /test by 1.2.3.4 on /srv/test') }

        it do
          is_expected.to contain_mount('shared /test by 1.2.3.4 on /srv/test').that_requires(
            [
              'Nfs::Functions::Mkdir[/srv/test]',
            ] + client_packages
          )
        end
      end

      context 'when nfs_v4 => true, non-default mountpoints' do
        let(:title) { '/opt/sample' }

        let(:pre_condition) { 'class {"nfs": client_enabled => true, nfs_v4_client => true }' }

        let(:params) { { share: 'test', server: '1.2.3.4' } }

        it { is_expected.to contain_nfs__functions__mkdir('/opt/sample') }

        it do
          is_expected.to contain_mount('shared /test by 1.2.3.4 on /opt/sample').that_requires(
            [
              'Nfs::Functions::Mkdir[/opt/sample]',
            ] + client_packages
          )
        end
      end

      context 'when nfs_v4 => true, non-default mountpoints, not managing packages' do
        let(:title) { '/opt/sample' }

        let(:pre_condition) { 'class {"nfs": client_enabled => true, nfs_v4_client => true, manage_packages => false }' }

        let(:params) { { share: 'test', server: '1.2.3.4' } }

        it { is_expected.to contain_nfs__functions__mkdir('/opt/sample') }

        it do
          is_expected.to contain_mount('shared /test by 1.2.3.4 on /opt/sample').that_requires(
            [
              'Nfs::Functions::Mkdir[/opt/sample]',
            ]
          )
        end
      end
    end
  end
end
