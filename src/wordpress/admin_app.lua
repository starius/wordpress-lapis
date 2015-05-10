local lapis = require("lapis")

local app = lapis.Application()

app:get("index", "/", function()
    return "Hello!"
end)

return app
