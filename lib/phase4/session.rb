require 'json'
require 'webrick'
module Phase4
  class Session
    def initialize(req)
      @req = req
      @req.cookies.each do |cookie|
        if cookie.name == '_rails_lite_app'
          @session = JSON.parse(cookie.value)
        end
      end
      @session ||= {}
    end

    def [](key)
      @session[key]
    end

    def []=(key, val)
      @session[key] = val
    end

    def store_session(res)
      name = "_rails_lite_app"
      value = @session.to_json
      cookie = WEBrick::Cookie.new(name, value)
      res.cookies << cookie
    end
  end
end 
