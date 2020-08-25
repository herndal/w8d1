# == Schema Information
#
# Table name: users
#
#  id              :bigint           not null, primary key
#  name            :string           not null
#  password_digest :string           not null
#  session_token   :string           not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
class User < ApplicationRecord
    attr_reader :password
    after_initialize :ensure_session_token
    validates :name, :password_digest, :session_token, presence: true 
    validates :password, length: { minimum: 6, allow_nil: true }
    validates :session_token, :name, uniqueness: true 

    before_validation :ensure_session_token

    def self.find_by_credentials(username, password)
        user = User.find_by(name: username)
        user.try(:is_password?, password) ? user : nil
    end

    def self.generate_session_token
        SecureRandom.urlsafe_base64
    end

    has_many :subs,
        foreign_key: :moderator_id,
        primary_key: :id,
        class_name: :Sub

    def is_password?(password)
        BCrypt::Password.new(self.password_digest).is_password?(password)
    end

    def password=(password)
        @password = password
        self.password_digest = BCrypt::Password.create(password)
    end

    def reset_session_token!
        self.session_token = self.class.generate_session_token
        self.save
        self.session_token
    end
    
    private

    def ensure_session_token
        self.session_token ||= self.class.generate_session_token
    end
end
