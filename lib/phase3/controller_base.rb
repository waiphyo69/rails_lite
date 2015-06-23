require_relative '../phase2/controller_base'
require 'active_support'
require 'active_support/core_ext'
require 'erb'

module Phase3
  class ControllerBase < Phase2::ControllerBase
    # use ERB and binding to evaluate templates
    # pass the rendered html to render_content
    def render(template_name)
      if already_built_response?
        raise RuntimeError, "Request has already been made"
      end
      controller_name = self.class.to_s.underscore
      file_path = "views/#{controller_name}/#{template_name}.html.erb"
      template = File.read(file_path)
      content = ERB.new(template).result(binding)
      render_content(content, 'text/html')
    end
  end
end
