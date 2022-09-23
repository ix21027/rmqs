# frozen_string_literal: true
require "bundler/setup"
require "hanami/api"
require "bunny"
require "hanami/middleware/body_parser"

begin
  CONN = Bunny.new(hostname:  ENV.fetch('RABBITMQ_HOST', 'localhost'))
  CONN.start
  CH = CONN.create_channel
rescue StandardError
  sleep 1
  retry
end

class App < Hanami::API
  use Hanami::Middleware::BodyParser, :json

  post "/ocr" do
    if params[:fileUrl].end_with? '.png', '.jpg'
      CH.default_exchange.publish(params[:fileUrl], routing_key: 'ocr_service')
      200
    else
      halt 422, "must be png or jpg"
    end
  end

end

run App.new