require 'spec_helper'
describe 'Integration specs' do
  def test_app_location
    Pathname.new(File.dirname(__FILE__)).join('dummy_app')
  end
  let(:assets) {test_app_location.join('public', 'assets')}
  def run_in_test_app(command)
    Dir.chdir(test_app_location) do
      output = Kernel.send :`,command
      raise output unless $? == 0
    end
  end

  before :all do
    FileUtils.rm_rf(test_app_location.join('public', 'assets'))
    run_in_test_app('rake assets:precompile 2>&1')
  end

  it 'should have symlinked application.js to the digested application.js' do
    expect(assets.join('application.js')).to be_a_symlink_to(find_asset_name('application-*.js'))
    expect(File.read(test_app_location.join('public','assets','application.js'))).to match(/alert\('application.js'\)/)
  end

  it 'should have symlinked 3rdpaty/all.js to the digested lib.js' do
    expect(assets.join('3rdparty/all.js')).to be_a_symlink_to(find_asset_name('3rdparty/lib-*.js'))
    expect(File.read(test_app_location.join('public','assets','3rdparty', 'all.js'))).to match(/alert\('3rd party js'\)/)
  end

  def find_asset_name(path)
    File.basename(Dir.chdir(assets) { Dir.glob(path).first })
  end
end
