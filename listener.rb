require "rtesseract"
require "down"
Sneakers.configure heartbeat: 30, amqp: "amqp://guest:guest@#{ENV.fetch('RABBITMQ_HOST', 'localhost')}:5672"#, :log  => 'res.log'
Sneakers.logger.level = Logger::INFO 

class Listener
  include Sneakers::Worker
  from_queue :ocr_service
  
  def work(msg)
    temp_img = ::Down.download(msg, max_size: 2 * 1024 * 1024)  # 2 MB
    res = RTesseract.new(temp_img.path).to_s 
    logger.info "\n#{res}"
    ack!
  end
end