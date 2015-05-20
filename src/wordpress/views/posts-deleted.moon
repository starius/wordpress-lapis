import Widget from require "lapis.html"

class Posts extends Widget
  @include require('wordpress.views.helpers')

  content: =>
    model = require 'wordpress.model'
    h1 @_("Published posts")
    ul ->
      for post in *model.deletedPosts!
        li ->
          a href: @post_url(post), ->
            raw @post_name(post)
