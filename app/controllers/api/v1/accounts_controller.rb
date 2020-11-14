# frozen_string_literal: true

module Api
  module V1
    class AccountsController < Api::V1::ApiController
      before_action :authenticate_account, only: %i[show]

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

      def show
        if current_account.id == params[:id].to_i
          render json: current_account, serializer: Api::V1::BalanceSerializer
        else
          render json: { errors: 'Account id not found' }, status: :unprocessable_entity
        end
      end

      private

      def account_params
        params.permit(:id, :name, :balance, :email, :password, :password_confirmation)
      end

      def account_exists?
        Account.find_by(id: params[:id]).present?
      end
    end
  end
end
