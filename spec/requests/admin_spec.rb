require 'rails_helper'

RSpec.describe Admin, type: :request do

  before :each do
    sign_in create(:admin)
  end

  let!(:valid_params) {{
    email: "aji@modelrspec.com",
    password: 'sample_pass123',
    full_name: 'Test Subject 1'
  }}

  let!(:test_client) {Client.create(email: "aji2@modelrspec.com", password: 'sample_pass123',full_name: 'Test Subject 4')}

  describe 'GET /new' do
    it 'Returns successful header' do
      get new_admin_user_path
      expect(response).to be_successful
    end
  end

  describe 'POST /create' do
    it 'Returns successful header and redirects to show' do
      expect{post admin_users_path, params: { client: valid_params }}.to change(Client, :count).by(1)

      post admin_users_path, params: { client: {email: "aji3@modelrspec.com", password: 'sample_pass123',full_name: 'Test Subject 10'}}
      client = Client.last
      expect(response).to redirect_to(admin_users_path)
    end
  end

  # describe 'GET /show' do
  #   it 'Returns successful header' do
  #     client = Client.last
  #     get admin_user_path(client.id)
  #     expect(response).to be_successful
  #   end
  # end

  describe 'GET /edit' do
    it 'Returns successful header and edit template' do
      client = Client.last
      get edit_admin_user_path(client.id)
      expect(response).to be_successful
    end
  end

  describe 'PATCH /create' do
    it 'Returns successful header and redirects to show template' do
      client = Client.last
      patch admin_user_path(client.id), params: { client: valid_params.merge!(full_name:'Test Subject 99') }
      client.reload
      expect(client.full_name).to eq('Test Subject 99')
      expect(response).to redirect_to(edit_admin_user_path(client.id))
    end
  end
  

  describe 'GET / users' do
    it 'Returns successful header and users template' do
      get admin_users_path
      expect(response).to be_successful
    end
  end
end

# 1. Admin
# User Story #1: As an Admin, I want to create a new user to manually add them to the app
# User Story #2: As an Admin, I want to edit a specific user to update his/her details: fullname
# User Story #3: As an Admin, I want to view a specific user to show his/her details: fullname, email
# User Story #4: As an Admin, I want to see all the users that registered in the app so I can track all the users and approve/reject them
