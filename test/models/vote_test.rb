require "test_helper"

describe Vote do
  let (:new_user) {
    User.new(username: 'Minnie Mouse')
  } 
  let (:new_work) {
    Work.new(title: 'Supersoul conversation', category: 'book', creator: "Oprah Winfrey")
  } 
  let (:new_vote) {
    Vote.new(user: new_user, work: new_work)
  }
  
  describe'instantize' do
    it 'can be instantiated' do
      expect(new_vote.valid?).must_equal true
    end

    it 'will have the required field' do
      new_vote.save
      vote = Vote.first

      [:user, :work].each do |field|
        expect(vote).must_respond_to field
      end
    end
  end

  describe 'relationship' do
    it 'belongs to a user and a work' do
      vote = votes(:two)
      
      expect(vote.user).must_be_instance_of User
      expect(vote.work).must_be_instance_of Work
      expect(vote.user.username).must_equal 'Sharon Cheung'
      expect(vote.work.title).must_equal  "Guardians of the Galaxy"
    end
  end


  describe 'validations' do
    it 'will validate a vote if the user and work' do
      adding_vote = Vote.create(user_id: (users(:sharon).id), work_id: (works(:start).id) )

      expect(adding_vote.valid?).must_equal true
    end

    it 'will not valid a vote if user is not provided' do
      adding_vote = Vote.create(user_id: nil , work_id: (works(:start).id) )

      expect(adding_vote.valid?).must_equal false
      expect(adding_vote.errors.messages).must_include :user
      expect(adding_vote.errors.messages[:user]).must_equal ["must exist"]
    end

    it 'will not valid a vote if work is not provided' do
      adding_vote = Vote.create(user_id: (users(:sharon).id), work_id: nil )

      expect(adding_vote.valid?).must_equal false
      expect(adding_vote.errors.messages).must_include :work
      expect(adding_vote.errors.messages[:work]).must_equal ["must exist"]
    end
  end

  describe 'custom method' do
    describe 'self.check_exisiting_vote(current_user_id, work_id)' do

      it 'will return true if there is already an exisitng vote for that specific user and work' do
        expect(Vote.check_exisiting_vote( users(:sharon).id, works(:asana).id ) ).must_equal true
      end

      it 'will return true if there is already an exisitng vote for that specific user and work' do
        expect(Vote.check_exisiting_vote( users(:doggies).id, works(:sing).id ) ).must_equal false
      end
    end
  end
end
