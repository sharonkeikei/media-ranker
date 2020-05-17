class Vote < ApplicationRecord
  belongs_to :user
  belongs_to :work

  #### so one account can only vote one time 
  validates_uniqueness_of :user_id, scope: :work_id
end
