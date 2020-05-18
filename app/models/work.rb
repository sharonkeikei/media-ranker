class Work < ApplicationRecord
  has_many :votes, dependent: :destroy
  validates :title, presence: true, uniqueness: true
  validates :category, presence: true

  def self.sort_by_vote_order
    work = Work.all
    return work.sort_by{|work| work.votes.count}.reverse
  end

  def self.find_top_ten(category)
    work_by_category = Work.where(category: category)
    return work_by_category.limit(10).sort_by{|work| work.votes.count}.reverse
  end

  def self.find_spotlight 
    works = Work.all
    return works.max_by{|work| work.votes.count}
  end
end
