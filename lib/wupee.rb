require "wupee/engine"

module Wupee
  mattr_accessor :mailer, :deliver_when

  def self.notify(opts = {}, &block)
    wupee_notifier = Wupee::Notifier.new(opts)
    wupee_notifier.instance_eval(&block) if block_given?
    wupee_notifier.execute
  end
end
