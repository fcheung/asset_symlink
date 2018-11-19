require "asset_symlink/version"
require "asset_symlink/railtie"
require 'fileutils'
module AssetSymlink
  def self.execute config
    normalize_configuration(config).each do |private_name, public_name|
      asset = if !Rails.application.assets.nil?
        Rails.application.assets.find_asset(private_name).digest_path
      else
        manifest = if Sprockets::Railtie.respond_to?(:build_manifest)
          Sprockets::Railtie.build_manifest(Rails.application)
        else
          Rails.application.assets_manifest
        end
        manifest.assets[private_name]
      end
      digested_location = Rails.root.join('public','assets', asset)
      public_location = Rails.root.join('public','assets',public_name)
      if File.dirname(public_name) != '.'
        FileUtils.mkdir_p(File.dirname(public_location))
      end
      digested_location = digested_location.relative_path_from(public_location.dirname)
      FileUtils.ln_sf(digested_location, Rails.root.join('public','assets',public_name))
    end
  end


  def self.normalize_configuration config
    case config
    when Hash
      config
    when String
      {config => config}
    when Array
      config.inject({}) do |result, element|
        result.merge(normalize_configuration(element))
      end
    when NilClass
      result = {}
      begin
        manifest = JSON.parse(File.read(Rails.application.config.assets.manifest))
        manifest["files"].each do |digested_name, value|
          result[value['logical_path']] = value['logical_path']
        end
        result
      rescue
        {}
      end
    else
      raise ArgumentError, "unexpected item #{config} in config.asset_symlink"
    end
  end
end
