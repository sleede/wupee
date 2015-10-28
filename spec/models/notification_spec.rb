require 'rails_helper'

RSpec.describe NotifyWith::Notification, type: :model do
  let!(:message) { create :message }
  let!(:receiver) { create :user }
  let!(:notification_type_name) { 'notify_new_message' }
  let!(:notification_type) { create :notification_type, name: notification_type_name }

  context "validations" do
    it "validates presence of receiver" do
      notification = NotifyWith::Notification.new
      notification.valid?
      expect(notification.errors).to have_key :receiver
    end

    it "validates presence of notification_type" do
      notification = NotifyWith::Notification.new
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

  # this test has to be moved to notification_attached_object spec
  context 'when attached object is destroy' do
    it 'has to destroy the notification' do

      notification = create :notification
      receiver = notification.receiver

      expect { notification.attached_object.destroy }.to change{ receiver.notifications.count }.from(1).to(0)
    end
  end

  # this test has to be moved to notification_receiver spec
  describe 'receiver' do
    it 'should can return his all notifications' do
      notification = NotifyWith::Notification.new.send_notification(type: notification_type_name, attached_object: message)
                                     .to(receiver)
      expect {notification.save}.to change{receiver.notifications.count}.from(0).to(1)
    end
  end

  # those tests have to be rethink... or moved!
  context 'method #send_notification' do
    it 'should can set a notification type' do
      notification = build(:notification).send_notification(type: notification_type_name)
      expect(notification.notification_type.name).to eq notification_type_name
    end

    it 'should can set a attached object' do
      notification = build(:notification).send_notification(attached_object: message, type: notification_type_name)
      expect(notification.attached_object).to eq message
    end
  end

  context 'method #to' do
    it 'should can set a receiver' do
      notification = build(:notification).to(receiver)
      expect(notification.receiver).to eq receiver
    end
  end

  it '#deliver_now should send a mail' do
    notification = NotifyWith::Notification.new.send_notification(type: notification_type_name, attached_object: message)
                                   .to(receiver)
    expect(notification.deliver_now).to be_a(Mail::Message)
  end

  it '#deliver_later should send later a mail' do
    notification = NotifyWith::Notification.new.send_notification(type: notification_type_name, attached_object: message)
                                   .to(receiver)
    expect(notification.deliver_later).to be_a(ActionMailer::DeliveryJob)
  end



end
