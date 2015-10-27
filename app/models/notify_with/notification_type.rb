class NotifyWith::NotificationType
  NAMES = []

  def self.notification_type_names(names)
    NAMES.concat names
  end

  def self.find(id)
    return nil if id.nil?
    NAMES[id-1]
  end

  def self.find_by_name(name)
    return nil if name.nil? or NAMES.empty?
    NAMES.index(name.to_s)+1
  end
end
