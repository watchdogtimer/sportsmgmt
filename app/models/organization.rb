class Organization < ActiveRecord::Base
  belongs_to :owner, :class_name => 'User', :foreign_key => 'user_id'
  has_many :leagues
  has_many :authorized_models, :foreign_key => :model_id, :conditions => {:model_type => "Organization"}
  has_many :authorized_users, :through => :authorized_models, :source => :user
  
  validates_presence_of :name, :on => :create
  validates_presence_of :owner
end
