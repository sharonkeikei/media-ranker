class HomepagesController < ApplicationController
  def index
    @spotlight = Work.find_spotlight
  end
end
