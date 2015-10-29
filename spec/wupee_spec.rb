require 'spec_helper'

describe Wupee do
  it "has a setter for mailer" do
    expect(Wupee).to respond_to(:mailer=).with(1).argument
  end

  it "has a getter for mailer" do
    expect(Wupee).to respond_to(:mailer)
  end
end
