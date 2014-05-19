Osprey CLI
==========

[![NPM version](https://badge.fury.io/js/osprey-cli.svg)](http://badge.fury.io/js/osprey-cli)
[![Build Status](https://travis-ci.org/mulesoft/osprey-cli.png)](https://travis-ci.org/mulesoft/osprey-cli)
[![Dependency Status](https://david-dm.org/mulesoft/osprey-cli.png)](https://david-dm.org/mulesoft/osprey-cli)

The Command Line Interface (CLI) scaffolding tool to generate [Osprey](https://github.com/mulesoft/osprey)-based applications, ideally from a pre-defined [RAML](http://raml.org) API spec, with just a single command.

### Important
The current release of Osprey CLI is very much a work in progress. As it is in active use within a number of rapid development projects, it too is evolving with the needs those projects uncover. While it is proving extremely beneficial, because it's still evolving rapidly we don't yet feel it meets our criteria for a first fully stable release.

**We encourage you to use it and participate by raising issues, providing feedback or contributing your own code (see below)**

### Coming Soon
Please check the  [Osprey CLI 1.0 Milestone](https://github.com/mulesoft/osprey-cli/issues?milestone=1&state=open) issues list to stay up-to-date with the immediate roadmap.

### Fundamentals
Osprey-CLI creates an Osprey-based application by invoking a command and specifying a few parameters.
As result, you will get the skeleton of an Osprey application (coded in JavaScript or CoffeeScript) to start working right away.

### Related projects
Check out the main [Osprey](https://github.com/mulesoft/osprey) project itself for information about the framework on which this tool generates applications.

### Contributing
If you are interested in contributing some code to this project, thanks! Please submit a [Contributors Agreement](https://api-notebook.anypoint.mulesoft.com/notebooks#bc1cf75a0284268407e4) acknowledging that you are transferring ownership.

To discuss this project, please use its github issues or the [RAML forum](http://forums.raml.org/).

### Prerequisites

To start using Osprey CLI you'll need the following:

* [Node JS](http://nodejs.org/)
* [NPM](https://npmjs.org/)

### Getting started

Install Osprey CLI globally - `npm install -g osprey-cli`.

#### Creating a new application

`osprey new [raml-file or path-to-raml] [options]`

For `[path-to-raml-file or path-to-raml-folder]` you can specify either the path to either a RAML file or a folder containing a RAML definition distributed across several files. In both cases, the original file(s) will be copied to a subfolder inside the generated project structure: `[output folder]/src/assets/raml` (where `[output folder]` is specified by the `--target` parameter).

| Option            | Default Value  | Description  |
|:------------------|:---------------|:---------------|
| --help            |-               | Shows usage information
| --version         |-               | Shows the version number
| --baseUri         |/api            | Specifies base URI for your API
| --language        |javascript      | Specifies output programming language: javascript, coffeescript
| --target          |cwd             | Specifies output directory
| --name            |-               | Specifies application name. __This parameter is required.__
| --verbose         |-               | Sets the verbose level of output
| --quiet           |-               | Silences commands

##### Examples
`osprey new --name my-app` or `osprey new -n my-app`

`osprey new api.raml --name my-app`

`osprey new resources/specs -n my-app -l coffeescript`

#### Bonus utility: Listing RAML resources in any RAML file

`osprey list <raml-file>`

e.g.:

`osprey list api.raml`

##### Running the API
From your terminal run:
`grunt` (recommended: It will set up the proper listeners so changes in the code are automatically refreshed in runtime).

**OR** you can always run: `node src/app.js`
