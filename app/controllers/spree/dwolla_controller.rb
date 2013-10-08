module Spree
  class DwollaController < StoreController
    def provider
      payment_method.provider
    end

    def payment_method
      Spree::PaymentMethod.find(:first, :conditions => [ "lower(name) = ?", 'dwolla' ]) || raise(ActiveRecord::RecordNotFound)
    end

    def cancel
      flash[:notice] = Spree.t(:cancel, :scope => :dwolla)
      redirect_to checkout_state_path(current_order.state)
    end

    def auth
      redirect_to provider::OAuth.get_auth_url(dwolla_return_url)
    end

    def logout
      session.delete :dwolla_oauth_token
      session.delete :dwolla_name
      session.delete :dwolla_id
      session.delete :dwolla_funding_sources

      redirect_to checkout_state_path(:payment, :method => 'dwolla')
    end

    def return
      begin
        code = params['code']
        token = provider::OAuth.get_token(code, dwolla_return_url)
        me = Dwolla::Users.me(token)

        if payment_method.preferred_allow_funding_sources
          session[:dwolla_funding_sources] = {}

          funding_sources = Dwolla::FundingSources.get(nil, token)
          funding_sources.each do |source|
            session[:dwolla_funding_sources][source['Name']] = source['Id']
          end
        end

        session[:dwolla_oauth_token] = token
        session[:dwolla_name] = me['Name'][0..(me['Name'].index(' ')-1)]
        session[:dwolla_id] = me['Id']

        flash[:notice] = Spree.t(:oauth_success, :scope => :dwolla)
      rescue ::Dwolla::APIError => exception
        flash[:notice] = Spree.t(:oauth_fail, :scope => :dwolla) % exception
      end

      redirect_to checkout_state_path(:payment, :method => 'dwolla')
    end
  end
end
