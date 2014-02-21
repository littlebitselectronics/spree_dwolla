require 'dwolla'
module Spree
  class Gateway::Dwolla < Gateway
    preference :dwolla_id, :string
    preference :key, :string
    preference :secret, :string
    preference :oauth_scope, :string, default: 'Send|Funding|AccountInfoFull'
    preference :sandbox, :boolean, :default => true
    preference :allow_funding_sources, :boolean, :default => false
    preference :default_funding_source, :string, default: 'Balance'

    def payment_profiles_supported?
      true
    end

    def auto_capture?
      false
    end

    def method_type
      'dwolla'
    end

    def provider_class
      ::Dwolla
    end

    def provider
      ::Dwolla::api_key = preferred_key
      ::Dwolla::api_secret = preferred_secret
      ::Dwolla::scope = preferred_oauth_scope
      ::Dwolla::sandbox = preferred_sandbox
      ::Dwolla::debug = preferred_sandbox

      provider_class
    end

    def authorize(amount, dwolla_checkout, gateway_options={})
      begin
        transaction_id = provider::Transactions.send(
          {
            :destinationId => preferred_dwolla_id,
            :amount => (amount / 100), # amount is given in cents; expected in dollars
            :pin => dwolla_checkout.pin,
            :fundsSource => dwolla_checkout.funding_source_id,
            :notes => gateway_options[:order_id]
          }, dwolla_checkout.oauth_token)

        dwolla_checkout.update_column(:transaction_id, transaction_id)

        ActiveMerchant::Billing::Response.new(true, 'Dwolla Checkout: Success')
      rescue ::Dwolla::APIError => exception
        payment_id = gateway_options[:order_id][(gateway_options[:order_id].index('-')+1)..-1]
        @payment = Spree::Payment.find_by_identifier(payment_id)
        @payment.log_entries.create(:details => "Oops. Something went wrong. Dwolla said: #{exception}")
        puts "Foobar"
        puts payment_id

        ActiveMerchant::Billing::Response.new(false, 'Dwolla Checkout: Failure', { :message => "Dwolla failed: #{exception}" })
      end
    end

  end
end
