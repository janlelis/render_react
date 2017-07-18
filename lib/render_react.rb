require_relative "render_react/version"
require_relative "render_react/context"

module RenderReact
  class << self
    def context
      @context or raise ArgumentError, "Create a RenderReact::Context via RenderReact.create_context! first!"
    end

    def create_context!(*args)
      @context = Context.new(*args)
    end

    def render_react(*args)
      context.render_react(*args)
    end
    alias call render_react

    def on_server(*args)
      context.on_server(*args)
    end

    def on_client(*args)
      context.on_client(*args)
    end

    def on_client_and_server(*args)
      context.on_client_and_server(*args)
    end

    def on_server_and_client(*args)
      context.on_server_and_client(*args)
    end
  end
end