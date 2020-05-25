class UsersController < ApplicationController
  before_action :find_user, only: [:show]

  def index
    @users = User.all
  end
  
  def show
    check_user
  end
  
  def login_form
    @user = User.new
  end

  def login
    username = params[:user][:username]
    user = User.find_by(username: username)

    if user 
      session[:user_id] = user.id
      flash[:success] = "Successfully logged in as existing user #{username}"
      redirect_to homepages_path
      return
    else
      user = User.new(username: username)
      if user.save
        session[:user_id] = user.id
        flash[:success] = "Successfully logged in as new user #{username}"
        redirect_to homepages_path
        return
      else
        flash[:warning] = "A problem occurred: Could not log in !! \n #{user.errors.full_messages[0]}"
        redirect_to login_path
        return
      end
    end

  end

  def logout
    if session[:user_id]
      user = User.find_by(id: session[:user_id])
      unless user.nil?
        flash[:notice] = "Goodbye #{user.username}"
        session[:user_id] = nil
      else 
        flash[:notice] = "Error -- unknown user"
        session[:user_id] = nil
      end
    else 
      flash[:error] = "You must be loggined in before to logout"
    end
    redirect_to root_path
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
