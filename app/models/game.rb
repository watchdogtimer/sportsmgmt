class Game < ActiveRecord::Base
  belongs_to :team
  belongs_to :opponent, :class_name => "Team"
  belongs_to :game_set
  belongs_to :league
  has_many :authorized_models, :foreign_key => :model_id, :conditions => {:model_type => "Game"}
  has_many :authorized_users, :through => :authorized_models, :source => :user
  
  def winner
    return nil unless score && opponent_score
    
    if score > opponent_score
     team
    elsif score < opponent_score
     opponent
    elsif score == opponent_score
      team #TODO add ties
    end
  end
  
  def loser
    return nil unless score && opponent_score
    winner == team ? opponent : team
  end
end
