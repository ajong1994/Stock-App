require 'rails_helper'

RSpec.describe Transaction, type: :feature do
  before do
    create(:client)
    visit new_user_session_path
    fill_in 'user_email', with: 'test@user.com'
    fill_in 'user_password', with: 'qwerty12345'
    click_on ('Log in')
  end

  let!(:transaction_buy) {
      Client.last.transactions.create(
        transaction_type: 'buy',
        security_name: 'Apple Incorporated Inc.',
        security_symbol: 'APPL',
        quantity: '2',
        security_price: '160.2',
        total_security_cost: '320.4',
        user_id: Client.last.id
      )
  }

  let!(:transaction_sell) {
    Client.last.transactions.create(
      transaction_type: 'sell',
      security_name: 'Apple Incorporated Inc.',
      security_symbol: 'APPL',
      quantity: '-1',
      security_price: '150.0',
      total_security_cost: '-150.0',
      user_id: Client.last.id
    )
}

  describe 'As a Client, I want to see my trading history' do
    it 'On the /transactions page, I should see the buy transactions' do
        visit transactions_path
        expect(page).to have_content('Apple Incorporated Inc.')
        expect(page).to have_content('APPL')
        expect(page).to have_content('BUY')
        expect(page).to have_content('2')
        expect(page).to have_content('160.2')
        expect(page).to have_content('320.4')
    end

    it 'On the /transactions page, I should see the sell transactions' do
        visit transactions_path
        expect(page).to have_content('Apple Incorporated Inc.')
        expect(page).to have_content('APPL')
        expect(page).to have_content('SELL')
        expect(page).to have_content('-1')
        expect(page).to have_content('150.0')
        expect(page).to have_content('-150.0')
    end

  end

  describe 'As a User, I want to cash in (dummy)' do
    it 'On the /cash_in page, I can input a value to deposit to my virtual balance' do
        visit cash_in_path
        fill_in 'amount', with: '5000'
        click_on ('Cash In')
        expect(page).to have_content('Cash In was successful.')
        expect(page).to have_content('Current balance: $5,000.00')
    end
   end
end

