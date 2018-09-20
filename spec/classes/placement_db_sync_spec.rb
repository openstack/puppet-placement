require 'spec_helper'

describe 'placement::db::sync' do

  shared_examples_for 'placement-manage-db-sync' do

    it 'runs placement-manage-db-sync' do
      is_expected.to contain_exec('placement-manage-db-sync').with(
        :command     => 'placement-manage db sync',
        :path        => [ '/bin', '/usr/bin', '/usr/local/bin'],
        :refreshonly => 'true',
        :try_sleep   => 5,
        :tries       => 10,
        :user        => 'placement',
        :logoutput   => 'on_failure',
        :subscribe   => ['Anchor[placement::install::end]',
                         'Anchor[placement::config::end]',
                         'Anchor[placement::db::end]',
                         'Anchor[placement::dbsync::begin]'],
        :notify      => 'Anchor[placement::dbsync::end]',
        :tag         => ['placement-exec', 'openstack-db']
      )
    end

  end

  on_supported_os({
    :supported_os   => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge(OSDefaults.get_facts({
          :os_workers     => 8,
          :concat_basedir => '/var/lib/puppet/concat'
        }))
      end

      it_configures 'placement-manage-db-sync'
    end
  end

end
