# frozen_string_literal: true
require "bundler/setup"
require "hanami/api"
require "hanami/middleware/body_parser"
require "./rabbit"

class App < Hanami::API
  use Hanami::Middleware::BodyParser, :json

  post "/ocr" do
    if params[:fileUrl].end_with? '.png', '.jpg'
      Rabbit.publish(params[:fileUrl], routing_key: 'ocr_service')
      200
    else
      halt 422, "must be png or jpg"
    end
  end

end
