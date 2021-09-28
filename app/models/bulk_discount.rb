class BulkDiscount < ApplicationRecord
  belongs_to :merchant

  validates :name, :discount, :threshold, presence: true

  def percentage
    discount * 100
  end
end
