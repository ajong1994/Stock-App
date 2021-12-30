require 'rails_helper'

RSpec.describe 'Trading Functions', type: :feature do
  before do
    create(:client)
    visit new_user_session_path
    fill_in 'user_email', with: 'test@user.com'
    fill_in 'user_password', with: 'qwerty12345'
    click_on ('Log in')
  end

  let (:iex_client) { IEX::Api::Client.new() }
  let (:stock_buy) { iex_client.quote('AAPL') }
  let (:stock_sell) { iex_client.quote('AAPL') }
  let (:trending) { iex_client.stock_market_list(:iexvolume)}
  let (:dummy_client) { Client.create!(
    email: 'testagain2@email.com',
    full_name: 'test again2',
    password: 'password'
   )}

  describe 'As a Client, I want to be able to search for a specific stock' do
    it 'On the /trade page, I should be able to search for a specific stock and be redirected' do
        visit trade_path
        fill_in 'symbol', with: 'AAPL'
        click_on ('Search')

        expect(page).to have_content('AAPL')
    end
  end

  describe 'On the trade page, I want to see a summary of my current stocks' do
    it 'I should see a summarized table of my net stock holdings' do
        visit stock_path(symbol:'AAPL')
        fill_in 'buy_qty', with: '2'
        click_on ('Buy')

        visit stock_path(symbol:'AAPL')
        fill_in 'sell_qty', with: '1'
        click_on ('Sell')

        temp_total_cost = Client.find_by(email:'test@user.com').transactions.where(security_symbol: 'AAPL', transaction_type: 'buy').sum('total_security_cost')
        visit trade_path

        expect(page).to have_content('Apple Inc')
        expect(page).to have_content('AAPL')
        expect(page).to have_content('1')
        expect(page).to have_content(ActiveSupport::NumberHelper.number_to_currency(temp_total_cost - (temp_total_cost / 2)))

    end
   end

   describe 'I want to be able to buy stocks' do
        context 'Valid transaction' do
            it 'on the /stock page with a particular symbol query, user can sell stock by inputting quantity' do
                visit stock_path(symbol:'AAPL')
                fill_in 'buy_qty', with: '1'
                click_on ('Buy')

                expect(page).to have_content('Purchase was successful.')
            end
        end 

        context 'Invalid transaction' do
            it 'on the /stock page with a particular symbol query, sale will fail when quantity is not enough' do
                visit stock_path(symbol:'AAPL')
                fill_in 'buy_qty', with: '500'
                click_on ('Buy')

                expect(page).to have_content('Current account balance is insufficient.')
            end

            it 'on the /stock page with a particular symbol query, sale will fail when quantity is negative' do
                visit stock_path(symbol:'AAPL')
                fill_in 'buy_qty', with: '-1'
                click_on ('Buy')

                expect(page).to have_content('Quantity cannot be negative.')
            end
        end 
   end

   describe 'I want to be able to sell stocks' do
    context 'Valid transaction' do
        it 'on the /stock page with a particular symbol query, user can sell stock by inputting quantity' do
            visit stock_path(symbol:'AAPL')
            fill_in 'buy_qty', with: '3'
            click_on ('Buy')

            visit stock_path(symbol:'AAPL')
            fill_in 'sell_qty', with: '2'
            click_on ('Sell')

            expect(page).to have_content('Sale was successful.')
        end
    end 

    context 'Invalid transaction' do
        it 'on the /stock page with a particular symbol query, purchase will fail when balance is not enough' do
            visit stock_path(symbol:'AAPL')
            fill_in 'sell_qty', with: '500'
            click_on ('Sell')

            expect(page).to have_content('Current stock quantity is insufficient.')
        end

        it 'on the /stock page with a particular symbol query, purchase will fail when quantity is negative' do
            visit stock_path(symbol:'AAPL')
            fill_in 'sell_qty', with: '-1'
            click_on ('Sell')

            expect(page).to have_content('Quantity cannot be negative.')
        end
    end 
end
end


