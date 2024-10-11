#
# Unit tests for placement::keystone::auth
#

require 'spec_helper'

describe 'placement::keystone::auth' do
  shared_examples_for 'placement::keystone::auth' do
    context 'with default class parameters' do
      let :params do
        { :password => 'placement_password' }
      end

      it { is_expected.to contain_keystone__resource__service_identity('placement').with(
        :configure_user      => true,
        :configure_user_role => true,
        :configure_endpoint  => true,
        :configure_service   => true,
        :service_name        => 'placement',
        :service_type        => 'placement',
        :service_description => 'OpenStack Placement Service',
        :region              => 'RegionOne',
        :auth_name           => 'placement',
        :password            => 'placement_password',
        :email               => 'placement@localhost',
        :tenant              => 'services',
        :roles               => ['admin'],
        :system_scope        => 'all',
        :system_roles        => [],
        :public_url          => 'http://127.0.0.1:8778',
        :internal_url        => 'http://127.0.0.1:8778',
        :admin_url           => 'http://127.0.0.1:8778',
      ) }
    end

    context 'when overriding parameters' do
      let :params do
        { :password            => 'placement_password',
          :auth_name           => 'alt_placement',
          :email               => 'alt_placement@alt_localhost',
          :tenant              => 'alt_service',
          :roles               => ['admin', 'service'],
          :system_scope        => 'alt_all',
          :system_roles        => ['admin', 'member', 'reader'],
          :configure_endpoint  => false,
          :configure_user      => false,
          :configure_user_role => false,
          :configure_service   => false,
          :service_description => 'Alternative OpenStack Placement Service',
          :service_name        => 'alt_service',
          :service_type        => 'alt_placement',
          :region              => 'RegionTwo',
          :public_url          => 'https://10.10.10.10:80',
          :internal_url        => 'http://10.10.10.11:81',
          :admin_url           => 'http://10.10.10.12:81' }
      end

      it { is_expected.to contain_keystone__resource__service_identity('placement').with(
        :configure_user      => false,
        :configure_user_role => false,
        :configure_endpoint  => false,
        :configure_service   => false,
        :service_name        => 'alt_service',
        :service_type        => 'alt_placement',
        :service_description => 'Alternative OpenStack Placement Service',
        :region              => 'RegionTwo',
        :auth_name           => 'alt_placement',
        :password            => 'placement_password',
        :email               => 'alt_placement@alt_localhost',
        :tenant              => 'alt_service',
        :roles               => ['admin', 'service'],
        :system_scope        => 'alt_all',
        :system_roles        => ['admin', 'member', 'reader'],
        :public_url          => 'https://10.10.10.10:80',
        :internal_url        => 'http://10.10.10.11:81',
        :admin_url           => 'http://10.10.10.12:81',
      ) }
    end
  end

  on_supported_os({
    :supported_os => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge!(OSDefaults.get_facts())
      end

      it_behaves_like 'placement::keystone::auth'
    end
  end
end
