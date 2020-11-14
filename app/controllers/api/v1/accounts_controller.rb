class Api::V1::AccountsController < Api::V1::ApiController
  before_action :authenticate_account, only: %i[current]
  before_action :set_account, only: %i[current]

  def create
    account = Account.new(account_params)
    
    if account_exists?
      render json: { errors: 'account id is already in use, please provide a valid id' }, status: :unprocessable_entity
    elsif account.save
      render json: account, status: :created
    else
      render json: { errors: account.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def current
    render json: current_account
  end

  private

  def account_params
    params.permit(:id, :name, :balance, :email, :password, :password_confirmation)
  end

  def set_account
    @account = Account.find_by(id: params[:id])
  end

  def account_exists?
    Account.find_by(id: params[:id]).present?
  end
end
