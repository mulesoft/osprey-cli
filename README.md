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

### Run API

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
    "supertest": "~0.8.2",
    "grunt-nodemon": "~0.1.2",
    "grunt-concurrent": "~0.4.2",
    "load-grunt-tasks": "~0.2.1",
    "grunt-wait": "~0.1.0",
    "grunt-contrib-jshint": "~0.8.0"
  }
}
```


**Note**: This is a temporary hack until osprey is released to npm

##### Running the API
From your terminal run:
`grunt`



