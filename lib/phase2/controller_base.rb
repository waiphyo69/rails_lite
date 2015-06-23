module Phase2
  class ControllerBase
    attr_reader :req, :res

    # Setup the controller
    def initialize(req, res)
      @req, @res = req, res
      # @params = Params.new(req, route_params)
    end

    # Helper method to alias @already_built_response
    def already_built_response?
      @already_built_response
    end


    # Set the response status code and header
    def redirect_to(url)
      if already_built_response?
        raise RuntimeError, "Request has already been made"
      end
      base_url = url.split("http://").last
      @res.status = 302
      @res['location'] = "http://#{base_url}"
      @already_built_response = true
    end

    # Populate the response with content.
    # Set the response's content type to the given type.
    # Raise an error if the developer tries to double render.
    def render_content(content, content_type)
      if already_built_response?
        raise RuntimeError, "Request has already been made"
      end
      @res.content_type = content_type
      @res.body = content
      @already_built_response = true
    end
  end
end
