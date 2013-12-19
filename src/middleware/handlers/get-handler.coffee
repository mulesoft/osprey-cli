class ApiKitGetHandler
  resolve: (req, res, next, methodInfo) ->
    # TODO: Add validations
    for mimeType of methodInfo.responses?['200']?.body
      if req.accepts(mimeType)
        res.set 'Content-Type', mimeType
        res.send methodInfo.responses['200'].body[mimeType].example
        next()

    res.send 415

module.exports = ApiKitGetHandler
