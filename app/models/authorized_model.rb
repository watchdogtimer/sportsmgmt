class AuthorizedModel < ActiveRecord::Base
  belongs_to :user
  belongs_to :model, :polymorphic => true
end
