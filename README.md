APIKit Node CLI
===============

### Prerequisites

To start using APIKit you'll need the following:

* [Node JS](http://nodejs.org/)
* [NPM](https://npmjs.org/)

### Getting started

1. Clone APIKit - `git clone git@github.com:mulesoft/apikit-node-cli.git`
2. Resolve dependencies - `npm install`
3. Compile APIKit - `grunt release`
4. Install APIKit Node CLI globally - `npm install -g /Users/{username}/Projects/apikit-node-cli`
5. Run apikit from a Command Line

## Command line options

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

### Usage

`apikit new <raml-file or path-to-raml> [options]`

### Examples
`apikit new`

`apikit new api.raml`

`apikit new api.raml -n my-app`
