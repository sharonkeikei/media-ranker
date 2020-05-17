class Work < ApplicationRecord
  has_many :votes, dependent: :destroy
end
