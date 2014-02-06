Osprey CLI
==========

A command-line tool for [Osprey](https://github.com/mulesoft/osprey).

### Prerequisites

To start using Osprey CLI you'll need the following:

* [Node JS](http://nodejs.org/)
* [NPM](https://npmjs.org/)

### Getting started

Install Osprey CLI globally - `npm install -g git+https://github.com/mulesoft/osprey-cli.git`.

### Creating a new application

`osprey new <raml-file or path-to-raml> [options]`

| Option            | Default Value  | Description  |
|:------------------|:---------------|:---------------|
| --help            |-               | Shows usage information
| --version         |-               | Shows the version number
| --baseUri         |/api            | Specifies base URI for your API
| --language        |javascript      | Specifies output programming language: javascript, coffeescript
| --target          |output          | Specifies output directory
| --name            |raml-app        | Specifies application name
| --verbose         |-               | Sets the verbose level of output
| --quiet           |-               | Silences commands

##### Examples
`osprey new`

`osprey new api.raml`

`osprey new api.raml -n my-app`

### Listing RAML resources

`osprey list <raml-file>`

##### Examples
`osprey list api.raml`
