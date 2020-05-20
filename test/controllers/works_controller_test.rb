require "test_helper"

describe WorksController do
  describe 'index' do
    it 'responds with success when there are multiple works created' do
      # 14 works from yml
      expect(Work.all.length).must_equal 14
      get works_path
      must_respond_with :success
    end
    
    it 'will responds with success when there are no work saved' do
      Work.all.each do |work|
        work.destroy
      end
      
      expect(Work.all.length).must_equal 0
      
      get works_path
      must_respond_with :success
    end  
  end

  describe 'show' do
    it 'will respond with success when showing an exisitng work' do
      # works(:split) from yml
      get work_path(works(:split).id)
      must_respond_with :success
    end

    it 'will redirect if a invalid work id is provided' do
      get work_path(-1)
      must_redirect_to works_path
    end
  end

  describe 'new' do
    it 'responds with success' do
      get new_work_path
      must_respond_with :success
    end
  end

  describe 'create' do
    it 'can create a new work with valid title provided' do
      work_param = {
        work: {
          title: 'Modern Family Movie',
          category: 'movie'
        }
      }

      expect{post works_path, params: work_param}.must_differ 'Work.count', 1
      expect(Work.last.title).must_equal work_param[:work][:title]
      expect(Work.last.category).must_equal work_param[:work][:category]
    end

    it 'does not creat new work if title is not provided' do
      work_param = {
        work: {
          publication_year: 2020,
          category: 'movie',
          creator: 'abc family'
        }
      }
      expect{post works_path, params: work_param}.wont_change 'Work.count'
    end

    it 'does not creat new work if cateogry is not provided' do
      work_param = {
        work: {
          title: 'Modern Family Movie',
          publication_year: 2020,
          creator: 'abc family'
        }
      }
      expect{post works_path, params: work_param}.wont_change 'Work.count'
    end
  end

  describe 'edt' do
    it 'responds with success when getting the edit page for a valid work' do
      get edit_work_path(works(:split).id)

      must_respond_with :success
    end

    it 'will redirect if there is no such a work' do
      get edit_work_path(-1)

      must_redirect_to works_path
    end
  end

  describe 'update' do
    it 'will correctly update an exisiting work' do
      new_work = Work.create(title: "Harry Potter 3", category: 'movie', creator: 'movie company', publication_year: 1999)

      update_params = {
        work: {
          title: 'Harry Potter 5',
          category: 'book',
          creator: 'JK Rowling',
          publication_year: 2000,
        }
      }

      expect {patch work_path(new_work.id), params: update_params}.wont_change 'Work.count'
      new_work.reload
      must_redirect_to work_path(new_work.id)
      expect(new_work.title).must_equal update_params[:work][:title]
      expect(new_work.category).must_equal update_params[:work][:category]
      expect(new_work.creator).must_equal update_params[:work][:creator]
      expect(new_work.publication_year).must_equal update_params[:work][:publication_year]
    end


    it 'does not update any work if given an invalid id and redirect' do
      invalid_update_id = -1
      update_params = {
        work: {
          title: 'Happy Feet',
          category: 'movie',
          publication_year: 2005,
        }
      }
      expect{patch work_path(-1), params: update_params}.wont_change 'Work.count'
      must_redirect_to works_path
    end

    it "won't update if the updating information doesn't pass the validation and render" do
      new_work = Work.create(title: "Harry Potter 3", category: 'movie', creator: 'movie company', publication_year: 1999)
      
      update_params = {
        work: {
          title: nil,
          category: 'book',
          creator: 'JK Rowling',
          publication_year: 2000,
        }
      }

      expect {patch work_path(new_work.id), params: update_params}.wont_change 'Work.count'

      new_work.reload
      
      expect(new_work.title).must_equal "Harry Potter 3"
      expect(new_work.category).must_equal 'movie'
      expect(new_work.creator).must_equal 'movie company'
      expect(new_work.publication_year).must_equal 1999
    end
  end

  describe 'destroy' do
    it 'will destroy work from database when the work exists and then redirect' do
      expect{delete work_path(works(:asana).id)}.must_differ 'Work.count', -1
      must_redirect_to works_path
    end

    it "does not change the db when the work does not exist, then redirect back to work list" do
      non_existing_id = -1

      expect{delete work_path(non_existing_id)}.wont_change 'Work.count'
      must_redirect_to works_path
    end
  end
end
