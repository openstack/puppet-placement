require 'spec_helper'

describe 'placement::api' do
  shared_examples 'placement::api' do
    let :params do
      { :api_service_name => 'httpd'}
    end

    let :pre_condition do
      <<-EOS
      include apache
      include placement::wsgi::apache
EOS
    end

    context 'with defaults' do
      it { should contain_class('placement::deps') }
      it { should contain_class('placement::policy') }
      it { should contain_placement__generic_service('api').with(
        :service_name   => nil,
        :package_name   => platform_params[:package_name],
        :manage_service => true,
        :enabled        => true,
        :ensure_package => 'present',
      ) }

      it { should contain_oslo__middleware('placement_config').with(
        :enable_proxy_headers_parsing => '<SERVICE DEFAULT>',
      ) }
    end

    context 'with ensure_package parameter provided' do
      before :each do
        params.merge!({ :ensure_package => 'latest' })
      end

      it { should contain_placement__generic_service('api').with(
        :ensure_package => 'latest',
      ) }
    end

    context 'with manage_service parameter provided' do
      before :each do
        params.merge!({ :manage_service => false })
      end

      it { should contain_placement__generic_service('api').with(
        :manage_service => false,
      ) }
    end

    context 'with sync_db parameter provided' do
      before :each do
        params.merge!({ :sync_db => true })
      end

      it { should contain_class('placement::db::sync') }
    end

    context 'with enable_proxy_headers_parsing set' do
      before :each do
        params.merge!({ :enable_proxy_headers_parsing => true })
      end

      it { should contain_oslo__middleware('placement_config').with(
        :enable_proxy_headers_parsing => true,
      ) }
    end
  end

  shared_examples 'placement::api in Debian' do
    context 'with defaults' do
      it { should contain_class('placement::deps') }
      it { should contain_class('placement::policy') }
      it { should contain_placement__generic_service('api').with(
        :service_name   => platform_params[:service_name],
        :package_name   => platform_params[:package_name],
        :manage_service => true,
        :enabled        => true,
        :ensure_package => 'present',
      ) }
    end
  end

  on_supported_os({
    :supported_os   => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge(OSDefaults.get_facts({
          :os_workers     => 8,
          :fqdn           => 'some.host.tld',
          :concat_basedir => '/var/lib/puppet/concat',
        }))
      end

      let(:platform_params) do
        case facts[:os]['family']
        when 'Debian'
          if facts[:os]['name'] == 'Debian'
            { :service_name => 'placement-api',
              :package_name => 'placement-api'}
          else
            { :service_name => nil,
              :package_name => 'placement-api'}
          end
        when 'RedHat'
          { :service_name => nil,
            :package_name => 'openstack-placement-api'}
        end
      end

      it_behaves_like 'placement::api'
      if facts[:os]['name'] == 'Debian'
        it_behaves_like 'placement::api in Debian'
      end
    end
  end
end
