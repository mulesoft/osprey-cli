winston = require 'winston'

logger = new(winston.Logger)({
  transports: [
      new(winston.transports.Console)()
  ]})

logLevel = 'info'

exports.setLevel = (level) ->
  logLevel = level if level?

exports.info = (message) ->
  if logLevel in ['info', 'debug']
    logger.info 'osprey-cli', message

exports.error = (message) ->
  if logLevel in ['info', 'debug']
    logger.error 'osprey-cli', message

exports.warn = (message) ->
  if logLevel in ['info', 'debug']
    logger.warn 'osprey-cli', message

exports.debug = (message) ->
  if logLevel in ['debug']
    logger.debug 'osprey-cli', message

exports.data = (description, data) ->
  if logLevel in ['debug']
    logger.debug 'osprey-cli', description.data
    for key,value of data
      logger.debug 'osprey-cli', "  #{key}: #{value}".replace(/\n$/, '').data
