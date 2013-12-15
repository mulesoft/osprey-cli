exports.get = (req, res) ->
  {% if example -%}
    {% autoescape false -%}
  res.send({{example}})
    {% endautoescape -%}
  {% endif -%}

  #Add your code here