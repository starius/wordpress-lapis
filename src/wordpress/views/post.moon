import Widget from require "lapis.html"

class Posts extends Widget
  @include require('wordpress.views.helpers')

  content: =>
    post = @get_post @.params.id
    h1 @post_name(post)
    raw @_("Status") .. ': ' .. @_(post.post_status)
    raw " | "
    a href: @post_edit_url(post), ->
      raw @_("Edit")
    raw " | "
    if post.post_status != 'trash'
      a href: @post_delete_url(post), ->
        raw @_("Delete")
    else
      a href: @post_recover_url(post), ->
        raw @_("Recover")
    div class: "post", ->
      raw post.post_content
    @comments_list(post)
