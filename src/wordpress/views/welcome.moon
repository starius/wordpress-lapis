import Widget from require "lapis.html"

class Welcome extends Widget
  content: =>
    div class: "body", ->
      p @_("Welcome to Lapis Wordpress Admin!")
      form method: "POST", action: @url_for("login"), ->
        input {type: "hidden", name: "csrf_token",
            value: @new_csrf}
        text @_("Your username: ")
        input type: "text", name: "username"
        br!
        text @_("Your password: ")
        input type: "password", name: "password"
        input type: "submit", value: @_("Login")
