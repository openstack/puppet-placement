require 'spec_helper'

describe 'placement::db::mysql' do
  let :pre_condition do
    'include mysql::server'
  end

  let :params do
    {
      :password => 'placementpass',
    }
  end

  shared_examples 'placement::db::mysql' do
    it { should contain_class('placement::deps') }

    context 'with only required params' do
      it { should contain_openstacklib__db__mysql('placement').with(
        :user     => 'placement',
        :password => 'placementpass',
        :dbname   => 'placement',
        :host     => '127.0.0.1',
        :charset  => 'utf8',
        :collate  => 'utf8_general_ci',
      )}
    end

    context 'overriding allowed_hosts param to array' do
      before do
        params.merge!( :allowed_hosts => ['127.0.0.1', '%'] )
      end

      it { should contain_openstacklib__db__mysql('placement').with(
        :user          => 'placement',
        :password      => 'placementpass',
        :dbname        => 'placement',
        :host          => '127.0.0.1',
        :charset       => 'utf8',
        :collate       => 'utf8_general_ci',
        :allowed_hosts => ['127.0.0.1','%']
      )}
    end

    describe 'overriding allowed_hosts param to string' do
      before do
        params.merge!( :allowed_hosts => '192.168.1.1' )
      end

      it { should contain_openstacklib__db__mysql('placement').with(
        :user          => 'placement',
        :password      => 'placementpass',
        :dbname        => 'placement',
        :host          => '127.0.0.1',
        :charset       => 'utf8',
        :collate       => 'utf8_general_ci',
        :allowed_hosts => '192.168.1.1'
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

      it_behaves_like 'placement::db::mysql'
    end
  end
end
