import Widget from require "lapis.html"

class Posts extends Widget
  content: =>
    model = require 'wordpress.model'
    Posts = model.Posts
    post = Posts\find @.params.id
    h1 "%s %q"\format post.post_type, post.post_title
    a href: (@url_for 'post-edit', id: post.ID), ->
      raw @_("Edit")
    raw " | "
    a href: (@url_for 'post-delete', id: post.ID), ->
      raw @_("Delete")
    div class: "post", ->
      raw post.post_content
