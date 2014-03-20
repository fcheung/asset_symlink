Rake::Task["assets:precompile"].enhance do
  Rake::Task["asset_symlink:symlink"].invoke
end

namespace :asset_symlink do
  task :symlink do
    AssetSymlink.execute Rails.configuration.asset_symlink
  end
end