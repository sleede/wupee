require 'rails_helper'

RSpec.describe Notification, type: :model do
  let!(:message) { create :message }
  let!(:receiver) { create :user }
  let!(:notification_type) { 'notify_new_message' }

  context 'method "send_notification"' do
    it 'should can set a notification type' do
      notification = Notification.new.send_notification(type: notification_type)
      expect(notification.notification_type).to eq notification_type
    end

    it 'should can set a attached object' do
      notification = Notification.new.send_notification(attached_object: message)
      expect(notification.attached_object).to eq message
    end
  end

  context 'method "to"' do
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

  it 'deliver' do
    notification = Notification.new.send_notification(type: notification_type, attached_object: message)
                                   .to(receiver)
    expect(notification.deliver).to eq true
  end
end
