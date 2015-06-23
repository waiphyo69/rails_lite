require 'uri'

module Phase5
  class Params
    # use your initialize to merge params from
    # 1. query string
    # 2. post body
    # 3. route params
    #
    # You haven't done routing yet; but assume route params will be
    # passed in as a hash to `Params.new` as below:
    def initialize(req, route_params = {})
      @req = req
      @params = route_params
      if @req.body
        parse_www_encoded_form(@req.body)
      elsif @req.unparsed_uri.include?('?')
        unparsed_uri = req.unparsed_uri.split('?').last
        parse_www_encoded_form(unparsed_uri)
      end
    end

    def [](key)
      @params[key]
    end

    # this will be useful if we want to `puts params` in the server log
    def to_s
      @params.to_s
    end

    class AttributeNotFoundError < ArgumentError; end;

    private
    # this should return deeply nested hash
    # argument format
    # user[address][street]=main&user[address][zip]=89436
    # should return
    # { "user" => { "address" => { "street" => "main", "zip" => "89436" } } }
    def parse_www_encoded_form(www_encoded_form)
      params = URI::decode_www_form(www_encoded_form)
      params.each do |key, val|
        parse_key(key.to_sym, val)
      end
    end
    # this should return an array
    # user[address][street] should return ['user', 'address', 'street']
    def parse_key(key, val)
      different_keys = key.split(/\]\[|\[|\]/)
      if different_keys.length == 1
        #If there's only one key, then set the params hash accordingly
        @params[key] = val
      else
        #If there are nested keys, build out the params hash
        current_hash = @params
        different_keys.each_with_index do |k, key_i|
          if (key_i == different_keys.length-1)
            current_hash[k] = val
          else
            current_hash[k] ||= {}
            current_hash = current_hash[k]
          end
        end
      end
    end
  end
end
