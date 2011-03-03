class League < ActiveRecord::Base
  belongs_to :organization
  has_many :teams, :dependent => :destroy
  has_many :registrations, :dependent => :destroy
  has_many :players, :through => :registrations
  has_many :games
  has_many :game_sets
  has_many :authorized_models, :foreign_key => :model_id, :conditions => {:model_type => "League"}
  has_many :authorized_users, :through => :authorized_models, :source => :user 
  
  validates_presence_of :reg_fee, :close_reg_date
  
  def current_league?
    self.id == 1
  end
    
  def self.expired_leagues
    leagues = League.find(:all, :conditions => ["close_reg_date < :now", {:now => Time.now}])
    leagues
  end
  
  def self.unexpired_leagues
    leagues = League.find(:all, :conditions => ["close_reg_date >= :now", {:now => Time.now}])
    leagues
  end
end
