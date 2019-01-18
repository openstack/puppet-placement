require 'spec_helper'

describe 'placement::db' do
  shared_examples 'placement::db' do
    context 'with default parameters' do
      it {
        should contain_class('placement::deps')
        should contain_class('placement::config')
      }

      it { should contain_oslo__db('placement_config').with(
        :config_group       => 'placement_database',
        :sqlite_synchronous => '<SERVICE DEFAULT>',
        :connection         => 'sqlite:////var/lib/placement/placement.sqlite',
        :slave_connection   => '<SERVICE DEFAULT>',
        :mysql_sql_mode     => '<SERVICE DEFAULT>',
        :max_pool_size      => '<SERVICE DEFAULT>',
        :max_retries        => '<SERVICE DEFAULT>',
        :retry_interval     => '<SERVICE DEFAULT>',
        :max_overflow       => '<SERVICE DEFAULT>',
        :connection_debug   => '<SERVICE DEFAULT>',
        :connection_trace   => '<SERVICE DEFAULT>',
        :pool_timeout       => '<SERVICE DEFAULT>',
      )}
    end

    context 'with specific parameters' do
      let :params do
        {
          :database_sqlite_synchronous => true,
          :database_connection         => 'mysql+pymysql://placement:placement@localhost/placement',
          :database_slave_connection   => 'mysql+pymysql://placement2:placement2@localhost/placement2',
          :database_mysql_sql_mode     => 'strict_mode',
          :database_max_pool_size      => '8',
          :database_max_retries        => '4',
          :database_retry_interval     => '-1',
          :database_max_overflow       => '2',
          :database_connection_debug   => '100',
          :database_connection_trace   => true,
          :database_pool_timeout       => '10',
        }
      end

      it {
        should contain_class('placement::deps')
        should contain_class('placement::config')
      }

      it { should contain_oslo__db('placement_config').with(
        :config_group       => 'placement_database',
        :sqlite_synchronous => true,
        :connection         => 'mysql+pymysql://placement:placement@localhost/placement',
        :slave_connection   => 'mysql+pymysql://placement2:placement2@localhost/placement2',
        :mysql_sql_mode     => 'strict_mode',
        :max_pool_size      => '8',
        :max_retries        => '4',
        :retry_interval     => '-1',
        :max_overflow       => '2',
        :connection_debug   => '100',
        :connection_trace   => true,
        :pool_timeout       => '10',
      )}
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
    end
  end
end
