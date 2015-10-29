require 'rails_helper'

shared_examples_for "Wupee::AttachedObject" do
  let(:model) { described_class }

  it "destroys notification on destroy" do
    attached_object = create model.name.underscore
    notif = create :notification, attached_object: attached_object
    expect { attached_object.destroy }.to change { Wupee::Notification.count }.by(-1)
  end
end
