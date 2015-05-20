import Widget from require "lapis.html"

class Posts extends Widget
  @include require('wordpress.views.helpers')

  content: =>
    post = @get_post @.params.id
    h1 @_("Edit") .. ' ' .. @post_name(post)
    form method: "POST", action: @post_edit2_url(post), ->
      @csrf_input!
      input type: 'text', name: 'title', value: post.post_title
      br!
      @tinymce('content', post.post_content)
      br!
      input type: 'submit', value: @_("Save")
