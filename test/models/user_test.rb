require "test_helper"

describe User do
  let (:new_user) { 
    User.new(username: 'Chopper')
} 
  it 'can be instantiated' do
    expect(new_user.valid?).must_equal true
  end

  it 'will have the required fields' do
    new_user.save
    chopper = User.first
    
    expect(chopper).must_respond_to :username
  end

  describe 'relationships' do
    it 'can have many votes' do
      joseph = users(:joseph)

      joseph.votes.each do |vote|
        expect(vote).must_be_instance_of Vote
      end

      expect(joseph.votes.count).must_equal 2
    end
  end

  describe 'validations' do
    it 'validates when there is a username provided' do
      adding_user = User.new(username: "Pepper Pig")

      expect(adding_user.valid?).must_equal true
    end

    it 'will not validate a user without username' do
      new_user.username = nil
      new_user.save

      expect(new_user.valid?).must_equal false
      expect(new_user.errors.messages).must_include :username
      expect(new_user.errors.messages[:username]).must_equal ["can't be blank"]
    end

    it 'must have a unique user name to create new user' do
      exisitng_user = User.new(username: 'Sharon Cheung')

      expect(exisitng_user.valid?).must_equal false
      expect(exisitng_user.errors.messages).must_include :username
      expect(exisitng_user.errors.messages[:username]).must_equal ["has already been taken"]
    end
  end
end
