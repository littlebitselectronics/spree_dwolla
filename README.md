# Official Dwolla for Spree
=================================================================================

This is the official Dwolla OAuth / REST extension for Spree.

## Version
1.0.3

## Installation

Add spree_dwolla to your Gemfile:

```ruby
gem 'spree_dwolla'
```

Bundle your dependencies and run the installation generator:

```shell
bundle
bundle exec rails g spree_dwolla:install
```

## Configuration

To use this extension, you'll need a Dwolla API application.

In order to run the extension on test mode, you'll need a Dwolla UAT account. Contact Dwolla's [dev support](mailto:devsupport@dwolla.com) to obtain access to that environment.

Here's an overview of the configuration parameters:

* "Dwolla ID": Where you want the money to go to
* "Key": Your Dwolla API application key
* "Secret": Your Dwolla API application secret
* "OAuth Scope": The OAuth permissions you'd like to ask your users for; Defaults to 'Send|Funding|AccountInfoFull'; [See further documentation here](https://developers.dwolla.com/dev/pages/auth#scopes)
* "Sandbox": Check this if you were granted access to Dwolla's UAT/Sandbox env
* "Allow Funding Sources": Check this if you'd like your users to be able to select a funding source other than the default source
* "Default Funding Source": The default funding source to use; Defaults to 'Balance' for Dwolla Balance

## Webhooks

In order to keep transaction statuses updated, we recommend using Dwolla's Webhooks system. Simply set your Dwolla API application's TransactionStatus webhook to `http://www.YOURSTORE.com/dwolla/webhook/transaction_status`.

If you're running on localhost, you can easily create a tunnel using "ngrok".


## Changelog

1.0.3

* Simplify payment creation logic
* Switch logic to after_filter

1.0.2

* Move payment creation logic to Spree/CheckoutController#update before_filter
* Remove custom payment <form/> action

1.0.1

* Clean up some debug puts

1.0.0

* Initial release

## Support

- Dwolla Dev Support &lt;devsupport@dwolla.com&gt;
- Michael Schonfeld &lt;michael@dwolla.com&gt;

Copyright (c) 2013 Michael Schonfeld / Dwolla, released under the New BSD License
