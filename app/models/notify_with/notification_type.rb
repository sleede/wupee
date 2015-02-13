module NotifyWith
  class NotificationType
    NAMES = %w(
      notify_new_message
    )

    def self.find(id)
      return nil if id.nil?
      NAMES[id-1]
    end

    def self.find_by_name(name)
      return nil if name.nil?
      NAMES.index(name.to_s)+1
    end
  end
end
