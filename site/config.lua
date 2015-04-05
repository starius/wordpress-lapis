local config = require("lapis.config")

config({"development", "production"}, {
  port = 3176,
  secret = require('secret'),
  mysql = {
    backend = "lua_resty_mysql", -- or luasql
    host = "127.0.0.1",
    user = "wordpress",
    password = "wordpress",
    database = "wordpress",
  }
})

config("production", {
    code_cache = 'on',
    logging = {queries = false, requests = false},
})
