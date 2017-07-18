require "execjs"
require "securerandom"
require "json"

module RenderReact
  class Context
    attr_reader :app, :mode

    def initialize(javascript_source = "", mode: :client_and_server)
      @app = ExecJS.compile(javascript_source)
      @mode = mode
    end

    def render_react(*args)
      case mode
      when :client
        on_client(*args)
      when :server
        on_server(*args)
      when :client_and_server, :server_and_client
        on_client_and_server(*args)
      else
        raise ArgumentError, "unknown render mode"
      end
    end
    alias call render_react

    def on_client(component_name, props_hash = {})
      component_uuid = SecureRandom.uuid
      props_json = JSON.dump(props_hash)
      "<div id=\"RenderReact-#{component_uuid}\"></div><script>#{client_script(component_name, props_json, component_uuid)}</script>"
    end

    def on_server(component_name, props_hash = {})
      props_json = JSON.dump(props_hash)
      app.eval(server_script(component_name, props_json, true))
    end

    def on_client_and_server(component_name, props_hash = {})
      component_uuid = SecureRandom.uuid
      props_json = JSON.dump(props_hash)
      server_rendered = app.eval(server_script(component_name, props_json))
      "<div id=\"RenderReact-#{component_uuid}\">#{server_rendered}</div><script>#{client_script(component_name, props_json, component_uuid)}</script>"
    end
    alias on_server_and_client on_client_and_server

    private

    def client_script(component_name, props_json, uuid)
      "RenderReact.ReactDOM.render(RenderReact.React.createElement(RenderReact.components.#{component_name}, #{props_json}), document.getElementById('RenderReact-#{uuid}'))"
    end

    def server_script(component_name, props_json, static = false)
      render_method = static ? 'renderToStaticMarkup' : 'renderToString'
      "RenderReact.ReactDOMServer.#{render_method}(RenderReact.React.createElement(RenderReact.components.#{component_name}, #{props_json}))"
    end
  end
end
