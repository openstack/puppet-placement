require 'puppet'
require 'puppet/type/placement_config'

describe 'Puppet::Type.type(:placement_config)' do
  before :each do
    @placement_config = Puppet::Type.type(:placement_config).new(:name => 'DEFAULT/foo', :value => 'bar')
  end

  it 'should require a name' do
    expect {
      Puppet::Type.type(:placement_config).new({})
    }.to raise_error(Puppet::Error, 'Title or name must be provided')
  end

  it 'should not expect a name with whitespace' do
    expect {
      Puppet::Type.type(:placement_config).new(:name => 'f oo')
    }.to raise_error(Puppet::Error, /Parameter name failed/)
  end

  it 'should fail when there is no section' do
    expect {
      Puppet::Type.type(:placement_config).new(:name => 'foo')
    }.to raise_error(Puppet::Error, /Parameter name failed/)
  end

  it 'should not require a value when ensure is absent' do
    Puppet::Type.type(:placement_config).new(:name => 'DEFAULT/foo', :ensure => :absent)
  end

  it 'should accept a valid value' do
    @placement_config[:value] = 'bar'
    expect(@placement_config[:value]).to eq(['bar'])
  end

  it 'should accept a value with whitespace' do
    @placement_config[:value] = 'b ar'
    expect(@placement_config[:value]).to eq(['b ar'])
  end

  it 'should accept valid ensure values' do
    @placement_config[:ensure] = :present
    expect(@placement_config[:ensure]).to eq(:present)
    @placement_config[:ensure] = :absent
    expect(@placement_config[:ensure]).to eq(:absent)
  end

  it 'should not accept invalid ensure values' do
    expect {
      @placement_config[:ensure] = :latest
    }.to raise_error(Puppet::Error, /Invalid value/)
  end

  it 'should autorequire the package that install the file' do
    catalog = Puppet::Resource::Catalog.new
    anchor = Puppet::Type.type(:anchor).new(:name => 'placement::install::end')
    catalog.add_resource anchor, @placement_config
    dependency = @placement_config.autorequire
    expect(dependency.size).to eq(1)
    expect(dependency[0].target).to eq(@placement_config)
    expect(dependency[0].source).to eq(anchor)
  end

end
