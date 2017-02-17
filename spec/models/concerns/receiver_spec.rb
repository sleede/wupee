require 'rails_helper'

shared_examples_for "Wupee::Receiver" do
  let(:model) { described_class }

  it "has many notifications" do
    expect(model.new).to respond_to(:notifications)
  end

  it "has many notification_type_configurations" do
    expect(model.new).to respond_to(:notification_type_configurations)
  end

  it "destroys notification on destroy" do
    receiver = create model.name.underscore
    create :notification, receiver: receiver
    expect { receiver.destroy }.to change { Wupee::Notification.count }.by(-1)
  end

  it "destroys notification_type_configurations on destroy" do
    receiver = create model.name.underscore
    Wupee::NotificationTypeConfiguration.create(receiver: receiver, notification_type: Wupee::NotificationType.create(name: 'abc'))
    expect { receiver.destroy }.to change { Wupee::NotificationTypeConfiguration.count }.by(-1)
  end

  context "there are already notification type created" do
    it "has no notification_type_configurations associated to notification_type" do
      expect(Wupee::NotificationTypeConfiguration.count).to eq 0
    end

    it "creates notification_type_configurations after model is created" do
      create :notification_type
      expect { create model.name.underscore }.to change { Wupee::NotificationTypeConfiguration.count }.by(1)
      expect(Wupee::NotificationTypeConfiguration.last.receiver).to eq model.last
    end

    it "doesn't create notification_type_configurations if you skip it" do
      model.class_eval { skip_callback(:create, :after, :create_notification_type_configurations) }
      expect { create model.name.underscore }.not_to change { Wupee::NotificationTypeConfiguration.count }
    end
  end
end
