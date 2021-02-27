class QueueController < ApplicationController
  require "#{Rails.root}/lib/sending_status.rb"
  require 'dicom'
  include DICOM

  def index
    files = Dir.glob(ENV['FILES_PATH'])
    @quantity = files.size
    @dcms = read_dcms(files.first(50))
    @status = SendingStatus.status
    @progress = SendingStatus.percent_progress
  end

  def send_dcm
    SendDcmJob.perform_later
    redirect_to root_path
  end

  def erase_dir
    FileUtils.rm_rf(Dir.glob(ENV['FILES_PATH']))
    SendingStatus.ready
    redirect_to root_path
  end

  def queue_params
    params.require(:queue).permit(:data_uri)
  end

  private

  def read_dcms(files)
    insnum = '0020,0013'  # DICOM Instance Number Attribute
    machine = '0002,0016' # DICOM Source Application Entity Title (machine model name in this case)
    date = '0008,0020'    # DICOM Study Date
    dcms = Array.new
    files.each do |f|
      dcm = DObject.read(f)
      dcms << "#{dcm.patients_name.value} (#{dcm.value(machine)}: #{dcm.value(date)}): [#{dcm.value(insnum)}]"
    end
    dcms
  end
end
