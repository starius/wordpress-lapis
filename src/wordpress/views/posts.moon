import Widget from require "lapis.html"

class Posts extends Widget
  @include require('wordpress.views.helpers')

  content: =>
    model = require 'wordpress.model'
    Posts = model.Posts
    for post in *Posts\select!
      div class: "post", ->
        a href: @post_url(post), ->
          raw @post_name(post)
