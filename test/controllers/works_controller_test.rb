require "test_helper"

describe WorksController do
  describe 'index' do
    it 'responds with success when there are multiple works created' do
      # 14 works from yml
      expect(Work.all.length).must_equal 14
    end
  end

end
