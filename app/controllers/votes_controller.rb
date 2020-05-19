class VotesController < ApplicationController
  before_action :require_login, only: [:upvote]

  def upvote
    @work_id = params[:work_id]
    vote = Vote.new
    vote.work_id = @work_id
    vote.user_id = @current_user.id

    if Vote.check_exisiting_vote(@current_user.id, @work_id)
      flash[:error] = "You can only vote for the same work once"
      redirect_back(fallback_location: root_path)
    else 
      vote.save
      flash[:success] = "Successfully upvoted #{Work.find_by(id: @work_id).title}"
      redirect_back(fallback_location: root_path)
    end
  end

end
