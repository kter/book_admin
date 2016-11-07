class Book < ActiveRecord::Base

  scope :costly, -> { where("price > ?", 3000) }
  scope :written_about, ->(theme) { where("name like ?", "%#{theme}%") }
  default_scope -> {order("published_on desc") }
  belongs_to :publisher
  has_many :book_authors
  has_many :authors, through: :book_authors

  validates :name, presence: true
  validates :name, length: { maximum: 15 }
  validates :price, numericality: { greater_than_or_equal_to: 0 }
  validate do |book|
    if book.name.include?("exercise")
      book.errors[:name] << "I don't like exercise."
    end
  end
  before_validation do |book|
    book.name = self.name.gsub(/Cat/) do |matched|
      "lovely #{matched}"
    end
  end
  before_validation :add_lovely_to_dog
  after_destroy do |book|
    Rails.logger.info "Book is deleted: #{book.attributes.inspect}"
  end
  after_destroy :if => :high_price? do |book|
    Rails.logger.warn "Book with high price is deleted: #{book.attributes.inspect}"
    Rails.logger.warn "Please check!!"
  end
  # book.reservation?でtrue or falseが取れたり、book.statusでreservationが取れたりできる。実際の数字はbook[:status]で取り出す
  enum status: %w(reservation now_on_sale end_of_print)
  # 明示的にDBで使用される数値を指定する場合
  #enum status: %w(reservation: 0, now_on_sale: 1, end_of_print: 2)

  private
    def add_lovely_to_dog
     self.name = self.name.gsub(/Dog/) do |matched|
       "lovely #{matched}"
     end
    end

    def high_price?
      self.price >= 5000
    end
end
