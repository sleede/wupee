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

  context "methods" do
    it "has method wants_email?" do
      notification_type_conf = Wupee::NotificationTypeConfiguration.new(value: :both)
      expect(notification_type_conf.wants_email?).to eq true

      notification_type_conf = Wupee::NotificationTypeConfiguration.new(value: :email)
      expect(notification_type_conf.wants_email?).to eq true
    end

    it "has method wants_notification?" do
      notification_type_conf = Wupee::NotificationTypeConfiguration.new(value: :both)
      expect(notification_type_conf.wants_notification?).to eq true

      notification_type_conf = Wupee::NotificationTypeConfiguration.new(value: :notification)
      expect(notification_type_conf.wants_notification?).to eq true
    end
  end
end
