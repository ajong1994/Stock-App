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
        qty = params[:buy_qty].to_i
        quote = @client.quote(params[:buy_symbol])
        price = quote.latest_price.to_d
        total_cost = qty * price
        balance = current_user.balance == nil ? 0.00 : current_user.balance
        if (balance > total_cost) && qty > 0
            transaction = current_user.transactions.create(
                transaction_type: 'buy',
                security_symbol: quote.symbol,
                quantity: qty,
                security_price: price,
                total_security_cost: total_cost,
                user_id: current_user.id
            )
        end 
        respond_to do |format|
            if (transaction && transaction.save) && (balance > total_cost) && (qty > 0)
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
        sellable_qty = current_user.transactions.where(security_symbol: quote.symbol).sum(:quantity) || 0 
        if (sellable_qty >= qty) && qty > 0
            transaction = current_user.transactions.create(
                transaction_type: 'sell',
                security_symbol: quote.symbol,
                quantity: -qty,
                security_price: price,
                total_security_cost: -total_price,
                user_id: current_user.id
            )
        end 
        respond_to do |format|
            if (transaction && transaction.save) && (sellable_qty >= qty) && qty > 0
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
