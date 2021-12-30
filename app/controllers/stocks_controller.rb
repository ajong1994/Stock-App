class StocksController < ApplicationController
    before_action :authenticate_user!
    before_action :instantiate_client
    
    def index
        @trending = @client.stock_market_list(:iexvolume)
        @stocks = current_user.current_stocks
        @latest_price = {} 
        @stocks.each do |s|
            @latest_price[s.security_symbol] = @client.quote(s.security_symbol).latest_price
        end
    end

    def show
        #Begin and rescue SymbolNotFound error if ticker does not exist
        begin
            @stock = @client.quote(params[:symbol])
        rescue 
            respond_to do |format|
                format.html { redirect_to trade_path, notice: "Sorry, we can't find a stock with that symbol." }
            end
        end
    end

    def buy 
        qty = params[:buy_qty].to_i
        quote = @client.quote(params[:buy_symbol])
        price = quote.latest_price.to_d
        total_cost = qty * price
        balance = current_user.balance == nil ? 0.00 : current_user.balance
        valid = false
        if (balance > total_cost) && qty > 0
            transaction = current_user.transactions.create(
                transaction_type: 'buy',
                security_name: quote.company_name,
                security_symbol: quote.symbol,
                quantity: qty,
                security_price: price,
                total_security_cost: total_cost,
                user_id: current_user.id
            )
            if (transaction && transaction.save) && current_user.current_stocks.find_by(security_symbol: quote.symbol)
                purchased_stock = current_user.current_stocks.find_by(security_symbol: quote.symbol)
                purchased_stock.update(
                    quantity: purchased_stock.quantity + qty,
                    total_security_cost: purchased_stock.total_security_cost + total_cost,
                )
                valid = true 
            else
                purchased_stock = current_user.current_stocks.create(
                    security_symbol: quote.symbol,
                    security_name: quote.company_name,
                    quantity: qty,
                    total_security_cost: total_cost,
                    user_id: current_user.id
                ) 
                valid = true
            end 
        end 
        respond_to do |format|
            #Need to validation .create and .update presence because otherwise, save will throw an error
            if  valid == true 
                current_user.update(
                    balance: balance - total_cost
                )
                format.html { redirect_to request.referrer, notice: "Purchase was successful." }
            elsif balance < total_cost
                format.html { redirect_to request.referrer, notice: "Current account balance is insufficient." }
            elsif qty < 0 
                format.html { redirect_to request.referrer, notice: "Quantity cannot be negative." }
            else
                format.html { redirect_to request.referrer, notice: "Something went wrong with your request." }
            end
        end
    end

    def sell 
        qty = params[:sell_qty].to_i
        quote = @client.quote(params[:sell_symbol])
        price = quote.latest_price.to_d
        total_price = qty * price
        sellable_qty = current_user.current_stocks.find_by(security_symbol: quote.symbol) == nil ? 0 : current_user.current_stocks.find_by(security_symbol: quote.symbol).quantity
        valid = false  
        if (sellable_qty >= qty) && qty > 0
            transaction = current_user.transactions.create(
                transaction_type: 'sell',
                security_name: quote.company_name,
                security_symbol: quote.symbol,
                quantity: -qty,
                security_price: price,
                total_security_cost: -total_price,
                user_id: current_user.id
            )
            if (transaction && transaction.save) 
                purchased_stock = current_user.current_stocks.find_by(security_symbol: quote.symbol)
                purchased_stock.update(
                    quantity: purchased_stock.quantity - qty,
                    total_security_cost: purchased_stock.total_security_cost - ((purchased_stock.total_security_cost / purchased_stock.quantity) * qty)
                )
                valid = true 
            end 
        end 
        respond_to do |format|
            if valid == true 
                current_user.update(
                    balance: (current_user.balance || 0.00) + total_price
                )
                format.html { redirect_to request.referrer, notice: "Sale was successful." }
            elsif sellable_qty < qty
                format.html { redirect_to request.referrer, notice: "Current stock quantity is insufficient." }
            elsif qty < 0 
                format.html { redirect_to request.referrer, notice: "Quantity cannot be negative." }
            else
                format.html { redirect_to request.referrer, notice: "Something went wrong with your request." }
            end
        end

    end 

    private

    def instantiate_client
        @client = IEX::Api::Client.new()
    end
end
