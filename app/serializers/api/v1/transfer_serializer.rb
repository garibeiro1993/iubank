class Api::V1::TransferSerializer < ActiveModel::Serializer
  attributes :id, :source_account_id, :destination_account_id, :amount
end
