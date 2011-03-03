authorization do  
  role :guest do
    has_permission_on :organizations, :to => [:read]
    has_permission_on :leagues, :to => [:read]
  end
  
  role :logged_in_user do
    has_permission_on :organizations, :to => [:create]
    has_permission_on :leagues, :to => [:create]
    has_permission_on :teams, :to => [:new]
  end
  
  role :profile_owner do
    has_permission_on :users, :to => :manage do
      if_attribute :id => is {user.id}
    end

    has_permission_on :players, :to => :manage do
      if_attribute :id => is {user.id}
    end
  end
  
  #role :league_player do
  #  has_permission_on :teams do
  #    to :read
  #    if_attribute :league => {:players => contains {user}}
  #  end
  #end
      
  #role :league_admin do
  #  has_permission_on :leagues do
  #    to [:manage, :add_players_to_team]
  #    if_attribute :authorized_users => contains {user}
  #  end
  #end
  
  role :organization_admin do
    has_permission_on :organizations, :to => :manage do
      if_attribute :user_id => is {user.id}
      if_attribute :authorized_users => contains {user}
    end
    
    has_permission_on :leagues, :to => [:manage, :add_players_to_team] do
      if_permitted_to :manage, :organization
    end
    
    has_permission_on :teams, :to => [:manage] do
      if_permitted_to :manage, :league
    end
  end
  
  role :super_admin do
    has_permission_on :organizations, :to => :fully_manage
    has_permission_on :leagues, :to => [:fully_manage, :add_players_to_team]
    has_permission_on :players, :to => :fully_manage
    has_permission_on :users, :to => :fully_manage
    has_permission_on :teams, :to => :fully_manage
    has_permission_on :game_sets, :to => :fully_manage
    has_permission_on :games, :to => :fully_manage
    has_permission_on :posts, :to => :fully_manage
  end
end
 
privileges do
  privilege :fully_manage, :includes => [:manage, :delete]
  privilege :manage, :includes => [:create, :read, :update]
  privilege :create, :includes => :new
  privilege :read, :includes => [:index, :show]
  privilege :update, :includes => :edit
  privilege :delete, :includes => :destroy
  privilege :add_players_to_team
end