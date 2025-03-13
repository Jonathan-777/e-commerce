class User < ApplicationRecord

    before_validation :handle_guest_behavior
  
    has_secure_password validations: false # If we don’t disable built in validations, Rails always requires a password, even for guests.Since we conditionally enforce password validation in our custom validation, we must turn off the default one
    
    scope :registered_users, -> {where(guest: false)}
    scope :guests, -> {where(guest: true)}
    validates :first_name, presence: true
    validates :last_name, presence:true
    validates :email, presence: true, uniqueness: true
    validates :guest, inclusion: { in: [true, false] }
    validates :password, presence: true, if: -> { guest == false }


    private

    def handle_guest_behavior
        if guest
          # Remove password-related attributes for guests
          self.password_digest = nil
          @password = nil
          @password_confirmation = nil
        end
    end

end
