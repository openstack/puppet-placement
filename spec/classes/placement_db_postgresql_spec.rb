require 'spec_helper'

describe 'placement::db::postgresql' do
  let :pre_condition do
    'include postgresql::server'
  end

  let :params do
    {
      :password => 'placementpass'
    }
  end

  shared_examples 'placement::db::postgresql' do
    context 'with only required parameters' do
      it { is_expected.to contain_class('placement::deps') }

      it { is_expected.to contain_openstacklib__db__postgresql('placement').with(
        :user       => 'placement',
        :password   => 'placementpass',
        :dbname     => 'placement',
        :encoding   => nil,
        :privileges => 'ALL',
      )}
    end
  end

  on_supported_os({
    :supported_os => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge!(OSDefaults.get_facts({
          # puppet-postgresql requires the service_provider fact provided by
          # puppetlabs-postgresql.
          :service_provider => 'systemd'
        }))
      end

      it_behaves_like 'placement::db::postgresql'
    end
  end
end
