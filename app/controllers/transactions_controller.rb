class TransactionsController < ApplicationController
  before_action :set_transaction, only: %i[ show edit update destroy ]

  # GET /transactions or /transactions.json
  def index
    @transactions = Transaction.all
  end

  # GET /transactions/1 or /transactions/1.json
  def show
  end

  # GET /transactions/new
  def new
  end

  # GET /transactions/1/edit
  def edit
  end

  # POST /transactions or /transactions.json
  def create
    amount = transaction_params[:amount].to_d
    cash_in = current_user.transactions.create(
        transaction_type: "Cash In",
        security_name: "Cash in via Debit",
        security_symbol: "CI",
        quantity: 1,
        security_price: amount,
        total_security_cost: amount,
        user_id: current_user.id
    )
    respond_to do |format|
      if  cash_in && cash_in.save
          current_user.update(
              balance: current_user.balance + amount
          )
          format.html { redirect_to request.referrer, notice: "Cash In was successful." }
      else
          format.html { redirect_to request.referrer, notice: "Something went wrong with your request." }
      end
    end
  end

  # PATCH/PUT /transactions/1 or /transactions/1.json
  def update
  end

  # DELETE /transactions/1 or /transactions/1.json
  def destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_transaction
      @transaction = Transaction.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def transaction_params
      params.require(:transaction).permit(:amount)
    end
end
