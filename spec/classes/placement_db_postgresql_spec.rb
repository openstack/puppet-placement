require 'spec_helper'

describe 'placement::db::postgresql' do

  let :pre_condition do
    'include postgresql::server'
  end

  let :required_params do
    { :password => 'pw' }
  end

  shared_examples_for 'placement-db-postgresql' do
    context 'with only required parameters' do
      let :params do
        required_params
      end

      it { is_expected.to contain_postgresql__server__db('placement').with(
        :user     => 'placement',
        :password => 'md51c1dd6fb4863b046eecc6a6b91f53f7f'
      )}
    end
  end

  on_supported_os({
    :supported_os => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge!(OSDefaults.get_facts({ :concat_basedir => '/var/lib/puppet/concat' }))
      end

      it_behaves_like 'placement-db-postgresql'
    end
  end
end
