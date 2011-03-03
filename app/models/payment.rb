class Payment
  attr_accessor :payment_type, :status
  STATUS = %w(pending paid)
  
  def initialize(payment_type, status)
    @payment_type = payment_type
    @status = status
  end
end
