module Api
  module V1
    class AccountTokenController < Knock::AuthTokenController
      #skip_before_action :verify_authenticity_token
    end
  end
end