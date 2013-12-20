HttpUtils = require '../utils/http-utils'

class ApiKitPostHandler extends HttpUtils
  resolve: (req, res, methodInfo) ->
    # TODO: Add validations
    # TODO: Add content negotiation
    res.contentType 'application/json'
    res.send @readStatusCode(methodInfo)

module.exports = ApiKitPostHandler
