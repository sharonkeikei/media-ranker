class Vote < ApplicationRecord
  belongs_to :user
  belongs_to :work

  #### so one account can only vote one time 
  validates_uniqueness_of :user_id, scope: :work_id

  # return true if there is an exisiting vote, else return false
  def check_exisiting_vote(current_user, work_id)
    return exisiting_vote = Vote.where(user_id: current_user.id, work_id: work_id)
  end

end
