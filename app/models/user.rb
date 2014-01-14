class User < ActiveRecord::Base
  has_many :microposts, dependent: :destroy
  has_many :relationships, foreign_key: "follower_id", dependent: :destroy
  has_many :reverse_relationships, foreign_key: "followed_id",
                                   class_name: "Relationship",
                                   dependent: :destroy
  has_many :followers, through: :reverse_relationships, source: :follower
  has_many :followed_users, through: :relationships, source: :followed

  before_save { self.email = email.downcase }
  before_create :create_remember_token
  # before_create { :generate_token(:auth_token) }

  validates :name, presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, format: { with: VALID_EMAIL_REGEX },
                           uniqueness: { case_sensitive: false }

  has_secure_password
  validates :email, length: { minimum: 6 }


  def User.new_remember_token
    SecureRandom.urlsafe_base64
  end

  def User.encrypt(token)
    Digest::SHA1.hexdigest(token.to_s)
  end

  def feed
    # Micropost.where("user_id = ?", id)
    Micropost.from_users_followed_by(self)
  end

  def follow!(other_user)
    relationships.create!(followed_id: other_user.id)  
  end

  def following?(other_user)
    relationships.find_by(followed_id: other_user.id)
  end

  def unfollow!(other_user)
    relationships.find_by(followed_id: other_user.id).destroy!
  end

  # def generate_token(column)
  #   begin
  #     self[column] = SecureRandom.urlsafe_base64
  #   end while User.exists?(column => self[column])
  # end
  def send_password_reset
    create_password_reset_token
    self.password_reset_sent_at = Time.zone.now
    save!
    UserMailer.password_reset(self).deliver
  end

  def send_account_activation
    create_activation_token
    save!
    UserMailer.account_activation(self).deliver
  end

  def send_registration_confirmation
    UserMailer.registration_confirmation(self).deliver
  end

private
  def create_remember_token
    self.remember_token = User.encrypt(User.new_remember_token)
  end
  
  def create_password_reset_token
    self.password_reset_token = User.encrypt(User.new_remember_token)
  end

  def create_activation_token
    self.activation_token = User.encrypt(User.new_remember_token)
  end  

end
