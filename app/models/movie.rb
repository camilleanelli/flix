class Movie < ApplicationRecord
  before_save :set_slug
  
  has_many :reviews, -> { order(created_at: :desc) }, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :fans, through: :favorites, source: :user
  has_many :critics, through: :favorites, source: :user
  has_many :characterizations
  has_many :genres, through: :characterizations
  has_one_attached :main_image, dependent: :destroy

  validates :title, :released_on, :duration, presence: true
  validates :title, uniqueness: true
  validates :description, length: { minimum: 25 }
  validates :total_gross, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true
  validate :acceptable_image, if: :image_attached?

  scope :released, -> { where("released_on < ?", Time.now).order(released_on: :desc) }
  scope :upcoming, -> { where("released_on > ?", Time.now).order(released_on: :desc) }
  scope :recent, -> (number=5) { released.limit(number) }
  scope :hits, -> { released.where("total_gross >= 300000000").order(total_gross: :desc) }
  scope :flops, -> { released.where("total_gross < 225000000").order(total_gross: :asc) }
  scope :grossed_less_than, -> (number) { released.where("total_gross < ?", number) }
  scope :grossed_greater_than, -> (number) { released.where("total_gross > ?", number) }
  RATINGS = %w(G PG PG-13 R NC-17)
  validates :rating, inclusion: { in: RATINGS }

  def image_attached?
    main_image.attached? if main_image
  end

  def to_param
    slug
  end

  def average_stars_as_percent
    (average_stars/5) * 100
  end

  def average_stars
    reviews ? reviews.average(:stars).to_s.to_f : 0.0
  end

  def self.recently_added_movies
    order(creatad_at: :desc).limit(3)
  end

  def flop?
    total_gross.blank? || total_gross < 0.225e9
  end

  private 

  def acceptable_image
    errors.add(:main_image, "Image is too big") if main_image.blob.byte_size >= 1.megabyte
    errors.add(:main_image, "Image must be png, or jpeg") unless ["image/png", "image/jpeg"].include?(main_image.blob.content_type)
  end

  def set_slug
    self.slug = title.parameterize
  end
end
