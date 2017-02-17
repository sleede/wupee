require 'rails_helper'

shared_examples_for "Wupee::Receiver" do
  let(:model) { described_class }

  it "has many notifications" do
    expect(model.new).to respond_to(:notifications)
  end

  it "destroys notification on destroy" do
    receiver = create model.name.underscore
    create :notification, receiver: receiver
    expect { receiver.destroy }.to change { Wupee::Notification.count }.by(-1)
  end
end
