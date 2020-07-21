require 'spec_helper'

describe 'placement::client' do

  shared_examples_for 'placement client' do

    it { is_expected.to contain_class('placement::deps') }
    it { is_expected.to contain_class('placement::params') }

    it 'installs placement client package' do
      is_expected.to contain_package('python-osc-placement').with(
        :ensure => 'present',
        :name   => platform_params[:client_package_name],
        :tag    => ['openstack', 'placement-support-package']
      )
    end

    it { is_expected.to contain_class('openstacklib::openstackclient') }
  end

  on_supported_os({
    :supported_os => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge!(OSDefaults.get_facts())
      end

      let(:platform_params) do
        case facts[:osfamily]
        when 'Debian'
          { :client_package_name => 'python3-osc-placement' }
        when 'RedHat'
          if facts[:operatingsystem] == 'Fedora'
            { :client_package_name => 'python3-osc-placement' }
          else
            if facts[:operatingsystemmajrelease] > '7'
              { :client_package_name => 'python3-osc-placement' }
            else
              { :client_package_name => 'python-osc-placement' }
            end
          end
        end
      end

      it_behaves_like 'placement client'
    end
  end

end

