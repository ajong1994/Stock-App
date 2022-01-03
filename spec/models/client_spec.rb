require 'rails_helper'

RSpec.describe Client, type: :model do
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

  describe 'Can be viewed' do
    let!(:client) {Client.create(complete_params)}

    it 'User properties should be accessible after creation if provided correct ID' do
      expect(Client.find_by(email: 'aji@modelrspec.com')).to be_truthy
      expect(Client.find_by(email: 'aji@modelrspec.com').full_name).to eq('Test Subject 1')
    end
  end

  describe 'Can be edited' do
    let!(:client) {Client.create(complete_params)}

    it 'Client email should update' do
      Client.find_by(email: 'aji@modelrspec.com').update(email:'aji2@modelrspec.com')
      expect(Client.find_by(email: 'aji2@modelrspec.com')).to be_truthy
    end

    it 'Client full name should update' do
      Client.find_by(full_name:'Test Subject 1').update(full_name:'Test Subject 2')
      expect(Client.find_by(full_name:'Test Subject 2').email).to be_truthy
    end

    it 'Client password should update' do
      expect(Client.find_by(full_name:'Test Subject 1').update(password:'sample2_pass')).to be true
    end
  end

  describe 'List of clients can be accessed' do
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

  describe 'Registration status can be edited' do
    let!(:client) {Client.create(complete_params)}

    it 'Registration property of client should be updatable to active' do
      Client.find_by(email: 'aji@modelrspec.com').update(registration_status:'Active')
      expect(Client.all.last.registration_status).to eq('Active')
    end

    it 'Registration property of client should be updatable to rejected' do
      Client.find_by(email: 'aji@modelrspec.com').update(registration_status:'Rejected')
      expect(Client.all.last.registration_status).to eq('Rejected')
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