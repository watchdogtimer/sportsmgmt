class Registration < ActiveRecord::Base
  composed_of :payment, :class_name => "Payment", :mapping =>[%w(payment_type payment_type), %w(payment_status status)] 
  belongs_to :player
  belongs_to :league

  validates_presence_of :payment_type, :payment_status, :player_id, :league_id
end
