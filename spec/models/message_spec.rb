require 'rails_helper'

RSpec.describe Message, type: :model do
  it_behaves_like "Wupee::AttachedObject"
end
