class Cadet < ApplicationRecord
  validates :login, presence: true, uniqueness: true





end
