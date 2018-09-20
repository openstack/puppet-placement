require 'spec_helper'

describe 'placement::db' do
  shared_examples 'placement::db' do
    context 'with default parameters' do
      it 'configures placement_database' do
        is_expected.to contain_placement_config('placement_database/connection').with_value('sqlite:////var/lib/placement/placement.sqlite')
      end
    end

    context 'with specific parameters' do
      let :params do
        { :database_connection     => 'mysql+pymysql://placement:placement@localhost/placement',
        }
      end
      it 'configures placement_database' do
        is_expected.to contain_placement_config('placement_database/connection').with_value('mysql+pymysql://placement:placement@localhost/placement')
      end
    end

    context 'with incorrect database_connection string' do
      let :params do
        { :database_connection => 'foodb://placement:placement@localhost/placement', }
      end

      it_raises 'a Puppet::Error', /validate_re/
    end

    context 'with incorrect pymysql database_connection string' do
      let :params do
        { :database_connection => 'foo+pymysql://placement:placement@localhost/placement', }
      end

      it_raises 'a Puppet::Error', /validate_re/
    end

  end

  shared_examples_for 'placement::db on Debian' do
    context 'using pymysql driver' do
      let :params do
        { :database_connection => 'mysql+pymysql://placement:placement@localhost/placement', }
      end
    end
  end

  shared_examples_for 'placement::db on RedHat' do
    context 'using pymysql driver' do
      let :params do
        { :database_connection => 'mysql+pymysql://placement:placement@localhost/placement', }
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

      it_configures 'placement::db'
      it_configures "placement::db on #{facts[:osfamily]}"
    end
  end
end
