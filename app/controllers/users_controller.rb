class UsersController < ApplicationController
  before_action :find_user, only: [:show]

  def index
    @users = User.all
  end
  
  def show
    check_user
  end

  private

  def find_user
    user_id = params[:id].to_i
    @user = User.find_by(id: user_id)
  end

  #helper method to react properly to check the work and if work is not found
  def check_user
    if @user.nil?
      redirect_to users_path, notice: 'The user you are looking for is not found 😢'
      return
    end
  end

end
