class SendDcmJob < ApplicationJob
  require "#{Rails.root}/lib/sending_status.rb"
  require 'dicom'
  include DICOM

  def perform
    node = DClient.new(ENV['PACS_IP'],
                       ENV['PACS_PORT'],
                       { host_ae: ENV['PACS_HOST_AE'],
                         ae: ENV['AE'] })
    if node.test
      files = Dir.glob(ENV['FILES_PATH'])
      SendingStatus.total = files.size
      SendingStatus.sending
      files.each_with_index do |f, i|
        node.send(f)
        SendingStatus.progress = (i + 1)
      end
      SendingStatus.complete
    else
      SendingStatus.failed
    end
  end
end
