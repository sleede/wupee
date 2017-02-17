require 'rails_helper'

RSpec.describe Wupee::Notification, type: :model do
  let!(:message) { create :message }
  let!(:receiver) { create :user }
  let!(:notification_type_name) { 'notify_new_message' }
  let!(:notification_type) { create :notification_type, name: notification_type_name }

  context "validations" do
    it "validates presence of receiver" do
      notification = Wupee::Notification.new
      notification.valid?
      expect(notification.errors).to have_key :receiver
    end

    it "validates presence of notification_type" do
      notification = Wupee::Notification.new
      notification.valid?
      expect(notification.errors).to have_key :notification_type
    end
  end

  it 'should be able to be marked as read' do
    notification = create :notification
    notification.mark_as_read
    expect(notification.is_read).to eq true
  end

  it 'should be able to be marked as sent' do
    notification = create :notification
    notification.mark_as_sent
    expect(notification.is_sent).to eq true
  end

  context "default values" do
    it { expect(create(:notification).is_read).to be false }
    it { expect(create(:notification).is_sent).to be false }
  end
end
