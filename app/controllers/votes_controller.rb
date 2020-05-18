class VotesController < ApplicationController
  before_action :find_current_user, only: [:upvote]

  def upvote
    if @current_user.nil?
      flash[:error] = 'You would need to login to upvote a work!'
      redirect_back(fallback_location: root_path)
    end

    @work_id = params[:work_id]
    vote = Vote.new
    vote.work_id = @work_id
    vote.user_id = @current_user.id

    if Vote.check_exisiting_vote(@current_user.id, @work_id)
      flash[:error] = "You can only vote for the same work once"
      redirect_back(fallback_location: root_path)
    else 
      vote.save
      flash[:success] = "Successfully upvoted #{Work.find_by(@work_id)}"
      redirect_back(fallback_location: root_path)
    end
  end

end
