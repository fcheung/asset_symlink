require 'spec_helper'

describe AssetSymlink do
  describe 'normalize_configuration' do
    it 'should convert a nil configuration to {}' do
      AssetSymlink.normalize_configuration(nil).should == {}
    end

    it 'should convert a single string to a 1 element hash' do
      AssetSymlink.normalize_configuration('foo.js').should == {'foo.js' => 'foo.js'}
    end

    it 'should convert an array of strings to hashes' do
      AssetSymlink.normalize_configuration(%w(foo.js bar.js)).should == {'foo.js' => 'foo.js', 'bar.js' => 'bar.js'}
    end

    it 'should return a hash configuration unchanged' do
      AssetSymlink.normalize_configuration('foo.js' => 'bar.js').should == {'foo.js' => 'bar.js'}
    end

    it 'should convert an array of hashes by merging them' do
      AssetSymlink.normalize_configuration([{'foo.js' => 'v1/foo.js'}, 
                                            {'bar.js' => 'v1/bar.js'}]).should == {'foo.js' => 'v1/foo.js',
                                                                                  'bar.js' => 'v1/bar.js'}
    end

    it 'should allow a mixture of strings and hashes' do
      AssetSymlink.normalize_configuration(['foo.js', {'bar.js' => 'v1/bar.js'}]).
                                          should == {'foo.js' => 'foo.js', 'bar.js' => 'v1/bar.js'}
    end

    it 'should raise on unexpected item in configuration' do
      expect {AssetSymlink.normalize_configuration([1])}.to raise_error(ArgumentError)
    end
  end
end