class ApiKitPostHandler
  resolve: (req, res, next, methodInfo) ->
    # TODO: Add validations
    # TODO: Add content negotiation
    res.contentType 'application/json'
    res.send 201

module.exports = ApiKitPostHandler
