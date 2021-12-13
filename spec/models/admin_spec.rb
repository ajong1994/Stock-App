require 'rails_helper'

RSpec.describe Admin, type: :model do
  let(:complete_params) {{
    email: 'Aji@modelrspec.com',
    password: 'sample_pass',
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
  describe 'Admin can create user manually' do
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
end

# 1. Admin
# User Story #1: As an Admin, I want to create a new user to manually add them to the app
# User Story #2: As an Admin, I want to edit a specific user to update his/her details: fullname
# User Story #3: As an Admin, I want to view a specific user to show his/her details: fullname, email
# User Story #4: As an Admin, I want to see all the users that registered in the app so I can track all the users and approve/reject them
