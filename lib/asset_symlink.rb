require "asset_symlink/version"
require "asset_symlink/railtie"

module AssetSymlink
  def self.execute
    normalized_configuration.each do |private_name, public_name|
      digested_location = Rails.root.join('public','assets', Rails.application.assets.find_asset(private_name).digest_path)
      public_location = Rails.root.join('public','assets',public_name)
      if File.dirname(public_name) != '.'
        FileUtils.mkdir_p(File.dirname(public_location))
      end
      if File.symlink?(public_location)
        File.delete(public_location)
      end
      digested_location = digested_location.relative_path_from(public_location.dirname)
      File.symlink(digested_location, Rails.root.join('public','assets',public_name))
    end
  end

  def self.normalized_configuration
    normalize_configuration Rails.configuration.asset_symlink
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
      {}
    else
      raise ArgumentError, "unexpected item #{config} in config.asset_symlink"
    end
  end
end
