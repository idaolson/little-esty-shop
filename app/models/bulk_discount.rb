class BulkDiscount < ApplicationRecord
  belongs_to :merchant

  validates :name, :discount, :threshold, presence: true

  def percentage
    discount * 100
  end

  def deduct_discount
  ((100 - percentage).to_f / 100)
  end
end
