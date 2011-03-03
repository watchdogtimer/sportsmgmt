class Team < ActiveRecord::Base
  has_many :team_memberships, :dependent => :destroy
  has_many :players, :through => :team_memberships
  belongs_to :league
  belongs_to :organizer, :class_name => 'Player', :foreign_key => 'organizer_id'
  has_many :games, :dependent => :destroy
  has_many :game_sets, :dependent => :destroy
  
  has_many :authorized_models, :foreign_key => :model_id, :conditions => {:model_type => "Team"}
  has_many :authorized_users, :through => :authorized_models, :source => :user
  
  def display_name
    if name && !name.blank?
      name
    else
      "#{organizer.name}'s"
    end
  end
  
  def games
    Game.find(:all, :conditions => "team_id = #{self.id} OR opponent_id = #{self.id}")
  end
  
  def game_sets
    GameSet.find(:all, :conditions => "team_id = #{self.id} OR opponent_id = #{self.id}")
  end
  
  def record
    wins = 0
    losses = 0
    record_array = [wins, losses]
    if self.league
      if self.league.game_type == "Games"
        record_array = record_by_games
      else
        record_array = record_by_game_sets
      end
    else  
      record_array = record_by_game_sets
    end
    record_array
  end
  
  def record_by_game_sets
    wins = 0
    losses = 0
    self.game_sets.each do |game_set|
      if self == game_set.winner
        wins += 1
      elsif self == game_set.loser
        losses += 1
      end
    end
    [wins, losses]
  end
  
  def record_by_games
    wins = 0
    losses = 0
    self.games.each do |game|
      if self == game.winner
        wins += 1
      elsif self == game.loser
        losses += 1
      end
    end
    [wins, losses]
  end
  
  def record_to_s
    team_record = self.record
    "#{team_record[0]}-#{team_record[1]}"
  end
end
