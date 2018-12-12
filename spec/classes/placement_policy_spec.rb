require 'spec_helper'

describe 'placement::policy' do
  shared_examples 'placement::policy' do
    let :params do
      {
        :policy_path => '/etc/placement/policy.json',
        :policies    => {
          'context_is_admin' => {
            'key'   => 'context_is_admin',
            'value' => 'foo:bar'
          }
        }
      }
    end

    it { is_expected.to contain_openstacklib__policy__base('context_is_admin').with(
      :key        => 'context_is_admin',
      :value      => 'foo:bar',
      :file_user  => 'root',
      :file_group => 'placement',
    )}
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
