import Widget from require "lapis.html"

class Posts extends Widget
  content: =>
    model = require 'wordpress.model'
    Posts = model.Posts
    post = Posts\find @.params.id
    raw post.post_content
