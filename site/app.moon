lapis = require 'lapis'

class extends lapis.Application
  @include "wordpress.admin_app",
    path: "/admin", name: "admin_"

  [index: '/']: =>
    return '<a href="admin/">Admin Panel</a>'
