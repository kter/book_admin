class Book < ActiveRecord::Base

  scope :costly, -> { where("price > ?", 3000) }
  scope :written_about, ->(theme) { where("name like ?", "%#{theme}%") }
  default_scope -> {order("published_on desc") }
end
