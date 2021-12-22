class StocksController < ApplicationController
    before_action :instantiate_client
    
    def index
        @stocks = @client.stock_market_list(:iexvolume)
    end

    def show
        #Begin and rescue SymbolNotFound error if ticker does not exist
        @stock = @client.quote(params[:symbol])
    end

    def buy 
        qty = params[:buy_qty]
        quote = @client.quote(params[:symbol])
        price = quote.latest_price
        total_cost = (qty * price).to_d
        balance = current_user.balance == nil ? 0.0 : current_user.balance
        puts balance
        if balance > total_cost
            transaction = current_user.Transaction.update(
                transaction_type: 'buy',
                security_symbol: quote.symbol,
                quantity: qty,
                security_price: quote.latest_price,
                total_security_cost: total_cost,
                user_id: current_user.id
            )
        end 
        respond_to do |format|
            if (transaction && transaction.save) && (balance > total_cost) 
                current_user.update(
                    balance: balance - total_cost
                )
                format.html { redirect_to request.referrer, notice: "Purchase was successful." }
            elsif balance < total_cost
                format.html { redirect_to request.referrer, notice: "Current account balance is insufficient." }
            else
                format.html { redirect_to request.referrer, notice: "Something went wrong with your request." }
            end
        end
    end

    def sell 
        qty = params[:buy_qty]
        quote = @client.quote(params[:symbol])
        price = quote.latest_price
        total_cost = (qty * price).to_d
        balance = current_user.balance == nil ? 0.0 : current_user.balance
        puts balance
        if balance > total_cost
            transaction = current_user.Transaction.update(
                transaction_type: 'buy',
                security_symbol: quote.symbol,
                quantity: qty,
                security_price: quote.latest_price,
                total_security_cost: total_cost,
                user_id: current_user.id
            )
        end 
        respond_to do |format|
            if (transaction && transaction.save) && (balance > total_cost) 
                current_user.update(
                    balance: balance - total_cost
                )
                format.html { redirect_to request.referrer, notice: "Purchase was successful." }
            elsif balance < total_cost
                format.html { redirect_to request.referrer, notice: "Current account balance is insufficient." }
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
