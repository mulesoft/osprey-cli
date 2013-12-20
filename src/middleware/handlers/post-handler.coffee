HttpUtils = require '../utils/http-utils'

class ApiKitPostHandler extends HttpUtils
  resolve: (req, res, methodInfo) ->
    # TODO: Add validations

    @negotiateContentType req, res, methodInfo
    @negotiateAcceptType req, res, methodInfo

module.exports = ApiKitPostHandler
