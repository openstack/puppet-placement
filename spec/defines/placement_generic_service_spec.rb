require 'spec_helper'

describe 'placement::generic_service' do
  shared_examples 'placement::generic_service' do
    let :pre_condition do
      'include placement'
    end

    let :params do
      {
        :package_name => 'foo',
        :service_name => 'food'
      }
    end

    let :title do
      'foo'
    end

    it { should contain_service('placement-foo').with(
      :name   => 'food',
      :ensure => 'running',
      :enable => true,
    )}

    it { should contain_service('placement-foo').that_subscribes_to(
      'Anchor[placement::service::begin]',
    )}
    it { should contain_service('placement-foo').that_notifies(
      'Anchor[placement::service::end]',
    )}
  end

  on_supported_os({
    :supported_os => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge!(OSDefaults.get_facts())
      end

      it_behaves_like 'placement::generic_service'
    end
  end
end
