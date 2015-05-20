model = require("wordpress.model")

class Helpers
  post_name: (post) =>
    "%s %q"\format(@_(post.post_type), post.post_title)

  post_url: (post) =>
    @url_for 'post', id: post.ID

  post_edit_url: (post) =>
    @url_for 'post-edit', id: post.ID

  post_delete_url: (post) =>
    @url_for 'post-delete', id: post.ID

  post_delete2_url: (post) =>
    @url_for 'post-delete2', id: post.ID

  get_post: (id) =>
    model = require 'wordpress.model'
    Posts = model.Posts
    Posts\find id

  csrf_input: =>
    input type: "hidden", name: "csrf_token", value: @new_csrf
