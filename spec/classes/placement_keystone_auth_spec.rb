#
# Unit tests for placement::keystone::auth
#

require 'spec_helper'

describe 'placement::keystone::auth' do
  shared_examples_for 'placement-keystone-auth' do
    context 'with default class parameters' do
      let :params do
        { :password => 'placement_password',
          :tenant   => 'foobar' }
      end

      it { is_expected.to contain_keystone_user('placement').with(
        :ensure   => 'present',
        :password => 'placement_password',
      ) }

      it { is_expected.to contain_keystone_user_role('placement@foobar').with(
        :ensure  => 'present',
        :roles   => ['admin']
      )}

      it { is_expected.to contain_keystone_service('placement::placement').with(
        :ensure      => 'present',
        :description => 'Placement Service'
      ) }

      it { is_expected.to contain_keystone_endpoint('RegionOne/placement::placement').with(
        :ensure       => 'present',
        :public_url   => 'http://127.0.0.1/placement',
        :admin_url    => 'http://127.0.0.1/placement',
        :internal_url => 'http://127.0.0.1/placement',
      ) }
    end

    context 'when overriding URL parameters' do
      let :params do
        { :password     => 'placement_password',
          :public_url   => 'https://10.10.10.10:80',
          :internal_url => 'http://10.10.10.11:81',
          :admin_url    => 'http://10.10.10.12:81', }
      end

      it { is_expected.to contain_keystone_endpoint('RegionOne/placement::placement').with(
        :ensure       => 'present',
        :public_url   => 'https://10.10.10.10:80',
        :internal_url => 'http://10.10.10.11:81',
        :admin_url    => 'http://10.10.10.12:81',
      ) }
    end

    context 'when overriding auth name' do
      let :params do
        { :password => 'foo',
          :auth_name => 'placementy' }
      end

      it { is_expected.to contain_keystone_user('placementy') }
      it { is_expected.to contain_keystone_user_role('placementy@services') }
      it { is_expected.to contain_keystone_service('placement::placement') }
      it { is_expected.to contain_keystone_endpoint('RegionOne/placement::placement') }
    end

    context 'when overriding service name' do
      let :params do
        { :service_name => 'placement_service',
          :auth_name    => 'placement',
          :password     => 'placement_password' }
      end

      it { is_expected.to contain_keystone_user('placement') }
      it { is_expected.to contain_keystone_user_role('placement@services') }
      it { is_expected.to contain_keystone_service('placement_service::placement') }
      it { is_expected.to contain_keystone_endpoint('RegionOne/placement_service::placement') }
    end

    context 'when disabling user configuration' do

      let :params do
        {
          :password       => 'placement_password',
          :configure_user => false
        }
      end

      it { is_expected.not_to contain_keystone_user('placement') }
      it { is_expected.to contain_keystone_user_role('placement@services') }
      it { is_expected.to contain_keystone_service('placement::placement').with(
        :ensure      => 'present',
        :description => 'Placement Service'
      ) }

    end

    context 'when disabling user and user role configuration' do

      let :params do
        {
          :password            => 'placement_password',
          :configure_user      => false,
          :configure_user_role => false
        }
      end

      it { is_expected.not_to contain_keystone_user('placement') }
      it { is_expected.not_to contain_keystone_user_role('placement@services') }
      it { is_expected.to contain_keystone_service('placement::placement').with(
        :ensure      => 'present',
        :description => 'Placement Service'
      ) }

    end

    context 'when using ensure absent' do

      let :params do
        {
          :password => 'placement_password',
          :ensure   => 'absent'
        }
      end

      it { is_expected.to contain_keystone__resource__service_identity('placement').with_ensure('absent') }

    end
  end

  on_supported_os({
    :supported_os => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge!(OSDefaults.get_facts())
      end

      it_behaves_like 'placement-keystone-auth'
    end
  end
end
