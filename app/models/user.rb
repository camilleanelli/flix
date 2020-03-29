class User < ApplicationRecord
  has_secure_password

  before_save :username_lowercase
  before_save :email_lowercase

  has_many :reviews, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :favorite_movies, through: :favorites, source: :movie
  validates :name, presence: true
  validates :email, presence: true, format: { with: /\S+@\S+/ }, uniqueness: true
  # validates :password, length: { minimum: 10, allow_blank: true }
  validates :username, format: { with: /\A[A-Z0-9]+\z/i }, uniqueness: { case_sensitive: false }

  scope :by_name, -> { order(:name)}
  scope :not_admin, -> { where(admin: false).by_name }

  def gravatar_id
    Digest::MD5::hexdigest(email.downcase)
  end

  def to_param
    username
  end

  private

  def username_lowercase
    self.username = username.parameterize
  end

  def email_lowercase
    self.email = email.downcase
  end
  
end
