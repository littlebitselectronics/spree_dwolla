//= require spree/frontend

SpreeDwolla = {
  qs: function(key) {
    key = key.replace(/[*+?^$.\[\]{}()|\\\/]/g, "\\$&");
    var match = location.search.match(new RegExp("[?&]"+key+"=([^&]+)(&|$)"));
    return match && decodeURIComponent(match[1].replace(/\+/g, " "));
  },

  hidePaymentSaveAndContinueButton: function(paymentMethod, preauth) {
    if (SpreeDwolla.paymentMethodID && paymentMethod.val() == SpreeDwolla.paymentMethodID) {
      if(preauth) { $('.continue').hide(); }
    } else {
      if(preauth) { $('.continue').show(); }
    }
  }
}

$(document).ready(function() {
  checkedPaymentMethod = $('div[data-hook="checkout_payment_step"] input[type="radio"]:checked');
  SpreeDwolla.hidePaymentSaveAndContinueButton(checkedPaymentMethod);
  paymentMethods = $('div[data-hook="checkout_payment_step"] input[type="radio"]').click(function(e) {
    var preauth = SpreeDwolla.dwollaId ? false : true;
    SpreeDwolla.hidePaymentSaveAndContinueButton($(e.target), preauth);
  });

  if(SpreeDwolla.qs('method') == 'dwolla') {
    // Switch to the Dwolla payment tab
  }
})
