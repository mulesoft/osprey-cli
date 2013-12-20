HttpUtils = require '../utils/http-utils'

class ApiKitTraceHandler extends HttpUtils
  resolve: (req, res, methodInfo) ->
    res.send @readStatusCode(methodInfo)

module.exports = ApiKitTraceHandler
