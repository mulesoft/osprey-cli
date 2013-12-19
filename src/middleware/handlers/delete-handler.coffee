class ApiKitDeleteHandler
  resolve: (req, res, next, methodInfo) ->
    # TODO: Add validations
    res.send 204

module.exports = ApiKitDeleteHandler
