FactoryBot.define do
  factory :Transfer do
    amount { 100000 }
    source_account_id { create(:account) }
    destination_account_id { create(:account) }
  end
end
