require 'spec_helper'

describe 'placement::config' do
  let :default_params do
    {
      :auth_type           => 'password',
      :project_name        => 'services',
      :project_domain_name => 'Default',
      :region_name      => 'RegionOne',
      :username            => 'placement',
      :user_domain_name    => 'Default',
      :auth_url            => 'http://127.0.0.1:5000/v3',
      }
  end

  let :params do
    {
      :password           => 's3cr3t',
      :placement_config   => {
        'DEFAULT/foo' => { 'value'  => 'fooValue' },
        'DEFAULT/bar' => { 'value'  => 'barValue' },
        'DEFAULT/baz' => { 'ensure' => 'absent' }
      }
    }
  end

  shared_examples 'placement::config' do
    context 'with required parameters' do
      it { should contain_class('placement::deps') }

      it {
        should contain_placement_config('placement/password').with_value(params[:password]).with_secret(true)
        should contain_placement_config('placement/auth_type').with_value(default_params[:auth_type])
        should contain_placement_config('placement/project_name').with_value(default_params[:project_name])
        should contain_placement_config('placement/project_domain_name').with_value(default_params[:project_domain_name])
        should contain_placement_config('placement/region_name').with_value(default_params[:region_name])
        should contain_placement_config('placement/valid_interfaces').with_value('<SERVICE DEFAULT>')
        should contain_placement_config('placement/username').with_value(default_params[:username])
        should contain_placement_config('placement/user_domain_name').with_value(default_params[:user_domain_name])
        should contain_placement_config('placement/auth_url').with_value(default_params[:auth_url])
        should contain_placement_config('DEFAULT/foo').with_value('fooValue')
        should contain_placement_config('DEFAULT/bar').with_value('barValue')
        should contain_placement_config('DEFAULT/baz').with_ensure('absent')
      }
    end

    context 'when overriding class parameters' do
      before do
        params.merge!(
          :auth_type           => 'password',
          :project_name        => 'service',
          :project_domain_name => 'default',
          :region_name         => 'RegionTwo',
          :valid_interfaces    => 'internal',
          :username            => 'placement2',
          :user_domain_name    => 'default',
          :auth_url            => 'https://127.0.0.1:5000/v3',
        )
      end

      it {
        should contain_placement_config('placement/password').with_value(params[:password]).with_secret(true)
        should contain_placement_config('placement/auth_type').with_value(params[:auth_type])
        should contain_placement_config('placement/project_name').with_value(params[:project_name])
        should contain_placement_config('placement/project_domain_name').with_value(params[:project_domain_name])
        should contain_placement_config('placement/region_name').with_value(params[:region_name])
        should contain_placement_config('placement/valid_interfaces').with_value(params[:valid_interfaces])
        should contain_placement_config('placement/username').with_value(params[:username])
        should contain_placement_config('placement/user_domain_name').with_value(params[:user_domain_name])
        should contain_placement_config('placement/auth_url').with_value(params[:auth_url])
      }
    end

  end

  on_supported_os({
    :supported_os => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge!(OSDefaults.get_facts())
      end

      it_behaves_like 'placement::config'
    end
  end
end
