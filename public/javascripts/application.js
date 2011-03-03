function showPaymentOption(select) {
	if(select.selectedIndex == 0) {
	  $('#check_info').hide();
	  $('#paypal_button').hide();
	}
	if(select.selectedIndex == 1) {
	  $('#check_info').hide();
	  $('#paypal_button').show();
	}
	if(select.selectedIndex == 2) {
	  $('#paypal_button').hide();
	  $('#check_info').show();
	}
	return false;
}
