require_relative "../lib/render_react"
require "minitest/reporters"
require "minitest/autorun"

Minitest::Reporters.use! \
    Minitest::Reporters::SpecReporter.new

describe "RenderReact" do
  EXAMPLE_JAVASCRIPT_APP_PATH = File.dirname(__FILE__) + "/fixtures/react_and_example_component.js"

  before do
    RenderReact.instance_variable_set(:@context, nil)
  end

  it "needs a context before it works" do
    assert_raises(ArgumentError){
      RenderReact.("ExampleComponent", example: "prop")
    }
  end

  it "create a new context with .create_context!" do
    res = RenderReact.create_context!("// some javascript which sets up the RenderReact variable")
    assert_instance_of RenderReact::Context, res
  end

  describe "[has JS source as context]" do
    before do
      source = File.read(EXAMPLE_JAVASCRIPT_APP_PATH)
      RenderReact.create_context!(source)
    end

    it "'s current context in avaible as .context" do
      assert_instance_of RenderReact::Context, RenderReact.context
    end

    it "delegates .render_react (aliased as .call) method to context" do
      fake_context = RenderReact.instance_variable_set(:@context, Minitest::Mock.new)
      fake_context.expect(:render_react, true, ["ExampleComponent"])

      RenderReact.("ExampleComponent")
      fake_context.verify
    end

    it "delegates .on_* methods to context" do
      fake_context = RenderReact.instance_variable_set(:@context, Minitest::Mock.new)

      fake_context.expect(:on_client, true, ["ExampleComponent"])
      fake_context.expect(:on_server, true, ["ExampleComponent"])
      fake_context.expect(:on_client_and_server, true, ["ExampleComponent"])
      fake_context.expect(:on_server_and_client, true, ["ExampleComponent"])

      RenderReact.on_server("ExampleComponent")
      RenderReact.on_client("ExampleComponent")
      RenderReact.on_client_and_server("ExampleComponent")
      RenderReact.on_server_and_client("ExampleComponent")

      fake_context.verify
    end
  end

  describe "Context" do
    describe "#render_react / #call" do
      it "delegates to render_client_and_server if mode is :client_and_server" do
        context = RenderReact::Context.new(File.read(EXAMPLE_JAVASCRIPT_APP_PATH), mode: :client_and_server)
        called = false
        context.define_singleton_method :on_client_and_server do |*|
          called = true
        end
        context.render_react("ExampleComponent")

        assert called
      end

      it "delegates to render_client if mode is :client" do
        context = RenderReact::Context.new(File.read(EXAMPLE_JAVASCRIPT_APP_PATH), mode: :client)
        called = false
        context.define_singleton_method :on_client do |*|
          called = true
        end
        context.render_react("ExampleComponent")

        assert called
      end

      it "delegates to render_server if mode is :server" do
        context = RenderReact::Context.new(File.read(EXAMPLE_JAVASCRIPT_APP_PATH), mode: :server)
        called = false
        context.define_singleton_method :on_server do |*|
          called = true
        end
        context.render_react("ExampleComponent")

        assert called
      end
    end

    describe "#render_client_and_server" do
      it "renders HTML code for mounting the React component in the client and also renders it to HTML via ReactDOMServer.renderToString" do
        context = RenderReact::Context.new(File.read(EXAMPLE_JAVASCRIPT_APP_PATH))
        res = context.on_client_and_server("ExampleComponent", example: "!")
        assert_match /<marquee.*>.*Hello Ruby.*!.*<\/marquee>/, res
        assert_match /<div id=\"RenderReact-.*<script>RenderReact.ReactDOM.render\(RenderReact.React.createElement\(RenderReact.components.ExampleComponent, {\"example\":\"!\"}\), document.getElementById\('RenderReact-.*/, res
      end
    end

      describe "#render_client" do
        it "renders HTML code for mounting the React component in the client" do
          context = RenderReact::Context.new(File.read(EXAMPLE_JAVASCRIPT_APP_PATH))
          res = context.on_client("ExampleComponent", example: "!")
          assert_match /<div id=\"RenderReact-.*<script>RenderReact.ReactDOM.render\(RenderReact.React.createElement\(RenderReact.components.ExampleComponent, {\"example\":\"!\"}\), document.getElementById\('RenderReact-.*/, res
        end
      end

      describe "#render_server" do
        it "renders a React component to static HTML via ReactDOMServer.renderToStaticMarkup" do
          context = RenderReact::Context.new(File.read(EXAMPLE_JAVASCRIPT_APP_PATH))
          res = context.on_server("ExampleComponent", example: "!")
          assert_match /<marquee>Hello Ruby !<\/marquee>/, res
        end
      end
  end
end

