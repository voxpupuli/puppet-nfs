# frozen_string_literal: true

require 'spec_helper'

describe 'nfs::server::export', type: 'define' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts
      end

      context 'when nvs_v4 => false' do
        let(:title) { '/srv/test' }

        let(:pre_condition) { 'class {"nfs": server_enabled => true,}' }

        let(:params) { { clients: '1.2.3.4(rw)' } }

        it do
          is_expected.to contain_nfs__functions__create_export('/srv/test').with(
            'ensure'           => 'mounted',
            'clients'          => '1.2.3.4(rw)',
            'manage_directory' => true,
          )
        end

        it { is_expected.to contain_nfs__functions__create_export('/srv/test').with('ensure' => 'mounted', 'clients' => '1.2.3.4(rw)') }

        it do
          expect(exported_resources).to contain_nfs__client__mount('/srv/test')
        end
      end

      context 'when nvs_v4 => false, nfs::storeconfigs_enabled => false' do
        let(:title) { '/srv/test' }

        let(:pre_condition) { 'class {"nfs": server_enabled => true, nfs_v4 => false, storeconfigs_enabled => false}' }

        let(:params) { { clients: '1.2.3.4(rw)', manage_directory: false } }

        it { is_expected.not_to contain_file('/srv/test') }

        it { is_expected.to contain_nfs__functions__create_export('/srv/test').with('ensure' => 'mounted', 'clients' => '1.2.3.4(rw)') }

        it { expect(exported_resources).not_to contain_nfs__client__mount('/srv/test') }
      end

      context 'when nfs_v4 => true' do
        let(:title) { '/srv/test' }
        let(:pre_condition) { 'class {"nfs": server_enabled => true, nfs_v4 => true}' }

        let(:params) { { clients: '1.2.3.4(rw)', bind: 'sbind' } }

        if facts[:os]['family'] == 'FreeBSD'
          it { is_expected.not_to contain_nfs__functions__nfsv4_bindmount('/srv/test') }
          it { is_expected.to contain_nfs__functions__create_export('/srv/test').with('ensure' => 'mounted', 'clients' => '1.2.3.4(rw)') }
          it { expect(exported_resources).to contain_nfs__client__mount('/srv/test') }
        else
          it { is_expected.to contain_nfs__functions__nfsv4_bindmount('/srv/test').with('ensure' => 'mounted', 'v4_export_name' => 'test', 'bind' => 'sbind') }
          it { is_expected.to contain_nfs__functions__create_export('/export/test').with('ensure' => 'mounted', 'clients' => '1.2.3.4(rw)') }
          it { expect(exported_resources).to contain_nfs__client__mount('test') }
        end
      end

      if facts[:os]['family'] == 'FreeBSD'
        context 'when nfs_v4 => true, clients as array (FreeBSD multi-line export)' do
          let(:title) { '/srv/test' }
          let(:pre_condition) { 'class {"nfs": server_enabled => true, nfs_v4 => true}' }
          let(:params) do
            {
              clients: [
                '-maproot=root:wheel -network 192.0.2.0/24',
                '-maproot=root:wheel -network 198.51.100.10/32',
              ],
            }
          end

          it do
            is_expected.to contain_concat__fragment('/srv/test').with_content(
              "/srv/test -maproot=root:wheel -network 192.0.2.0/24\n" \
              "/srv/test -maproot=root:wheel -network 198.51.100.10/32\n",
            )
          end
        end
      end

      context 'when nfs_v4 => true, nfs::storeconfigs_enabled => false' do
        let(:title) { '/srv/test' }
        let(:pre_condition) { 'class {"nfs": server_enabled => true, nfs_v4 => true, storeconfigs_enabled => false}' }
        let(:params) { { clients: '1.2.3.4(rw)', bind: 'sbind' } }

        if facts[:os]['family'] == 'FreeBSD'
          it { is_expected.not_to contain_nfs__functions__nfsv4_bindmount('/srv/test') }
          it { is_expected.to contain_nfs__functions__create_export('/srv/test').with('ensure' => 'mounted', 'clients' => '1.2.3.4(rw)') }
          it { expect(exported_resources).not_to contain_nfs__client__mount('/srv/test') }
        else
          it { is_expected.to contain_nfs__functions__nfsv4_bindmount('/srv/test').with('ensure' => 'mounted', 'v4_export_name' => 'test', 'bind' => 'sbind') }
          it { is_expected.to contain_nfs__functions__create_export('/export/test').with('ensure' => 'mounted', 'clients' => '1.2.3.4(rw)') }
          it { expect(exported_resources).not_to contain_nfs__client__mount('test') }
        end
      end

      context 'when nfs_v4 => true, nfs::nfsv4_bindmount_enable => true' do
        let(:title) { '/srv/test' }
        let(:pre_condition) { 'class {"nfs": server_enabled => true, nfs_v4 => true, nfsv4_bindmount_enable => true}' }
        let(:params) { { clients: '1.2.3.4(rw)', bind: 'sbind' } }

        if facts[:os]['family'] == 'FreeBSD'
          it { is_expected.not_to contain_nfs__functions__nfsv4_bindmount('/srv/test') }
          it { is_expected.to contain_nfs__functions__create_export('/srv/test').with('ensure' => 'mounted', 'clients' => '1.2.3.4(rw)') }
          it { expect(exported_resources).to contain_nfs__client__mount('/srv/test') }
        else
          it { is_expected.to contain_nfs__functions__nfsv4_bindmount('/srv/test').with('ensure' => 'mounted', 'v4_export_name' => 'test', 'bind' => 'sbind') }
          it { is_expected.to contain_nfs__functions__create_export('/export/test').with('ensure' => 'mounted', 'clients' => '1.2.3.4(rw)') }
          it { expect(exported_resources).to contain_nfs__client__mount('test') }
        end
      end

      context 'when nfs_v4 => true, nfs::nfsv4_bindmount_enable => false' do
        let(:title) { '/srv/test' }
        let(:pre_condition) { 'class {"nfs": server_enabled => true, nfs_v4 => true, nfsv4_bindmount_enable => false}' }
        let(:params) { { clients: '1.2.3.4(rw)', bind: 'sbind' } }

        it { is_expected.not_to contain_nfs__functions__nfsv4_bindmount('/srv/test').with('ensure' => 'mounted', 'v4_export_name' => 'test', 'bind' => 'sbind') }

        it { is_expected.to contain_nfs__functions__create_export('/srv/test').with('ensure' => 'mounted', 'clients' => '1.2.3.4(rw)') }

        it { expect(exported_resources).to contain_nfs__client__mount('/srv/test') }
      end
    end
  end
end
