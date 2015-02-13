require 'spec_helper'

describe NotifyWith do
  it "should can set a mailer" do
    expect(NotifyWith).to respond_to(:mailer=).with(1).argument
  end

  it "should can get a mailer" do
    expect(NotifyWith).to respond_to(:mailer)
  end
end
