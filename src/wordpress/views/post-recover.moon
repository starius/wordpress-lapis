import Widget from require "lapis.html"

class Posts extends Widget
  @include require('wordpress.views.helpers')

  content: =>
    post = @get_post @.params.id
    h1 @_("Recover") .. ' ' .. @post_name(post)
    form method: "POST", action: @post_recover2_url(post), ->
      @csrf_input!
      input type: 'submit', value: @_("Confirm")
