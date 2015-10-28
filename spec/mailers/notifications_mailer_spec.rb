require 'rails_helper'

RSpec.describe NotificationsMailer do
  subject { NotificationsMailer }
  let!(:notification) { create :notification }

  it 'should respond to method #send_mail_by' do
    expect(subject).to respond_to(:send_mail_by)
  end

  describe 'send mail by a notification' do
    before do
      @mail = subject.send_mail_by(notification).deliver_now
    end

    it 'should send success' do
      expect(ActionMailer::Base.deliveries).not_to be_empty
    end

    it 'should have correct subject' do
      expect(@mail.subject).to eq I18n.t(".notifications_mailer.send_mail_by.subject_#{notification.notification_type.name}")
    end

    it 'should have correct receiver' do
      expect(@mail.to).to eq [notification.receiver.email]
    end

    it 'should notification mark as send' do
      expect(notification.is_send).to eq true
    end
  end
end
