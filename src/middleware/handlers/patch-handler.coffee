HttpUtils = require '../utils/http-utils'

class ApiKitPatchHandler extends HttpUtils
  resolve: (req, res, methodInfo) ->
    res.send @readStatusCode(methodInfo)

module.exports = ApiKitPatchHandler
