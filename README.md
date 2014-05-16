Osprey CLI
==========

The Command Line Interface (CLI) scaffolding tool to generate [Osprey](https://github.com/mulesoft/osprey)-based applications, ideally from a pre-defined [RAML](raml.org) API spec, with just a single command.

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
If you are interesting in contributing some code to this project, thanks! Please submit a [Contributors Agreement](https://api-notebook.anypoint.mulesoft.com/notebooks#bc1cf75a0284268407e4) acknowledging that you are transferring ownership.

To discuss this project, please use its github issues or the [RAML forum](http://forums.raml.org/).

### Prerequisites

To start using Osprey CLI you'll need the following:

* [Node JS](http://nodejs.org/)
* [NPM](https://npmjs.org/)

### Getting started

Install Osprey CLI globally - `npm install -g git+https://github.com/mulesoft/osprey-cli.git`.

#### Creating a new application

`osprey new [raml-file or path-to-raml] [options]`

For `[raml-file or path-to-raml]` you can specify either a RAML file or a folder containing a RAML definition distributed in several files.
In both cases, the original file will be copied and placed on a subfolder inside the generated project structure: `[output folder]/src/assets/raml` (where `[output folder]` is specified by the `--target` parameter).

| Option            | Default Value  | Description  |
|:------------------|:---------------|:---------------|
| --help            |-               | Shows usage information
| --version         |-               | Shows the version number
| --baseUri         |/api            | Specifies base URI for your API
| --language        |javascript      | Specifies output programming language: javascript, coffeescript
| --target          |cwd             | Specifies output directory
| --name            |-               | Specifies application name. This parameter is required.
| --verbose         |-               | Sets the verbose level of output
| --quiet           |-               | Silences commands

##### Examples
`osprey new --name my-app` or `osprey new -n my-app`

`osprey new api.raml --name my-app` or `osprey new api.raml -n my-app`

#### Listing RAML resources

`osprey list <raml-file>`

##### Examples
`osprey list api.raml`

#### Run API

##### Prerequisites
Before the API could be up and running it is necessary to add a dependency to package.json.
Inside "dependencies" add the following line:

`"osprey": "git+ssh://git@github.com:mulesoft/osprey.git"`

Your package.json should looks like:

```javascript
{
  "name": "raml-app",
  "version": "0.0.1",
  "private": true,
  "dependencies": {
    "express": "3.4.4",
    "osprey": "git+ssh://git@github.com:mulesoft/osprey.git"
  },
  "devDependencies": {
    "grunt": "~0.4.2",
    "grunt-contrib-watch": "~0.5.3",
    "grunt-contrib-copy": "~0.4.1",
    "grunt-contrib-clean": "~0.5.0",
    "grunt-mocha-test": "~0.8.1",
    "mocha": "1.15.1",
    "should": "2.1.1",
    "grunt-express-server": "~0.4.13",
    "load-grunt-tasks": "~0.2.1",
    "supertest": "~0.8.2",
    "grunt-contrib-jshint": "~0.8.0"
  }
}
```


**Note**: This is a temporary hack until osprey is released to npm

##### Running the API
From your terminal run:
`grunt` (recommended: It will set up the proper listeners so changes in the code are automatically refreshed in runtime).

**OR** you can always run: `node src/app.js`
