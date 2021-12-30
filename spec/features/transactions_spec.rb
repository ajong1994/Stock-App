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

#   describe '#5: As a User, I want to edit a task to update task\'s details.' do
#     it 'On the /edit path, editing Task Name should lead to a success message' do
#         visit edit_category_task_path(1, 1)
#         fill_in 'task_name', with: 'Sample Task 2'
#         click_on ('Update Task')
#         expect(page).to have_content('Task was successfully updated.')
#         expect(page).to have_content('Sample Task 2')
#     end

#     it 'On the /edit path, editing Task Body should lead to a success message' do
#         visit edit_category_task_path(1, 1)
#         fill_in 'task_body', with: 'Placeholder Body'
#         click_on ('Update Task')
#         expect(page).to have_content('Task was successfully updated.')
#         expect(page).to have_content('Sample Task')
#         expect(page).to have_content('Placeholder Body')
#     end

#     it 'On the /edit path, editing Task Date should lead to a success message' do
#         visit edit_category_task_path(1, 1)
#         fill_in 'task_task_date', with: Date.tomorrow()
#         click_on ('Update Task')
#         expect(page).to have_content('Task was successfully updated.')
#         expect(page).to have_content(Date.tomorrow())
#     end

#   end

#   describe '#6: As a User, I want to view a task to show task\'s details.' do
#     it 'When the user is on the category page, clicking the show link on any of the tasks should display the task\'s details' do
#         visit category_path(1)
#         click_on ('Show')
#         expect(page).to have_content('Sample Task')
#         expect(page).to have_content(Date.today())
#         expect(find_link('Edit').visible?).to eq(true)
#     end
#   end

#   describe '#7: As a User, I want to delete a task to lessen my unnecessary daily tasks.' do
#     it 'Page should redirect and delete success message should display when delete button is clicked' do
#         visit category_path(1)
#         click_on ('Delete')
#         expect(page).to have_content('Task was successfully destroyed.')
#         expect(page).to have_content('Test Category')
#         expect(find_link('New Task').visible?).to eq(true)
#     end
#   end

#   describe '#8: As a User, I want to view my tasks for today for me to remind what are my priorities for today.' do
#     it 'When accessing the category page, the tasks should be divided into tasks for today and non-urgent tasks' do
#         visit category_path(1)
#         expect(page).to have_content('Tasks Today')
#         expect(page).to have_content(Date.today())
#     end
#   end

end

# User Story #5: As a User, I want to see my trading history

# User Story #8: As a User, I want to cash in (dummy
