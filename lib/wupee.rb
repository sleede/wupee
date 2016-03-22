require "wupee/engine"
require "wupee/notifier"

module Wupee
  mattr_accessor :mailer, :deliver_when

  def self.notify(opts = {}, &block)
    wupee_notifier = Wupee::Notifier.new(opts)
    yield wupee_notifier if block_given?
    wupee_notifier.execute
  end
end
