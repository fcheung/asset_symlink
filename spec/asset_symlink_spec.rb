require 'spec_helper'

describe AssetSymlink do

  describe 'execute' do
    let(:sandbox) {File.join(File.dirname(__FILE__),'..','tmp')}
    let(:manifest) {File.join(sandbox, 'manifest.json')}
    let(:assets) {Pathname.new(sandbox).join('public', 'assets')}

    before(:each) do
      FileUtils.rm_rf assets, :secure => true
      FileUtils.mkdir_p(assets)
      @assets_stub = double()
      Rails.stub_chain(:application,:config,:assets,:manifest => manifest)
      Rails.stub_chain(:application,:assets => @assets_stub)
      Rails.stub(:root).and_return(Pathname.new(sandbox))
      File.open(manifest, 'w'){ |f| f.write({"files" => {}}.to_json) }
    end

    def add_fake_asset(name, location)
      @assets_stub.stub(:find_asset).with(name).and_return(double(:digest_path => location))
      FileUtils.mkdir_p(assets.join(location).dirname)
      File.open(assets.join(location), 'w'){}
      manifest_hash = JSON.parse(File.read(manifest))
      manifest_hash["files"][location] = {}
      manifest_hash["files"][location]["logical_path"] = name
      File.open(manifest, 'w'){ |f| f.write(manifest_hash.to_json) }
    end

    it 'should symlink items at the top level of the assets folder' do
      add_fake_asset('widget.js', 'widget-abc123.js')
      AssetSymlink.execute('widget.js')
      expect(assets.join('widget.js')).to be_a_symlink_to('widget-abc123.js')
    end

    it 'should create directories as needed' do
      add_fake_asset('widget.js', 'widget-abc123.js')
      AssetSymlink.execute('widget.js' => 'v1/foo.js')
      expect(assets.join('v1','foo.js')).to be_a_symlink_to('../widget-abc123.js')
    end

    it 'should use relative links' do
      add_fake_asset('external/widget.js', 'external/widget-abc123.js')
      AssetSymlink.execute('external/widget.js')
      expect(assets.join('external/widget.js')).to be_a_symlink_to('widget-abc123.js')
    end

    it 'should overwrite old symlinks' do
      add_fake_asset('widget.js', 'widget-abc123.js')
      File.symlink('widget-old.js', assets.join('widget.js'))

      expect(assets.join('widget.js')).to be_a_symlink_to('widget-old.js')
      AssetSymlink.execute('widget.js')
      expect(assets.join('widget.js')).to be_a_symlink_to('widget-abc123.js')
    end

    it 'should create all asset symlinks by manifest.json' do
      add_fake_asset('external/widget.js', 'external/widget-abc123.js')
      add_fake_asset('external/widget1.js', 'external/widget-abc1234.js')
      AssetSymlink.execute(:all)
      expect(assets.join('external/widget.js')).to be_a_symlink_to('widget-abc123.js')
      expect(assets.join('external/widget1.js')).to be_a_symlink_to('widget-abc1234.js')
    end
  end

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
