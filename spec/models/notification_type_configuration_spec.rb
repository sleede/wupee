require 'rails_helper'

RSpec.describe Wupee::NotificationTypeConfiguration, type: :model do
  let!(:receiver) { create :user }
  let!(:notification_type) { create :notification_type }

  context "validations" do
    it "validates presence of receiver" do
      notification_type_conf = Wupee::NotificationTypeConfiguration.new
      notification_type_conf.valid?
      expect(notification_type_conf.errors).to have_key :receiver
    end

    it "validates presence of notification_type" do
      notification_type_conf = Wupee::NotificationTypeConfiguration.new
      notification_type_conf.valid?
      expect(notification_type_conf.errors).to have_key :notification_type
    end

    it "validates uniqueness of [receiver, notification_type]" do
      notification_type_conf_same = Wupee::NotificationTypeConfiguration.create(receiver: receiver, notification_type: notification_type)
      expect(notification_type_conf_same).to be_invalid
    end
  end
end
