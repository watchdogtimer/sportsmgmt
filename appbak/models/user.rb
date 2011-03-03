class User < ActiveRecord::Base
  acts_as_authentic
  #acts_as_authorized_user
  #acts_as_authorizable
  has_many :organizations  
  has_many :roles_users, :dependent => :delete_all
  has_many :roles, :through => :roles_users
  has_many :authorized_models
  #has_many :models, :through => :authorized_models
  before_save :set_current_user_for_model_security
 
  def role_symbols
    user_roles = (roles || []).map {|r| r.title.to_sym}
    if self.organizations.size > 0
      user_roles << :organization_owner
    end
    user_roles << :guest
    user_roles << :league_admin
    user_roles << :organization_admin
    user_roles << :profile_owner
    user_roles << :league_player
    user_roles << :logged_in_user
    
    if ENV['RAILS_ENV'] == "development" || self.login == "tom.hartwell@gmail.com" || self.login == "oneaim@gmail.com" || self.login == "ratisbest@hotmail.com" || self.login == "jclorfeine@hotmail.com"
      user_roles << :super_admin
    end
    user_roles
  end
  
  validates_confirmation_of :login, :password
  validates_format_of :login, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i,
    :message => "Email is not formatted correctly."
  
  # Add roles eventually
  def admin?
    return false if ENV['RAILS_ENV'] == "development"  #&& self.login == "tom@gmail.com"
    self.login == "tom.hartwell@gmail.com" || self.login == "jclorfeine@hotmail.com" || self.login == "ratisbest@hotmail.com"
  end
  
  def admin_or_owner?
    (self == current_user) || admin?
  end
  
  def name
    "#{first_name} #{last_name}"
  end
  
  def deliver_password_reset_instructions!
    reset_perishable_token!
    Notifier.deliver_password_reset_instructions(self)
  end
  
  #def has_role?(role)
  #  self.roles.count(:conditions => ['name = ?', role]) > 0
  #end

  #def add_role(role)
  #  return if self.has_role?(role)
  #  self.roles << Role.find_by_name(role)
  #end
  protected
 
  def set_current_user_for_model_security
    Authorization.current_user = self
  end
end
