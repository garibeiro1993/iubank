class Account < ApplicationRecord
  has_secure_password

  validates_length_of :password,
                      maximum: 72,
                      minimum: 8,
                      allow_nil: true,
                      allow_blank: false
 
  validates_presence_of :name, :email, :balance
 
  has_many :transfers, dependent: :destroy
end
