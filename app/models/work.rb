class Work < ApplicationRecord
  has_many :votes, dependent: :destroy
  validates :title, presence: true, uniqueness: true
  validates :category, presence: true

  def self.sort_by_vote_order
    work = Work.all
    return work.sort_by{|work| work.votes.count}.reverse
  end

  def self.find_top_ten(category)
    work_by_category = Work.where(category: category).sort_by{|work| work.votes.count}.reverse
    return work_by_category[0..10]
  end

  def self.find_spotlight 
    works = Work.all
    return works.sort_by_vote_order.first
  end
end
