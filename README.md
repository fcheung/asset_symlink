# AssetSymlink

Rails 4 and above only generate digested assets. From within your app this is a huge win, but it complicates things in other situations. For example perhaps you provide javascript for 3rd parties to use.

This gem automates symlinking your digested assets to their public names

## Installation

You only need to include this gem in the environment(s) that precompile your assets

## Usage

After installing the gem you need to configure how digested assets are mapped to their public names. For example

  config.asset_symlink = ['widgets.js']

would symlink `widgets.js` to `widgets-<digest>.js`

you can also specify an alternative public name, for example

  config.asset_symlink = {'widgets.js' => 'v1/foo.js'}

would symlink `v1/foo.js` to `widgets-<digest>.js`

Lastly you can mix and match these, for example


  config.asset_symlink = ['widgets.js', {'partner.js' => 'v1/partner.js'}]

symlinks `widgets.js` to `widgets-<digest>.js` and `v1/partner.js` to `partner-<digest>.js`

## Contributing

1. Fork it ( http://github.com/fcheung/asset_symlink/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
