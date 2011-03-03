class GameSet < ActiveRecord::Base
  belongs_to :team
  belongs_to :opponent, :class_name => "Team"
  has_many :games, :dependent => :destroy
  belongs_to :league
  has_many :authorized_models, :foreign_key => :model_id, :conditions => {:model_type => "GameSet"}
  has_many :authorized_users, :through => :authorized_models, :source => :user
  
  def winner
    team_wins = 0
    opponent_wins = 0
    winner = nil
    if games.size > 0
      games.each do |game|
        if game.score && game.oppoent_score
          if game.score > game.opponent_score
            team_wins += 1
          else
            opponent_wins += 1
          end
        end
      end
      if team_wins == 0 && opponent_wins == 0
        winner = nil
      elsif team_wins > opponent_wins
        winner = self.team
      else
        winner = self.opponent
      end
    end
    winner
  end
  
  def loser
    self.team == winner ? self.opponent : self.team
  end      
end
