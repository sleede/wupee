require 'rails_helper'

RSpec.describe Notification, type: :model do
  let!(:message) { create :message }
  let!(:receiver) { create :user }
  let!(:notification_type) { 'notify_new_message' }

  context 'method #send_notification' do
    it 'should can set a notification type' do
      notification = Notification.new.send_notification(type: notification_type)
      expect(notification.notification_type).to eq notification_type
    end

    it 'should can set a attached object' do
      notification = Notification.new.send_notification(attached_object: message)
      expect(notification.attached_object).to eq message
    end
  end

  context 'method #to' do
    it 'should can set a receiver' do
      notification = Notification.new.to(receiver)
      expect(notification.receiver).to eq receiver
    end
  end

  it 'should create success with receiver, notification_type and attached_object' do
    notification = Notification.new.send_notification(type: notification_type, attached_object: message)
                                   .to(receiver)
    expect(notification.save).to eq true
  end

  it 'is invalid without notification_type' do
    notification = Notification.new.send_notification(attached_object: message)
                                   .to(receiver)
    expect(notification).to be_invalid
  end

  it 'is invalid without attached_object' do
    notification = Notification.new.send_notification(type: notification_type, attached_object: nil)
                                   .to(receiver)
    expect(notification).to be_invalid
  end

  it 'is invalid without receivor' do
    notification = Notification.new.send_notification(type: notification_type, attached_object: message)
    expect(notification).to be_invalid
  end

  it 'should be able to be marked is read' do
    notification = Notification.new.send_notification(type: notification_type, attached_object: message)
                                   .to(receiver)
    notification.save
    notification.mark_as_read
    expect(notification.is_read).to eq true
  end

  it '#deliver_now should send a mail' do
    notification = Notification.new.send_notification(type: notification_type, attached_object: message)
                                   .to(receiver)
    expect(notification.deliver_now).to be_a(Mail::Message)
  end

  it '#deliver_later should send later a mail' do
    notification = Notification.new.send_notification(type: notification_type, attached_object: message)
                                   .to(receiver)
    expect(notification.deliver_later).to be_a(ActionMailer::DeliveryJob)
  end

  describe 'receiver' do
    it 'should can return his all notifications' do
      notification = Notification.new.send_notification(type: notification_type, attached_object: message)
                                     .to(receiver)
      expect {notification.save}.to change{receiver.notifications.count}.from(0).to(1)
    end
  end

  context 'when attached object is destroy' do
    it 'all notifications with this object should destroy' do
      notification = Notification.new.send_notification(type: notification_type, attached_object: message)
                                     .to(receiver)
      notification.save
      expect {message.destroy}.to change{receiver.notifications.count}.from(1).to(0)
    end
  end
end
