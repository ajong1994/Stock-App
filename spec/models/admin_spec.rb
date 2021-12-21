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

  describe 'Can be created' do
    context 'Valid parameters' do
      it 'User count should increase on create' do
        expect{Admin.create(complete_params)}.to change(Admin,:count).by(1)
      end
    end

    context 'Invalid parameters' do
      it 'User count should not increase if email is missing' do
        expect{Admin.create(missing_email_params)}.to change(Admin,:count).by(0)
      end

      it 'User count should not increase if full name is missing' do
        expect{Admin.create(missing_name_params)}.to change(Admin,:count).by(0)
      end
    end
  end

  describe 'Can be accessed' do
    let!(:admin) {Admin.create(complete_params)}

    it 'User properties should be accessible after creation if provided correct ID' do
      expect(Admin.find_by(email: 'aji@modelrspec.com')).to be_truthy
      expect(Admin.find_by(email: 'aji@modelrspec.com').full_name).to eq('Test Subject 1')
    end
  end

  describe 'Can be updated' do
    let!(:admin) {Admin.create(complete_params)}

    it 'Admin email should update' do
      Admin.find_by(email: 'aji@modelrspec.com').update(email:'aji2@modelrspec.com')
      expect(Admin.find_by(email: 'aji2@modelrspec.com')).to be_truthy
    end

    it 'Admin full name should update' do
      Admin.find_by(full_name:'Test Subject 1').update(full_name:'Test Subject 2')
      expect(Admin.find_by(full_name:'Test Subject 2').email).to be_truthy
    end

    it 'Admin password should update' do
      expect(Admin.find_by(full_name:'Test Subject 1').update(password:'sample2_pass')).to be true
    end
  end

  describe 'Can edit user type' do
    let!(:admin) {Admin.create(complete_params)}

    it 'User type can be changed to Admin' do
      Admin.find_by(email: 'aji@modelrspec.com').update(type:'Admin')
      expect(Admin.first.type).to eq('Admin')
    end

    it 'User type can be changed to Client' do
      Admin.find_by(email: 'aji@modelrspec.com').update(type:'Client')
      expect(Admin.first).to be nil
    end
  end
end

# 1. Admin
# User Story #1: As an Admin, I want to create a new user to manually add them to the app
# User Story #2: As an Admin, I want to edit a specific user to update his/her details: fullname
# User Story #3: As an Admin, I want to view a specific user to show his/her details: fullname, email
# User Story #4: As an Admin, I want to see all the users that registered in the app so I can track all the users and approve/reject them
