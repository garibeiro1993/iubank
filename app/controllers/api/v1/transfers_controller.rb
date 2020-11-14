class Api::V1::TransfersController < Api::V1::ApiController
  before_action :authenticate_account

  def create
    result = Operations::Transfers::Create.call(transfer_params.merge(source_account_id: current_account.id))
    if result.success?
      render json: result.data, serializer: Api::V1::TransferSerializer, status: :created
    else
      render json: { errors: result.errors }, status: :unprocessable_entity
    end
  end

  private

  def transfer_params
    params.permit(:destination_account_id, :amount)
  end
end
