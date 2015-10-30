require 'rails_helper'

RSpec.describe Wupee::Notifier, type: :model do

  context "methods defined" do
    it { expect(subject).to respond_to(:notif_type) }
    it { expect(subject).to respond_to(:attached_object) }
    it { expect(subject).to respond_to(:receiver) }
    it { expect(subject).to respond_to(:receivers) }
    it { expect(subject).to respond_to(:deliver) }
    it { expect(subject).to respond_to(:subject_vars) }
  end

  it "has a method notif_type that can take Wupee::NotificationType instance or string/symbol as argument" do
    notif_type = create :notification_type
    wupee_notifier = Wupee::Notifier.new
    wupee_notifier.notif_type(notif_type.name)
    expect(wupee_notifier.notification_type).to eq notif_type

    wupee_notifier.notif_type(notif_type)
    expect(wupee_notifier.notification_type).to eq notif_type
  end

  it "has a method execute to send notifications and mails depending on notification_type_configurations of the users" do
    notif_type = Wupee::NotificationType.create!(name: "notify_new_message")

    user_1 = create :user
    user_2 = create :user
    user_3 = create :user
    user_4 = create :user

    Wupee::NotificationTypeConfiguration.find_by(receiver: user_2, notification_type: notif_type).update(value: :nothing)
    Wupee::NotificationTypeConfiguration.find_by(receiver: user_3, notification_type: notif_type).update(value: :email)
    Wupee::NotificationTypeConfiguration.find_by(receiver: user_4, notification_type: notif_type).update(value: :notification)

    wupee_notifier = Wupee::Notifier.new(receivers: [user_1, user_2, user_3, user_4], notif_type: notif_type)

    expect { wupee_notifier.execute }.to change { ActionMailer::Base.deliveries.size }.by(2)
    expect { wupee_notifier.execute }.to change { Wupee::Notification.where(is_read: true).count }.by(2)
    expect { wupee_notifier.execute }.to change { Wupee::Notification.count }.by(4)
  end
end
