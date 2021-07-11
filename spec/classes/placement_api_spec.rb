require 'spec_helper'

describe 'placement::api' do
  shared_examples 'placement::api' do

    context 'with only required params' do
      let :params do
        {}
      end

      it { should contain_class('placement::deps') }
      it { should contain_class('placement::policy') }
      it { should contain_placement__generic_service('api').with(
        :service_name   => platform_params[:service_name],
        :package_name   => platform_params[:package_name],
        :manage_service => true,
        :enabled        => true,
        :ensure_package => 'present',
      ) }
    end

    context 'with package_ensure parameter provided' do
      let :params do
        { :package_ensure => false }
      end

      it { should contain_placement__generic_service('api').with(
        :ensure_package => false,
      ) }
    end

    context 'with manage_service parameter provided' do
      let :params do
        { :manage_service => false }
      end

      it { should contain_placement__generic_service('api').with(
        :manage_service => false,
      ) }
    end

    context 'with sync_db parameter provided' do
      let :params do
        { :sync_db => true }
      end

      it { should contain_class('placement::db::sync') }
    end
  end

  on_supported_os({
    :supported_os   => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge(OSDefaults.get_facts({
          :os_workers     => 8,
          :fqdn           => 'some.host.tld',
          :concat_basedir => '/var/lib/puppet/concat',
        }))
      end

      let(:platform_params) do
        case facts[:osfamily]
        when 'Debian'
          if facts[:os_package_type] == 'debian'
            { :service_name => 'placement-api',
              :package_name => 'placement-api'}
          else
            { :service_name => false,
              :package_name => 'placement-api'}
          end
        when 'RedHat'
          { :service_name => false,
            :package_name => 'openstack-placement-api'}
        end
      end

      it_behaves_like 'placement::api'
    end
  end
end
