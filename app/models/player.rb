class Player < User
  has_many :registrations, :dependent => :destroy
  has_many :leagues, :through => :registrations
  has_many :team_memberships, :dependent => :destroy
  has_many :teams, :through => :team_memberships
  belongs_to :ability
  belongs_to :throw_level
  
  validates_presence_of :first_name, :last_name, :gender, :ability_id, :throw_level_id
  
  def current_team
    self.teams.first
  end
  
  def is_registered_for?(league)
    self.registrations.collect { |r| r.league }.include?(league)
  end
  
  def has_unregistered_leagues?
    unregistered_leagues.size > 0 if unregistered_leagues
  end
  
  def unregistered_leagues
    leagues = League.unexpired_leagues - self.leagues.unexpired_leagues
    leagues
  end
  
  def newly_joined_leagues
    leagues = self.leagues.unexpired_leagues.reject { |league|
      on_a_team = false
      league.teams.each do |team|
        if team && team.players.include?(self)
          on_a_team = true
        end
      end
      on_a_team
    }
    leagues
  end
  
  def has_newly_joined_leagues?
    newly_joined_leagues.size > 0 if newly_joined_leagues
  end
  
  def has_notifications?
    has_unregistered_leagues? || has_newly_joined_leagues?
  end
end
