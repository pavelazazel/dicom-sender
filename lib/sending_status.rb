class SendingStatus
  @@status = :ready
  @@progress = 0
  @@total = 100

  def self.status
    @@status
  end

  def self.sending
    @@status = :sending
  end

  def self.complete
    @@status = :complete
  end

  def self.ready
    @@status = :ready
    @@progress = 0
    @@total = 100
  end

  def self.failed
    @@status = :failed
  end

  def self.total=(total)
    @@total = total
  end

  def self.percent_progress
    "#{self.progress}%"
  end

  def self.progress
    (@@progress.to_f / @@total.to_f * 100).to_i
  end

  def self.progress=(progress)
    @@progress = progress
  end
end