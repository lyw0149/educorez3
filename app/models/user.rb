class User < ActiveRecord::Base
  rolify
	include Authority::UserAbilities
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,:confirmable,
         :rememberable, :trackable, :validatable,
					:omniauthable
	has_many :posts, dependent: :destroy
	has_many :identities, dependent: :destroy
	has_many :extras, dependent: :destroy

	has_attached_file :image, styles: { medium: "300x300>", thumb: "100x100>" }, default_url: "/images/:style/missing.png"
  validates_attachment_content_type :image, content_type: /\Aimage\/.*\Z/

	after_create :set_default_role
  TEMP_EMAIL_PREFIX = 'change@me'
  TEMP_EMAIL_REGEX = /\Achange@me/
 def email_verified?
    self.email && self.email !~ TEMP_EMAIL_REGEX
  end
def self.from_omniauth(auth)
  where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
    user.email = auth.info.email
    user.password = Devise.friendly_token[0,20]
    user.name = auth.info.name   # assuming the user model has a name
    user.image = auth.info.image # assuming the user model has an image
  end
end
	 def self.find_for_oauth(auth, signed_in_resource = nil)

    # Get the identity and user if they exist
    identity = Identity.find_for_oauth(auth)

    # If a signed_in_resource is provided it always overrides the existing user
    # to prevent the identity being locked with accidentally created accounts.
    # Note that this may leave zombie accounts (with no associated identity) which
    # can be cleaned up at a later date.
    user = signed_in_resource ? signed_in_resource : identity.user

    # Create the user if needed
    if user.nil?

      # Get the existing user by email if the provider gives us a verified email.
      # If no verified email was provided we assign a temporary email and ask the
      # user to verify it on the next step via UsersController.finish_signup
      email_is_verified = auth.info.email && (auth.info.verified || auth.info.verified_email)
      email = auth.info.email if email_is_verified
      user = User.where(:email => email).first if email

      # Create the user if it's a new registration
      if user.nil?
				if !auth.info.email.nil?
						user = User.new(
						name: auth.info.name || auth.extra.nickname ||  auth.uid,
						email: User.where(:email => auth.info.email).first ? "#{TEMP_EMAIL_PREFIX}-#{auth.uid}-#{auth.provider}.com" : auth.info.email,
						image: auth.info.image ? auth.info.image : nil,
						password: Devise.friendly_token[0,20]
						)
				else
						user = User.new(
						name: auth.info.name || auth.extra.nickname ||  auth.uid,
						email: "#{TEMP_EMAIL_PREFIX}-#{auth.uid}-#{auth.provider}.com",
						image: auth.info.image ? auth.info.image : nil,
						password: Devise.friendly_token[0,20]
						)
				end
        user.skip_confirmation!
        user.save!
      end
    end

    # Associate the identity with the user if needed
    if identity.user != user
      identity.user = user
      identity.save!
    end

    user

  end
	private
  def set_default_role
    add_role :user
  end
end
