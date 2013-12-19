utils = require 'express/lib/utils'

class UriTemplateReader
  constructor: (@templates) ->
    for template in @templates
      do (template) ->
        regexp = utils.pathRegexp template.uriTemplate, [], false, false
        template.regexp = regexp

  getTemplateFor: (uri) ->
    template = @templates.filter (template) ->
      uri.match(template.regexp)?.length

    if template? and template.length then template[0] else null

module.exports = UriTemplateReader
