class ApiKitGetHandler
  resolve: (req, res, methodInfo) ->
    # TODO: Add validations
    response = 415

    for mimeType of methodInfo.responses?['200']?.body
      if req.accepts(mimeType)
        res.set 'Content-Type', mimeType
        response = methodInfo.responses['200'].body[mimeType].example

    res.send response

module.exports = ApiKitGetHandler
