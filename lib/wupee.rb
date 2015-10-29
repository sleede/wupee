require "wupee/engine"

module Wupee
  mattr_accessor :mailer

  def self.notify(opts = {}, &block)
    wupee_notifier = Wupee::Notifier.new

    opts.each do |method, value|
      wupee_notifier.send(method, value)
    end

    wupee_notifier.instance_eval(&block) if block_given?

    wupee_notifier.send
  end
end
