require 'puppet'
require 'puppet/type/iis_virtualdirectory'

describe Puppet::Type.type(:iis_virtualdirectory) do
  let(:params) do
    {
      name: 'test_virtualdirectory',
      ensure: 'present',
      path: 'C:/Temp',
      site: 'Default Web Site'
    }
  end

  def subject(p = params)
    Puppet::Type.type(:iis_virtualdirectory).new(p)
  end

  it 'accepts a virtualdirectory name' do
    expect(subject[:name]).to eq('test_virtualdirectory')
  end

  it 'accepts an ensure state' do
    expect(subject[:ensure]).to eq(:present)
  end

  it 'accepts a path' do
    expect(subject[:path]).to eq('C:/Temp')
  end

  it 'accepts a site' do
    expect(subject[:site]).to eq('Default Web Site')
  end

  it 'accepts a site that includes periods' do
    expect(subject(params.merge(site: 'www.mysite.com'))[:site]).to eq('www.mysite.com')
  end

  it 'accepts a directory as an override for the name' do
    expect(subject(params.merge(directory: 'my_directory'))[:directory]).to eq('my_directory')
  end
end
