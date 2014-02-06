Osprey CLI
==========

A command-line tool for Osprey.

### Prerequisites

To start using APIKit you'll need the following:

* [Node JS](http://nodejs.org/)
* [NPM](https://npmjs.org/)

### Getting started

Install APIKit Node CLI globally - `npm install -g git+https://github.com/mulesoft/apikit-node-cli.git`.

### Creating a new application

`apikit new <raml-file or path-to-raml> [options]`

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
`apikit new`

`apikit new api.raml`

`apikit new api.raml -n my-app`

### Listing RAML resources

`apikit list <raml-file>`

##### Examples
`apikit list api.raml`
