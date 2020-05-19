require "test_helper"

describe Work do
  let (:new_work) {
    Work.new(title: 'Harry Potter 3', category: 'book')
} 

  describe "initialize" do
    it "can be instantiated" do
      expect(new_work.valid?).must_equal true
    end

    it 'will have the required fields' do
    new_work.save
    work = Work.first
    [:category, :title, :creator, :publication_year, :description].each do |field|
    # Assert
    expect(work).must_respond_to field
    end
    end
  end

  describe 'relations' do
    it 'can have many Vote' do
      work = works(:guardians)
      work.votes.each do |vote|
        expect(vote).must_be_instance_of Vote
      end

      expect(work.votes.count).must_equal 3
    end
  end

  describe 'validations' do
    it 'is valid when there is a title and a category' do
      # Act
      new_book = Work.new(title: 'Hello World Made Easy', category: 'book')
      # Assert
      expect(new_book.valid?).must_equal true
    end

    it 'fails validation when there is no title' do
      new_work.title = nil

      expect(new_work.valid?).must_equal false
      expect(new_work.errors.messages).must_include :title
      expect(new_work.errors.messages[:title]).must_equal ["can't be blank"]
    end

    it 'fails validation when the title already exits in same category' do
      # since yml file already has a title of 'Guardians of the Galaxy'
      new_movie = Work.new(title: "Guardians of the Galaxy", category: 'movie')

      expect(new_movie.valid?).must_equal false
      expect(new_movie.errors.messages).must_include :title
      expect(new_movie.errors.messages[:title]).must_equal ["has already been taken"]
    end 
  end

  describe 'custom methods' do
    describe 'self.sort_by_vote_order' do
      it 'will correctly return top ten according to the votes' do
        # four votes for asana, three votes for guardians, one vote for wall
        expect(Work.sort_by_vote_order[0].title).must_equal 'Yoga Asana'
        expect(Work.sort_by_vote_order[1].title).must_equal 'Guardians of the Galaxy'
        expect(Work.sort_by_vote_order[2].title).must_equal "The Great Wall"
      end

      it 'will return an empty array if there is no Works' do
        Work.all.each do |work|
          work.destroy
        end
        
        expect(Work.sort_by_vote_order.length).must_equal 0
        expect(Work.sort_by_vote_order).must_equal []
      end

      it 'will return according to their name if there is a tie' do
        Vote.create(user: users(:doggies), work: works(:guardians))

        expect(Work.sort_by_vote_order[0].title).must_equal 'Guardians of the Galaxy'        
      end
    end
    

    describe 'self.find_top_ten(category)' do
      it 'will return 10 work if there is enough work from same category and by votes count' do
        # movie has 11 from yml 
        expect(Work.find_top_ten(:movie).length).must_equal 10
        expect(Work.find_top_ten(:movie)[0].title).must_equal 'Guardians of the Galaxy'
      end

      it 'will return the number of work they have in the system accordingly' do
        # book has 3 from yml 
        expect(Work.find_top_ten(:book).length).must_equal 3
        expect(Work.find_top_ten(:book)[0].title).must_equal 'Yoga Asana'
      end

      it 'will return an empty array if there is no work in that category' do
        # no album on file
        expect(Work.find_top_ten(:album)).must_be_empty
      end
    end

    describe 'self.find_spotlight' do

      it 'can correctly return the highest voted work' do
        #'Guardians of the Galaxy' has the most vote from yml
        expect(Work.find_spotlight.title).must_equal 'Yoga Asana'
        expect(Work.find_spotlight.votes.count).must_equal 4
      end

      it 'will return nil if there is no Works data' do

        Work.all.each do |work|
          work.destroy
        end

        expect(Work.find_spotlight).must_equal nil
      end
    end
  end
end
