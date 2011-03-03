class InitDatabase < ActiveRecord::Migration
  def self.up
    create_table :abilities do |t|
      t.integer :level
      t.string :description
      t.timestamps
    end
    
    create_table :authorized_models do |t|
      t.integer :model_id
      t.string :model_type
      t.integer :user_id
      t.timestamps
    end
    
    create_table :games do |t|
      t.datetime :time
      t.integer :game_set_id, :default => nil
      t.integer :league_id, :default => nil
      t.integer :team_id
      t.integer :opponent_id
      t.integer :game_in_set
      t.integer :score
      t.integer :opponent_score
      t.timestamps
    end
    
    create_table :game_sets do |t|
      t.integer :league_id
      t.integer :team_id
      t.integer :opponent_id
      t.datetime :time
      t.timestamps
    end

    create_table :game_sets_teams do |t|
      t.integer :game_set_id
      t.integer :team_id
      t.timestamps
    end   
         
    create_table :leagues do |t|
      t.integer :organization_id
      t.text :paypal_form_text
      t.text :description
      t.text :check_info_text
      t.boolean :locked
      t.integer :player_cap
      t.boolean :active
      t.string :name
      t.string :game_type
      t.date :reg_date
      t.float :reg_fee
      t.date :late_reg_date
      t.float :late_reg_fee
      t.date :close_reg_date
      t.timestamps
    end

    create_table :missed_games do |t|
      t.integer :registration_id
      t.integer :game_id
      t.timestamps
    end
    
    create_table :organizations do |t|
      t.string :name
      t.integer :user_id
      t.timestamps
    end
    
    create_table :registrations do |t|
      t.integer :player_id
      t.integer :league_id
      t.integer :team_info
      t.string :team_name
      t.string :missed_games
      t.string :shirt_size
      t.string :payment_type
      t.string :payment_status
      t.boolean :captain
      t.boolean :volunteer
      t.timestamps
    end

    create_table :roles_users, :id => false, :force => true  do |t|
      t.integer :user_id, :role_id
      t.timestamps
    end

    create_table :roles, :force => true do |t|
      t.string  :title, :authorizable_type, :limit => 40
      t.integer :authorizable_id
      t.timestamps
    end
    
    create_table :team_games do |t|
      t.integer :team_score
      t.integer :opponent_score
      t.timestamps
    end
    
    create_table :team_memberships do |t|
      t.integer :player_id
      t.integer :team_id
      t.timestamps
    end
    
    create_table :teams do |t|
      t.string :name
      t.string :skill_level
      t.integer :league_id
      t.integer :organizer_id
      t.timestamps
    end
    
    create_table :throw_levels do |t|
      t.integer :level
      t.string :description
      t.timestamps
    end
    
    create_table :users do |t|
      t.string    :type
      t.string    :login,                 :null => false
      t.string    :crypted_password,      :null => false
      t.string    :password_salt,         :null => false # not needed if you are encrypting your pw instead of using a hash algorithm.
      t.string    :persistence_token,     :null => false, :default => ""
      t.string    :single_access_token,   :null => false # optional, see the tokens section below.
      t.string    :perishable_token,      :null => false # optional, see the tokens section below.
      t.integer   :login_count,           :null => false, :default => 0 # optional, this is a "magic" column, see the magic columns section below
          
      t.string    :first_name
      t.string    :last_name
      t.string    :gender
      t.integer   :age
      #t.string    :address_1
      #t.string    :address_2
      #t.string    :city
      #t.string    :state
      #t.integer   :zip  
      t.integer   :ability_id
      t.integer   :throw_level_id
      t.timestamps
    end
    
    ["Beginner never played ultimate",
      "Beginner - never played ultimate but athletic",
      "Novice - played a little but confused on the field",
      "Novice - know the rules, understand cutting and defense",
      "Intermediate - understand stacking and forcing",
      "Intermediate - know offense and defense and throw well",
      "Advanced - good skills, field sense, athletic and play good D",
      "Advanced - could play with a competitive club/college team",
      "Expert - pretty damn good, but some people can beat me",
      "Expert - Perfection, baby"].each_with_index do |description, index|
        Ability.create(:level => index + 1, :description => description)
    end
    
    ["Can't Throw",
      "Backhand is reliable",
      "Forehand is reliable",
      "Can throw with a mark on",
      "Can break the mark",
      "Usually handle",
      "Money throws"].each_with_index do |description, index|
        ThrowLevel.create(:level => index + 1, :description => description)
    end
  end


  def self.down
    drop_table :abilities
    drop_table :authorized_models  
    drop_table :games
    drop_table :game_sets
    drop_table :game_sets_teams
    drop_table :leagues
    drop_table :missed_games
    drop_table :organizations
    drop_table :registrations
    drop_table :roles
    drop_table :roles_users
    drop_table :team_games
    drop_table :team_memberships
    drop_table :teams
    drop_table :throw_levels
    drop_table :users
  end
end