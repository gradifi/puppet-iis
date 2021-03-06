require 'puppet'
require 'puppet/type/iis_pool'
require File.expand_path(File.join(File.dirname(__FILE__), 'iis_stateful_shared_examples.rb'))

describe Puppet::Type.type(:iis_pool) do
  let(:params) do
    {
      name: 'test_pool',
      ensure: 'started',
      enable_32_bit: true,
      runtime: '4.0',
      pipeline: 'Classic'
    }
  end

  def subject(p = params)
    Puppet::Type.type(:iis_pool).new(p)
  end

  it 'accepts a pool name' do
    expect(subject[:name]).to eq('test_pool')
  end

  describe 'ensure' do
    include_context 'stateful types'
    it_behaves_like 'stateful type'
  end

  it 'accepts an enable_32_bit state' do
    expect(subject[:enable_32_bit]).to eq(:true)
  end

  describe 'runtime =>' do
    it 'accepts a runtime' do
      expect(subject[:runtime]).to eq('v4.0')
    end
    it 'munges runtime' do
      expect(subject(params.merge(runtime: '4.0'))[:runtime]).to eq('v4.0')
    end
    it 'accepts No Managed Code and munges it to the empty string' do
      expect(subject(params.merge(runtime: 'No Managed Code'))[:runtime]).to eq('')
    end
    it 'accepts the empty string for No Managed Code' do 
      expect(subject(params.merge(runtime: ''))[:runtime]).to eq('')
    end
    it 'accepts case-insensitive No Managed Code' do 
      expect(subject(params.merge(runtime: 'no ManaGeD coDe'))[:runtime]).to eq('')
    end
  end

  describe 'pipeline =>' do
    %w(Integrated Classic).each do |pipeline|
      it "should accept #{pipeline}" do
        param = params.merge(pipeline: pipeline)
        expect(subject(param)[:pipeline]).to eq(pipeline)
      end
      it "should munge #{pipeline.downcase} to capital" do
        param = params.merge(pipeline: pipeline.downcase)
        expect(subject(param)[:pipeline]).to eq(pipeline)
      end
    end
  end
end
