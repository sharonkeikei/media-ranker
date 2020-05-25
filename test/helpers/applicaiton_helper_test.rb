# test/helpers/application_helper_test.rb
require "test_helper"

describe ApplicationHelper, :helper do
  describe 'flash_class(level)' do
    it 'will return the correct flash message bootstrap classes' do
      flash = 'warning'
      
      result = flash_class(flash)
      expect(result).must_equal "alert-warning"
    end
  end
end