import React from 'react'
import ReactDOM from 'react-dom'
import ReactDOMServer from 'react-dom/server'

class ExampleComponent extends React.Component {
  render() {
    return <marquee>Hello Ruby { this.props.example }</marquee>
  }
}

export default {
  React: React,
  ReactDOM: ReactDOM,
  ReactDOMServer: ReactDOMServer,
  components: {
    ExampleComponent: ExampleComponent,
  }
}

