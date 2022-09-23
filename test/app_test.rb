require 'rack'
require 'rack/lint'
require 'rack/test_app'      
require 'oktest'
require_relative '../app.rb'

http = Rack::TestApp.wrap(Rack::Lint.new(App.new))

Oktest.scope do

  topic("POST /ocr") do

    spec("png_file_url returns 200") do
      png_file_url = {"fileUrl": "https://previews.123rf.com/images/happyroman/happyroman1611/happyroman161100004/67968361-atm-transaction-printed-paper-receipt-bill-vector.jpg"}
      response = http.POST("/ocr", json: png_file_url)
      ok {response.status} == 200
    end
    
    spec("jpg_file_url returns 200") do
      jpg_file_url = {"fileUrl": "https://sharelatex-wiki-cdn-671420.c.cdn77.org/learn-scripts/images/5/5f/Ragged2eOLV21.png"}
      response = http.POST("/ocr", json: jpg_file_url)
      ok {response.status} == 200
    end

    spec("not_img_file_url returns 422") do
      not_img_file_url = {"fileUrl": "https://google.com"}
      response = http.POST("/ocr", json: not_img_file_url)
      ok {response.status} == 422
    end

  end

end