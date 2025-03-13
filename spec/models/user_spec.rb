require 'rails_helper'

RSpec.describe User, type: :model do
  include FactoryBot::Syntax::Methods

  #pending "add some examples to (or delete) #{__FILE__}"

  context 'validation of subscribed-user creation' do

    it 'ensures that the registered user has a first name' do
      user = User.new(last_name: 'last', email: 'sample@gmail.com',password: 'supersecurepassword', guest: 'false').save
      expect(user).to eq(false)

    end
    
    it 'ensures that the registered user has a last name' do
      user = User.new(first_name: 'First', email: 'sample@gmail.com', password: 'supersecurepassword', guest: 'false').save
      expect(user).to eq(false)

    end

    it 'ensures that the registered user has an email address' do
      user = User.new(first_name: 'first', last_name: 'last', password: 'supersecurepassword' , guest: 'false').save
      expect(user).to eq(false)

    end

    it 'should save into db when user is guest' do 
      user = User.new(first_name: 'first', last_name: 'last', email: 'someone@gmail.com', password: 'supersecurepassword', guest: true).save
      expect(user).to eq(true)

    end

    it 'should save into db when user is registered' do 
      user = User.new(first_name: 'first', last_name: 'last', email: 'someone@gmail.com', password: 'supersecurepassword', guest: false).save
      expect(user).to eq(true)
    end

    it 'ensures that a registered user must have a password' do
      user = User.new(first_name: 'First', last_name: 'Last', email: 'sample@gmail.com', guest: false)
      expect(user.valid?).to eq(false)  
    end
    
    it 'ensures that a guest user can be created without a password' do
      user = User.new(first_name: 'First', last_name: 'Last', email: 'guest@gmail.com', guest: true)
      expect(user.valid?).to eq(true)  # Should pass because password: 'supersecurepassword' is not required
    end

    it 'ensures that password is securely stored' do
      user = User.create!(first_name: 'First', last_name: 'Last', email: 'secure@gmail.com', password: 'supersecurepassword' ,guest: false)
      expect(user.password_digest).not_to eq('supersecurepassword')  # Password should be hashed
      expect(user.password_digest).to be_present
      #ensure bycrypt format for hashing is valid
      expect(user.password_digest).to match(/^\$2[ayb]\$.{56}$/)

    end


  end
    
  context 'guest vs registered users scope' do
    let(:user) { build(:random_user) } 
    
    let(:guest_params) { { guest: true, password: nil } }
    let(:registered_params) { { guest: false, password: 'supersecurepassword' } }
  
    before(:each) do
      # Create 3 guest users
      create(:user, **guest_params) 
      create(:user, **guest_params)
      create(:user, **guest_params)
  
      # Create 2 registered users
      create(:user, **registered_params)
      create(:user, **registered_params)
    end
  

  
  
    it 'should return guests count' do
      expect(User.guests.size).to eq(3)
    end

    it 'should return registered users count' do
      expect(User.registered_users.size).to eq(2)
    end
  end



end
