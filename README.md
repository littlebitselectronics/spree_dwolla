# spree_dwolla

This is the official Dwolla OAuth / REST extension for Spree.

## Version

1.2.2

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

* "Dwolla ID": Where you want the money to go to (Your Dwolla ID?)
* "Key": Your Dwolla API application key
* "Secret": Your Dwolla API application secret
* "OAuth Scope": The OAuth permissions you'd like to ask your users for; Defaults to 'Send|Funding|AccountInfoFull'; [See further documentation here](https://developers.dwolla.com/dev/pages/auth#scopes)
* "Allow Funding Sources": Check this if you'd like your users to be able to select a funding source other than the default source
* "Default Funding Source": The default funding source to use; Defaults to 'Balance' for Dwolla Balance
* "Allow ACH": Wether or not to allow ACH (slow bank-funded transactions) checkouts; Must have "Allow Funding Sources" enabled
* "Your OAuth Token": Used for refunding transactions; Enter your account's OAuth token. You can generate a token using our [Token Generator](https://developers.dwolla.com/dev/token) page
* "Your PIN": Used for refunding transactions; Enter your account's 4 digit PIN
* "Sandbox": Check this if you were granted access to Dwolla's UAT/Sandbox env
* "Enable Debug": Check this if you wish to log operations using rail's logger.info

## Webhooks

In order to keep transaction statuses updated, we recommend using Dwolla's Webhooks system. Simply set your Dwolla API application's TransactionStatus webhook to `http://www.YOURSTORE.com/dwolla/webhook/transaction_status`.

If you're running on localhost, you can easily create a tunnel using "ngrok".


## Changelog

1.2.2

* Fix source type, make non-controller action methods private, use conditional logging method (by [@sohara](https://github.com/sohara))

1.2.1

* Added debugging info around DwollaController#update

1.2.0

* Fix translation file missing label ("dwolla_funding_source")
* Auto approve instant-type transactions (Credit and Balance)
* Only pass the "R" order ID to the Dwolla notes field (as opposed to having the payment ID as well)
* Change payment provider to auto capture

1.1.0

* Add the ability to manually poll Dwolla for transaction updates

1.0.4

* Add sleep delay to webhook listener

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
