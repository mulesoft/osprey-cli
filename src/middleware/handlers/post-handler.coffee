HttpUtils = require '../utils/http-utils'

class ApiKitPostHandler extends HttpUtils
  resolve: (req, res, methodInfo) ->
    # TODO: Add validations
    statusCode = @readStatusCode(methodInfo)

    # Content-Type Validation
    isValidContentType = false

    for mimeType of methodInfo.body
      if req.is(mimeType) or not req.get('Content-Type')?
        isValidContentType = true
        break

    unless isValidContentType
      res.send 415

    # Accept Validation
    isValidAcceptType = false
    response = null

    for mimeType of methodInfo.responses[statusCode].body
      if req.accepts(mimeType)
        res.set 'Content-Type', mimeType
        response = methodInfo.responses[statusCode].body[mimeType].example
        isValidAcceptType = true
        break

    console.log not isValidAcceptType && not methodInfo.responses[statusCode].body?

    if not isValidAcceptType && methodInfo.responses[statusCode].body?
      res.send 406

    res.send(response || statusCode)

module.exports = ApiKitPostHandler
