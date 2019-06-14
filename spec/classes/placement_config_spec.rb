require 'spec_helper'

describe 'placement::config' do
  let :default_params do
    {
      :placement_config => {},
    }
  end

  let :params do
    {}
  end

  shared_examples 'placement::config' do
    context 'with default parameters' do
      it { should contain_class('placement::deps') }
    end

    context 'when setting placement_config' do
      before do
        params.merge!(
          :placement_config => {
            'DEFAULT/foo' => { 'value'  => 'fooValue' },
            'DEFAULT/bar' => { 'value'  => 'barValue' },
            'DEFAULT/baz' => { 'ensure' => 'absent' }
          }
        )
      end

      it {
        should contain_placement_config('DEFAULT/foo').with_value('fooValue')
        should contain_placement_config('DEFAULT/bar').with_value('barValue')
        should contain_placement_config('DEFAULT/baz').with_ensure('absent')
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
