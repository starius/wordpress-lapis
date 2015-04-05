local lapis = require("lapis")
local console = require("lapis.console")

local app = lapis.Application()

app:get("/", function()
  return "Welcome to Lapis " .. require("lapis.version")
end)

app:match("console", "/console", console.make())

return app
