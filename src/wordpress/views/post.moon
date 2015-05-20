import Widget from require "lapis.html"

class Posts extends Widget
  @include require('wordpress.views.helpers')

  content: =>
    post = @get_post @.params.id
    h1 @post_name(post)
    a href: @post_edit_url(post), ->
      raw @_("Edit")
    raw " | "
    a href: @post_delete_url(post), ->
      raw @_("Delete")
    div class: "post", ->
      raw post.post_content
