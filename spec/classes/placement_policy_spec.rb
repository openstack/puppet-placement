require 'spec_helper'

describe 'placement::policy' do
  shared_examples 'placement::policy' do

    context 'setup policy with parameters' do
      let :params do
        {
          :enforce_scope        => false,
          :enforce_new_defaults => false,
          :policy_path          => '/etc/placement/policy.yaml',
          :policy_dirs          => '/etc/placement/policy.d',
          :policies             => {
            'context_is_admin' => {
              'key'   => 'context_is_admin',
              'value' => 'foo:bar'
            }
          }
        }
      end

      it 'set up the policies' do
        is_expected.to contain_openstacklib__policy('/etc/placement/policy.yaml').with(
          :policies     => {
            'context_is_admin' => {
              'key'   => 'context_is_admin',
              'value' => 'foo:bar'
            }
          },
          :policy_path  => '/etc/placement/policy.yaml',
          :file_user    => 'root',
          :file_group   => 'placement',
          :file_format  => 'yaml',
          :purge_config => false,
          :tag          => 'placement',
        )
        is_expected.to contain_oslo__policy('placement_config').with(
          :enforce_scope        => false,
          :enforce_new_defaults => false,
          :policy_file          => '/etc/placement/policy.yaml',
          :policy_dirs          => '/etc/placement/policy.d',
        )
      end
    end

    context 'with empty policies and purge_config enabled' do
      let :params do
        {
          :enforce_scope        => false,
          :enforce_new_defaults => false,
          :policy_path          => '/etc/placement/policy.yaml',
          :policies             => {},
          :purge_config         => true,
        }
      end

      it 'set up the policies' do
        is_expected.to contain_openstacklib__policy('/etc/placement/policy.yaml').with(
          :policies     => {},
          :policy_path  => '/etc/placement/policy.yaml',
          :file_user    => 'root',
          :file_group   => 'placement',
          :file_format  => 'yaml',
          :purge_config => true,
          :tag          => 'placement',
        )
        is_expected.to contain_oslo__policy('placement_config').with(
          :enforce_scope        => false,
          :enforce_new_defaults => false,
          :policy_file          => '/etc/placement/policy.yaml',
        )
      end
    end
  end

  on_supported_os({
    :supported_os => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge!(OSDefaults.get_facts())
      end

      it_behaves_like 'placement::policy'
    end
  end
end
