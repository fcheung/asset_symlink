# AssetSymlink

[![Build Status](https://travis-ci.org/fcheung/asset_symlink.png)](https://travis-ci.org/fcheung/asset_symlink)

Rails 4 and above only generate digested assets. From within your app this is a huge win, but it complicates things if you need to know the location of an asset from elsewhere.

This gem automates symlinking your digested assets to their public names. You can rely on the latest
version of the asset being available at a predictable location and these assets will continue to be 
served by your web servers without hitting your rails instances.

Example use cases:
- images/css referenced from static html pages (eg 500.html)
- javascript you make available to 3rd parties 

## Installation

You only need to include this gem in the environment(s) that precompile your assets

## Usage

After installing the gem you need to configure which digested assets are mapped to their public names and how. For example

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
