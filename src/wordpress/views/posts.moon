import Widget from require "lapis.html"

class Posts extends Widget
  content: =>
    model = require 'wordpress.model'
    Posts = model.Posts
    for post in *Posts\select!
      div class: "post", ->
        post_url = @url_for 'post', id: post.ID
        a href: post_url, ->
          raw "%s %q"\format post.post_type, post.post_title
