require 'rails_helper'

RSpec.describe Admin, type: :model do
  let(:complete_params) {{
    email: "aji@modelrspec.com",
    password: 'sample_pass123',
    full_name: 'Test Subject 1'
  }}
  let(:missing_email_params) {{
    password: 'sample_pass',
    full_name: 'Test Subject 1'
  }}
  let(:missing_name_params) {{
    email: 'Aji@modelrspec.com',
    password: 'sample_pass',
  }}

  describe 'Can create user manually' do
    context 'Valid parameters' do
      it 'User count should increase on create' do
        expect{Client.create(complete_params)}.to change(Client,:count).by(1)
      end
    end

    context 'Invalid parameters' do
      it 'User count should not increase if email is missing' do
        expect{Client.create(missing_email_params)}.to change(Client,:count).by(0)
      end

      it 'User count should not increase if full name is missing' do
        expect{Client.create(missing_name_params)}.to change(Client,:count).by(0)
      end
    end
  end

  describe 'Can view specific users' do
    let!(:client) {Client.create(complete_params)}

    it 'User properties should be accessible after creation if provided correct ID' do
      expect(Client.find_by(email: 'aji@modelrspec.com')).to be_truthy
      expect(Client.find_by(email: 'aji@modelrspec.com').full_name).to eq('Test Subject 1')
    end
  end

  describe 'Can edit user information' do
    let!(:client) {Client.create(complete_params)}

    it 'User email should update' do
      Client.find_by(email: 'aji@modelrspec.com').update(email:'aji2@modelrspec.com')
      expect(Client.find_by(email: 'aji2@modelrspec.com')).to be_truthy
    end

    it 'User full name should update' do
      Client.find_by(full_name:'Test Subject 1').update(full_name:'Test Subject 2')
      expect(Client.find_by(full_name:'Test Subject 2').email).to be_truthy
    end

    it 'User password should update' do
      expect(Client.find_by(full_name:'Test Subject 1').update(password:'sample2_pass')).to be true
    end
  end

  describe 'Can access all of the users' do
    before :each do
      Client.create(complete_params)
      Client.create(full_name: 'Test Subject 2', email:'aji2@modelrspec.com', password:'sample_test')
      Client.create(full_name: 'Test Subject 3', email:'aji3@modelrspec.com', password:'sample_test')
    end

    it 'List of users should match created samples' do
      expect(Client.count).to eq(3)
      expect(Client.all.first.full_name).to eq('Test Subject 1')
      expect(Client.all.last.full_name).to eq('Test Subject 3')

    end
  end

  describe 'Can edit client status' do
    let!(:client) {Client.create(complete_params)}

    it 'Registration property of client should be updatable to active' do
      Client.find_by(email: 'aji@modelrspec.com').update(registration_status:'Active')
      expect(Client.all.first.registration_status).to eq('Active')
    end

    it 'Registration property of client should be updatable to rejected' do
      Client.find_by(email: 'aji@modelrspec.com').update(registration_status:'Rejected')
      expect(Client.all.first.registration_status).to eq('Rejected')
    end
  end
end

# 1. Admin
# User Story #1: As an Admin, I want to create a new user to manually add them to the app
# User Story #2: As an Admin, I want to edit a specific user to update his/her details: fullname
# User Story #3: As an Admin, I want to view a specific user to show his/her details: fullname, email
# User Story #4: As an Admin, I want to see all the users that registered in the app so I can track all the users and approve/reject them
