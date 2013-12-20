HttpUtils = require '../utils/http-utils'

class ApiKitOptionsHandler extends HttpUtils
  resolve: (req, res, methodInfo) ->
    res.send @readStatusCode(methodInfo)

module.exports = ApiKitOptionsHandler
