require 'spec_helper'

describe 'placement::db' do
  shared_examples 'placement::db' do
    context 'with default parameters' do
      it { should contain_placement_config('placement_database/connection').with_value('sqlite:////var/lib/placement/placement.sqlite') }
    end

    context 'with specific parameters' do
      let :params do
        {
          :database_connection => 'mysql+pymysql://placement:placement@localhost/placement',
        }
      end

      it { should contain_placement_config('placement_database/connection').with_value('mysql+pymysql://placement:placement@localhost/placement') }
    end

    context 'with incorrect database_connection string' do
      let :params do
        {
          :database_connection => 'foodb://placement:placement@localhost/placement',
        }
      end

      it { should raise_error(Puppet::Error, /validate_re/) }
    end

    context 'with incorrect pymysql database_connection string' do
      let :params do
        {
          :database_connection => 'foo+pymysql://placement:placement@localhost/placement',
        }
      end

      it { should raise_error(Puppet::Error, /validate_re/) }
    end

  end

  shared_examples 'placement::db on Debian' do
    context 'using pymysql driver' do
      let :params do
        {
          :database_connection => 'mysql+pymysql://placement:placement@localhost/placement',
        }
      end
    end
  end

  shared_examples_for 'placement::db on RedHat' do
    context 'using pymysql driver' do
      let :params do
        {
          :database_connection => 'mysql+pymysql://placement:placement@localhost/placement',
        }
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

      it_behaves_like 'placement::db'
      it_behaves_like "placement::db on #{facts[:osfamily]}"
    end
  end
end
