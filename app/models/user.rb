class User < ActiveRecord::Base
  rolify
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :invitable, :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  scope :invitation_pending, -> { where(sign_in_count: 0, invitation_sent_at: nil) }

  has_many :blog_posts, :as => "blogger", :class_name => "Blogit::Post"
  has_paper_trail
  acts_as_messageable

  has_attached_file :avatar, styles: {
    thumb: '50x50>',
    square: '200x200#',
    medium: '300x300>'
  }, :s3_protocol => :https

  has_many :space_rentals
  has_many :rentals, :source => :space, :through => :space_rentals

  strip_attributes :collapse_spaces => true
  validates :email, :uniqueness => { :case_sensitive => false }
  validates_email :email # client side validation of email address

  # override Devise method
  # no password is required when the account is created; validate password when the user sets one
  validates_confirmation_of :password
  #def password_required?
  #  if !persisted?
  #    !(password != "")
  #  else
  #    !password.nil? || !password_confirmation.nil?
  #  end
  #end

  def send_reset_password_instructions
    if self.confirmed?
      super
    else
      errors.add :base, "You must receive an invitation before you set your password."
    end
  end

  def mailboxer_email(object)
    # TODO check user preferences to see if they want notifications
    # if wants_notifications
    return self.email
    # else
    #   nil
  end
  
end
