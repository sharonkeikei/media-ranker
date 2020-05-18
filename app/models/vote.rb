class Vote < ApplicationRecord
  belongs_to :user
  belongs_to :work

  #### so one account can only vote one time 
  validates_uniqueness_of :user_id, scope: :work_id

  # return true if there is an exisiting vote, else return false
  def self.check_exisiting_vote(current_user_id, work_id)
    return Vote.where(user_id: current_user_id, work_id: work_id).count > 0
  end

end
