class WorksController < ApplicationController
  before_action :find_work, :check_work, only: [:show, :edit, :update, :destroy]
  def index
    @works = Work.all.order(:title)    
  end

  def show
    check_work
  end

  def new
    @work = Work.new
  end

  def create
    @work = Work.new(work_params)
    if @work.save
      flash[:success] = "#{@work.title} has been successfully added!"
      redirect_to work_path(id: @work.id)
    else
      flash.now[:warning] = "A problem occurred: Could not create album. \n" + @work.errors.full_messages[0]
      render :new
      return
    end
  end

  def edit
    check_work
  end

  def update
    if @work.update(work_params)
      flash[:success] = "#{@work.title} has been successfully edited!"
      redirect_to work_path(id: @work.id)
    else
      flash.now[:warning] = "#{@work.title} is not edited"
      render :edit
      return
    end
  end

  def destroy
    if @work.destroy
      redirect_to works_path, notice: 'Work was successfully removed.'
    end
  end

  private

  def find_work
    work_id = params[:id].to_i
    @work = Work.find_by(id: work_id)
  end

  #helper method to react properly to check the work and if work is not found
  def check_work
    if @work.nil?
      redirect_to works_path, notice: 'The work you are looking for is not found 😢'
      return
    end
  end

  def work_params
    return params.require(:work).permit(:title, :category, :creator, :publication_year, :description)
  end
end

