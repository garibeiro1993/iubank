class Transfer < ApplicationRecord
  belongs_to :source_account, class_name: 'Account', foreign_key: 'source_account_id'
  belongs_to :destination_account, class_name: 'Account', foreign_key: 'destination_account_id'

  after_create :add_transfer

  def add_transfer(params = {})
    source_account.debit(amount)
    destination_account.credit(amount)
  end
end
