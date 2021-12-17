class Admin::UsersController < ApplicationController
    class AuthorizationError < StandardError; end
    before_action :authenticate_user!
    before_action :authorize_user! 
    rescue_from AuthorizationError, with: :unauthorized

    before_action :set_user, only: [:show, :edit, :update, :destroy]
  
    def show
    end
  
    def index
        @users = Client.all
    end
  
    def new
        @user = Client.new
    end
  
    def create
        @user = Client.create(user_params.merge!(registration_status: "Active"))

        respond_to do |format|
            if @user.save
              format.html { redirect_to admin_user_path(@user.id), notice: "Client was successfully created." } #what's the alternative path to redirect? directly using @task doesnt work
              format.json { render :show, status: :created, location: @user }
            else
              format.html { render :new, status: :unprocessable_entity }
              format.json { render json: @user.errors, status: :unprocessable_entity }
            end
        end
    end
  
    def edit
    end
  
    def update
        @user.update(user_params)

        respond_to do |format|
            if @user.save
              format.html { redirect_to admin_user_path(@user.id), notice: "Client was successfully updated." } #what's the alternative path to redirect? directly using @task doesnt work
              format.json { render :show, status: :created, location: @user }
            else
              format.html { render :new, status: :unprocessable_entity }
              format.json { render json: @user.errors, status: :unprocessable_entity }
            end
        end
    end
  
    def destroy
        @user.destroy
    end
  
    private 

        def set_user
            @user = Client.find(params[:id])
        end
  
        def user_params
            params.require(:client).permit(:email, :password, :password_confirmation, :full_name)
        end

        def authorize_user!
            raise AuthorizationError and return unless current_user.admin?
        end

        def unauthorized
            redirect_to new_user_session_path, alert: 'You are not authorized.'
        end
  end 