require 'rails_helper'

RSpec.describe Client, type: :request do

#   before :each do
#     sign_in create(:client)
#   end

  let!(:valid_params) {{
    email: "aji@modelrspec.com",
    password: 'sample_pass123',
    confirm_password: 'sample_pass123',
    full_name: 'Test Subject 1'
  }}

  describe 'GET /new' do
    it 'Returns successful header' do
      get new_user_registration_path
      expect(response).to be_successful
    end
  end

  describe 'POST /create' do
    it 'Returns successful header and redirects to root' do
      expect{post user_registration_path, params: { user: valid_params} }.to change(Client, :count).by(1)

      post user_registration_path, params: { user: { email: "aji3@modelrspec.com", password: 'sample_pass123', confirm_password: 'sample_pass123', full_name: 'Test Subject 10' }}
      expect(response).to redirect_to(root_path)
    end
  end

  describe 'GET /sign_in' do
    it 'Returns successful header' do
        get new_user_session_path
        expect(response).to be_successful
    end
  end

  describe 'POST /sign_in' do
    it 'Returns successful header and logs user in' do
        post user_session_path, params: { email: "test@user.com", password: "qwerty12345" }
        expect(response).to be_successful
    end
  end

  describe 'GET /transactions' do
    it 'Returns successful header' do
        get transactions_path
        expect(response).to be_successful
    end
  end

end

# 2. User
# User Story #1: As a User, I want to create an account
# User Story #2: As a User, I want to login my credentials so that I can access my account on the app
# User Story #3: As a User, I want to receive an email after my registration to see if my registration is successful
# User Story #4: As a User, I want to buy a stock from the stock market to add to my investment. Dropdown https://github.com/dblock/iex-ruby-client#get-symbols
# User Story #5: As a User, I want to see my trading history
# User Story #6: As a User, I want to receive an email to confirm my pending User Account signup. When admin approves my account
# User Story #7: As a User, I want to sell the stocks I bought
# User Story #8: As a User, I want to cash in (dummy