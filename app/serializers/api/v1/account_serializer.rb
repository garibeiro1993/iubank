class Api::V1::AccountSerializer < ActiveModel::Serializer
  attributes :id, :name, :balance, :email, :token

  def token
    token = Knock::AuthToken.new(payload: { sub: object.id }).token
    return { 'Authorization' => "Bearer #{token}" }
  end
end
