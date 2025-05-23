require 'spec_helper'

describe 'placement' do
  shared_examples 'placement' do
    context 'with default parameters' do
      it {
        should contain_class('placement::deps')
        should contain_class('placement::db::sync')
      }

      it { should contain_package('python-placement').with(
        :ensure => 'present',
        :name   => platform_params[:python_package_name],
        :tag    => ['openstack', 'placement-package'],
      )}

      it { should contain_package('placement-common').with(
        :ensure  => 'present',
        :name    => platform_params[:common_package_name],
        :require => 'Package[python-placement]',
        :tag     => ['openstack', 'placement-package'],
      )}

      it { should contain_placement_config('placement/randomize_allocation_candidates').with_value('<SERVICE DEFAULT>') }
      it { should contain_placement_config('placement/allocation_conflict_retry_count').with_value('<SERVICE DEFAULT>') }
      it { should contain_placement_config('placement/allocation_candidates_generation_strategy').with_value('<SERVICE DEFAULT>') }
    end

    context 'with overridden parameters' do
      let :params do
        {
          :ensure_package                            => 'absent',
          :sync_db                                   => false,
          :state_path                                => '/var/lib/placement',
          :randomize_allocation_candidates           => true,
          :allocation_conflict_retry_count           => 10,
          :allocation_candidates_generation_strategy => 'depth-first',
        }
      end

      it {
        should contain_class('placement::deps')
        should_not contain_class('placement::db::sync')
      }

      it { should contain_package('python-placement').with(
        :ensure => 'absent',
        :name   => platform_params[:python_package_name],
        :tag    => ['openstack', 'placement-package'],
      )}

      it { should contain_package('placement-common').with(
        :ensure  => 'absent',
        :name    => platform_params[:common_package_name],
        :require => 'Package[python-placement]',
        :tag     => ['openstack', 'placement-package'],
      )}

      it { should contain_placement_config('DEFAULT/state_path').with_value('/var/lib/placement') }
      it { should contain_placement_config('placement/randomize_allocation_candidates').with_value(true) }
      it { should contain_placement_config('placement/allocation_conflict_retry_count').with_value(10) }
      it { should contain_placement_config('placement/allocation_candidates_generation_strategy').with_value('depth-first') }
    end
  end

  on_supported_os({
    :supported_os => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge!(OSDefaults.get_facts())
      end

      let (:platform_params) do
        case facts[:os]['family']
        when 'Debian'
          {
            :python_package_name => 'python3-placement',
            :common_package_name => 'placement-common',
          }
        when 'RedHat'
          {
            :python_package_name => 'python3-placement',
            :common_package_name => 'openstack-placement-common',
          }
        end
      end

      it_behaves_like 'placement'
    end
  end
end
