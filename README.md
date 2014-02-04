APIKit Node CLI
===============

### Prerequisites

To start using APIKit you'll need the following:

* [Node JS](http://nodejs.org/)
* [NPM](https://npmjs.org/)

### Getting started

1. Clone APIKit - `git clone git@github.com:mulesoft/apikit-node-cli.git`
2. Install APIKit Node CLI globally - `npm install -g /Users/{username}/Projects/apikit-node-cli`
3. Run apikit from a Command Line

## Command line options

| Option            | Default Value  | Description  |
|:------------------|:---------------|:---------------|
| --help            |-               | Shows usage information
| --version         |-               | Shows the version number
| --baseUri         |/api            | Specifies base URI for your API
| --language        |javascript      | Specifies output programming language: javascript, coffeescript
| --target          |output          | Specifies output directory
| --name            |raml-app        | Specifies application name
| --verbose         |-               | Set the verbose level of output
| --quiet           |-               | Silence commands

### Examples

`apikit -n my-app api.raml`
`apikit --language coffeescript https://raw.github.com/mulesoft/apikit-node/master/examples/leagues/leagues.raml`
