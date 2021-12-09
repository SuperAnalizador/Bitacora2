class User < ApplicationRecord
    has_many :owners
    has_many :blogs, through: :owners
    has_many :messages, dependent: :destroy
    has_many :posts, dependent: :destroy
    validates :first_name, :last_name, presence: true
end 