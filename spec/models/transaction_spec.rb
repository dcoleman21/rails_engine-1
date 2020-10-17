require 'rails_helper'

RSpec.describe Transaction, type: :model do
  describe 'validations' do
    it { should validate_presence_of :card }
    it { should validate_presence_of :card_exp }
    it { should validate_presence_of :result }
  end

  describe 'relationships' do
    it { should belong_to :invoice }
  end
end
