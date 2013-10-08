module Spree
  CheckoutController.class_eval do
    before_filter :create_dwolla_payment, :only => [:update]

    def payment_method
      Spree::PaymentMethod.find(:first, :conditions => [ "lower(name) = ?", 'dwolla' ]) || raise(ActiveRecord::RecordNotFound)
    end

    def create_dwolla_payment
      return unless (params[:state] == "payment")
      return unless params[:order][:payments_attributes]

      return unless Spree::PaymentMethod.find(params[:order][:payments_attributes].first[:payment_method_id]).kind_of?(Spree::Gateway::Dwolla)

      load_order

      payment = @order.payments.create!({
        :source => Spree::DwollaCheckout.create({
          :oauth_token => session[:dwolla_oauth_token],
          :pin => params[:dwolla_pin],
          :funding_source_id => params[:dwolla_funding_source] || payment_method.preferred_default_funding_source
        }, :without_protection => true),
        :amount => @order.total,
        :payment_method => payment_method
      }, :without_protection => true)

      @order.state = :confirm
      @order.save

      redirect_to checkout_state_path(@order.state)
    end

  end
end
