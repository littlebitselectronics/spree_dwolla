module Spree
  class DwollaWebhookController < StoreController
    #include ActiveMerchant::Billing::Integrations
    skip_before_filter :verify_authenticity_token

    ssl_required

    def provider
      payment_method.provider
    end

    def payment_method
      Spree::PaymentMethod.find(:first, :conditions => [ "lower(name) = ?", 'dwolla' ]) || raise(ActiveRecord::RecordNotFound)
    end

    def transaction_status
      dwolla_transaction_id = params["Transaction"]["Notes"]
      dwolla_transaction_id = dwolla_transaction_id[0..(dwolla_transaction_id.index('-')-1)]
      signature = request.headers["X-Dwolla-Signature"]
      payment_status = params["Transaction"]["Status"].downcase unless params["Transaction"]["Status"].nil?

      @order = Spree::Order.find_by_number(dwolla_transaction_id)
      if(@order)
        @payment = @order.payments.where(:state => "pending", :source_type => Spree::DwollaCheckout).first
        if @payment
          @payment.log_entries.create(:details => request.raw_post + " (Signature: #{signature})")

          begin
            provider::OffsiteGateway.verify_webhook_signature(signature, request.raw_post)
            @payment.log_entries.create(:details => "Dwolla's webhook signature seems to be just fine. Changing payment to status: #{payment_status}")

            case payment_status
              when "failed"
              when "cancelled"
              when "reclaimed"
                @payment.failure!

              when "pending"
              when "completed"
                @payment.pend!

              when "processed"
                @payment.complete!
            end
          rescue ::Dwolla::APIError => exception
            @payment.log_entries.create(:details => "Woah. Dwolla's webhook signature seems to be invalid. Not sure what's going on, but I think I'm gonna ignore this message completely and mark this payment a failure.")

            @payment.failure!
          end
        end
      end

      render :nothing => true
    end
  end
end
