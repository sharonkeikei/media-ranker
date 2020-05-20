require "test_helper"

describe UsersController do
  it 'can get the login form' do 
    get login_path

    must_respond_with :success
  end

  describe 'index' do
    it 'responds to index' do
      get users_path

      must_respond_with :success
    end
  end

  describe 'show' do
    it 'will get show for a valid user' do
    
      get user_path(users(:kitty).id)

      must_respond_with :success
    end

    it 'will redirect to users path if there is no a valid id provided' do
      invalid_id = -1

      get user_path(invalid_id)

      must_redirect_to users_path
    end
    
  end

  describe 'logging in' do
    it 'can login a new uesr' do
      # using login helper method from test helper
      user = nil 
      expect{
        user = login()
      }.must_differ "User.count", 1

      must_respond_with :redirect


      expect(user).wont_be_nil
      expect(session[:user_id]).must_equal user.id
      expect(user.username).must_equal "Gillian Chung"
    end

    it 'can login an exisiting user' do
      # using existing user in yml
      expect{
        login('Hello Kitty')
      }.wont_change "User.count"
      
      expect(session[:user_id]).must_equal (users(:kitty).id)
    end
  end

  describe 'logout' do
    it 'can logoout a logged in user' do
      login()

      expect(session[:user_id]).wont_be_nil

      post logout_path

      expect(session[:user_id]).must_be_nil
    end
  end

end 
