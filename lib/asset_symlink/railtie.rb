require 'rails'

module AssetSymlink
  class Railtie < Rails::Railtie
    config.asset_symlink = nil

    rake_tasks do
      load "asset_symlink/tasks/symlink.rake"
    end
  end
end