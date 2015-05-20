import Widget from require "lapis.html"

class Posts extends Widget
  @include require('wordpress.views.helpers')

  content: =>
    model = require 'wordpress.model'
    h1 @_("Published posts")
    ul ->
      for post in *model.publishedPosts!
        li ->
          @post_link post
    a href: @deleted_posts_url!, ->
      raw @_("Deleted posts")
