# RenderReact [![[version]](https://badge.fury.io/rb/render_react.svg)](https://badge.fury.io/rb/render_react) [![[ci]](https://github.com/janlelis/render_react/workflows/Test/badge.svg)](https://github.com/janlelis/render_react/actions?query=workflow%3ATest)

A lo-fi way to render client- and server-side React components from Ruby:

```js
class ExampleComponent extends React.Component {
  render() {
    return <marquee>Hello Ruby { this.props.example }</marquee>
  }
}
```

```html
RenderReact.on_client_and_server("ExampleComponent", { example: "!" })
# =>
<div id="RenderReact-caac405e-1714-495e-aeb4-77b42be42291">
  <marquee data-reactroot="" data-reactid="1" data-react-checksum="441921122">
    <!-- react-text: 2 -->Hello Ruby <!-- /react-text --><!-- react-text: 3 -->!<!-- /react-text -->
  </marquee>
</div>
<script>
  RenderReact.ReactDOM.render(
    RenderReact.React.createElement(
      RenderReact.components.ExampleComponent, {"example":"!"}
    ),
    document.getElementById('RenderReact-caac405e-1714-495e-aeb4-77b42be42291')
  )
</script>
```

It is *bring your own tooling*: React is not included, nor any ES6 transpilers or module bundlers. It expects you to prepare the JavaScript bundle file in a specific format, which must contain React and all of your components.

If you are looking for higher-level alternatives, checkout [react_on_rails](https://github.com/shakacode/react_on_rails) or [react-rails](https://github.com/reactjs/react-rails).

## Setup

Add to your `Gemfile`:

```ruby
gem 'render_react'
```

### JavaScript Source Preparation

**RenderReact** expects the JavaScript bundle to include a global variable called `RenderReact` with the following contents:

```javascript
{
  React: [variable which contains React],
  ReactDOM: [variable which contains ReactDOM],
  ReactDOMServer: [variable which contains ReactDOMServer],
  components: {
    ComponentIdentifier1: [variable which contains the component 1],
    ComponentIdentifier2: [variable which contains the component 2],
    ...
  }
}
```

- Where is **React**? See first paragraph of https://facebook.github.io/react/docs/react-api.html
- Where is **ReactDOM**? See first paragraph of https://facebook.github.io/react/docs/react-dom.html
- Where is **ReactDOMServer**? See first paragraph of https://facebook.github.io/react/docs/react-dom-server.html

You can have two different javascript bundle files - one for server rendering, and one for client-rendering.

- The client bundle has to be included into your application by a method of your choice. You may skip passing in `ReactDOMServer` for the client bundle
- The server bundle has to be passed to `RenderReact` (see Usage section). You may skip passing in `ReactDOM` for the server bundle

#### Example (With ES6 Modules)

```javascript
import React from 'react'
import ReactDOM from 'react-dom'
import ReactDOMServer from 'react-dom/server'

import ExampleComponent from './components/example_component'

export default {
  React: React,
  ReactDOM: ReactDOM,
  ReactDOMServer: ReactDOMServer,
  components: {
    ExampleComponent: ExampleComponent
  }
}
```

Gets imported as `RenderReact`

#### Example (With  Browser Globals)

```javascript
window.RenderReact = {
  React: React,
  ReactDOM: ReactDOM,
  ReactDOMServer: ReactDOMServer,
  components: {
    ExampleComponent: ExampleComponent
  }
}
```

## Usage

Create a **RenderReact** context by passing your server-side JavaScript bundle:

```ruby
RenderReact.create_context! File.read('path/to/your/server-bundle.js'), mode: :client_and_server
```

You can use it without a server-side bundle by not passing any file source.

The optional `mode:` keyword argument can have one of the following values

- `:client_and_server` (default) - component will be rendered server-side and mounted in the client
- `:client` - component will be mounted in the client
- `:server` - component will be render statically

You can then render a component with

```ruby
RenderReact.("ExampleComponent", { example: "prop" })
```

It is possible to overwrite the context-rendering-mode by using specfic render methods:

```ruby
RenderReact.on_client_and_server("ExampleComponent") # server- and client-side
RenderReact.on_client("ExampleComponent") # only client-side
RenderReact.on_server("ExampleComponent") # only static
```

## MIT License

Copyright (C) 2017 Jan Lelis <https://janlelis.com>. Released under the MIT license.

React is BSD licensed.
