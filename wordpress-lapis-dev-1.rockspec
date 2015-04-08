package = "wordpress-lapis"
version = "dev-1"
source = {
    -- compile moonscript to Lua
    url = "git://github.com/starius/wordpress-lapis.git"
}
description = {
    summary = "Wordpress binding for Lapus",
    homepage = "https://github.com/starius/wordpress-lapis",
    license = "MIT",
}
dependencies = {
    "lua >= 5.1",
    "lapis",
}
build = {
    type = "builtin",
    modules = {
        ['wordpress.model'] = 'src/wordpress/model.lua',
        ['wordpress.admin_app'] = 'src/wordpress/admin_app.lua',
    },
}
