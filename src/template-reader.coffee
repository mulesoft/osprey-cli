class TemplateReader
  constructor: (@templates) ->
    for template in @templates
      do (template) ->
        regexp = utils.pathRegexp template.uriTemplate, [], false, false
        template.regexp = regexp

  getTemplateFor: (uri) ->
    template = @templates.filter (template) ->
      uri.match(template.regexp)?.length

    if template? and template.length then template[0] else null

  getUriParametersFor: (uri) ->
    template = @getTemplateFor uri
    return null unless template?
    matches = uri.match template.regexp
    keys = template.uriTemplate.match template.regexp
    uriParameters = {}
    for i in [1..(keys.length - 1)]
      uriParameters[keys[i].replace ':', ''] = matches[i]
    uriParameters
