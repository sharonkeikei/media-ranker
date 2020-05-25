require "test_helper"

describe VotesController do
  describe 'Guest user cannot upvote without login' do
    it "won't change work vote by one if guest didn't sign in" do
      expect{ 
        get work_upvote_path(works(:split).id)
    }.wont_change "works(:split).votes.count"
    end
  end
  
  describe 'Authenticated user that logged in can upvote a work' do
    it "will increase work vote by one if user did sign in" do
      # user hasn't vote on this work before 
      login()
    
      expect{ 
        get work_upvote_path(works(:wall).id)
      }.must_differ "works(:wall).votes.count", 1
    end

    it 'will create a new vote' do
      # user hasn't vote on this work before 
      login()
      expect{ 
        get work_upvote_path(works(:wall).id)
      }.must_differ "Vote.count", 1

      expect(Vote.last.work).must_equal works(:wall)
      expect(Vote.last.user.username).must_equal "Gillian Chung" 
    end

    it 'will NOT let the same user to upvote the same work more than once' do
      # Sharon has already voted on works(:asana) in yml

      login(users(:sharon).username)
      expect{ 
        get work_upvote_path(works(:asana).id)
      }.wont_change "works(:asana).votes.count"

      expect{ 
        get work_upvote_path(works(:asana).id)
      }.wont_change "Vote.count"

      expect(flash[:error]).must_include "You can only vote for the same work once"
    end

    it "redirects us back if the user is not logged in" do
      # Act
      expect{ 
        get work_upvote_path(works(:asana).id)
      }.wont_change "works(:asana).votes.count"

      # Assert 
      must_respond_with :redirect
      expect flash[:error].must_equal  "Sorry! You must be logged in to upvote!"
    end
  end
end
