=begin
/*

The MIT License (MIT)

Copyright (c) 2014 Zhussupov Zhassulan zhzhussupovkz@gmail.com

Permission is hereby granted, free of charge, to any person obtaining a copy of
this software and associated documentation files (the "Software"), to deal in
the Software without restriction, including without limitation the rights to
use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
the Software, and to permit persons to whom the Software is furnished to do so,
subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

*/
=end

require 'net/http'
require 'net/https'
require 'openssl'
require 'json'

class QrCodeApi

  def initialize
    @api_url = 'https://api.qrserver.com/v1/'
  end

  def get_request method, params = {}
    if params.nil?
      raise ArgumentError, "Invalid request params"
    else
       params = URI.escape(params.collect{ |k,v| "#{k}=#{v}"}.join('&'))
    end
    url = @api_url + method + '/?' + params
    raise ArgumentError, "Can't send request to the server" if not url.is_a? String
    uri = URI.parse(url)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    req = Net::HTTP::Get.new(uri.request_uri)
    res = http.request(req)
  end
  
  def create_qr_code params, output
    res = get_request 'create-qr-code', params
    if res.code == "200"
      data = res.body
      puts "QR-code successfully created"
      File.new("#{output}", 'wb').write(data)
      puts "QR-code successfully downloaded to #{output}"
    else
      puts "Server returned error status" 
    end
  end

  def read_qr_code_from_url url
    params = { :fileurl => url, :outputformat => 'json' }
    res = get_request 'read-qr-code', params
    if res.code == "200"
      data = res.body
      result = JSON.parse(data)
    else
      puts "Server returned error status" 
    end
  end

end