require 'rails_helper'

RSpec.describe Wupee::Notifier, type: :model do

  context "methods defined" do
    it { expect(subject).to respond_to(:notif_type) }
    it { expect(subject).to respond_to(:attached_object) }
    it { expect(subject).to respond_to(:receiver) }
    it { expect(subject).to respond_to(:deliver) }
  end

  it "has a method notif_type that can take Wupee::NotificationType instance or string/symbol as argument" do
    notif_type = create :notification_type
    wupee_notifier = Wupee::Notifier.new
    wupee_notifier.notif_type(notif_type.name)
    expect(wupee_notifier.notification.notification_type).to eq notif_type

    wupee_notifier.notif_type(notif_type)
    expect(wupee_notifier.notification.notification_type).to eq notif_type
  end

end
