# frozen_string_literal: true
require "bundler/setup"
Bundler.require(:default)

APP_LOADER = Zeitwerk::Loader.new
APP_LOADER.push_dir("./")
APP_LOADER.setup

CONN = Bunny.new(host: 'rabbitmq')
CONN.start
CH = CONN.create_channel

require "hanami/middleware/body_parser"

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