require 'rails_helper'

RSpec.describe NotificationsMailer do
  subject { NotificationsMailer }
  let!(:notification) { create :notification }

  it 'should respond to method #send_mail_for' do
    expect(subject).to respond_to(:send_mail_for)
  end

  describe 'send mail by a notification' do
    before do
      @mail = subject.send_mail_for(notification).deliver_now
    end

    it 'should be sent' do
      expect(ActionMailer::Base.deliveries).not_to be_empty
    end

    it 'should have the correct subject' do
      expect(@mail.subject).to eq I18n.t(".wupee.email_subjects.#{notification.notification_type.name}")
    end

    it 'should have correct receiver' do
      expect(@mail.to).to eq [notification.receiver.email]
    end

    it 'should mark notification as sent' do
      expect(notification.is_sent).to eq true
    end
  end
end
