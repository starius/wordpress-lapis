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
    "date",
    "mo",
}
build = {
    type = "builtin",
    modules = {
        ['wordpress.model'] = 'src/wordpress/model.lua',
        ['wordpress.admin_app'] = 'src/wordpress/admin_app.lua',
        ['wordpress.random_token'] = 'src/wordpress/random_token.lua',
        ['wordpress.views.layout'] = 'src/wordpress/views/layout.lua',
        ['wordpress.views.helpers'] = 'src/wordpress/views/helpers.lua',
        ['wordpress.views.welcome'] = 'src/wordpress/views/welcome.lua',
        ['wordpress.views.posts'] = 'src/wordpress/views/posts.lua',
        ['wordpress.views.post'] = 'src/wordpress/views/post.lua',
        ['wordpress.views.post-delete'] = 'src/wordpress/views/post-delete.lua',
        ['wordpress.views.post-recover'] = 'src/wordpress/views/post-recover.lua',
        ['wordpress.views.posts-deleted'] = 'src/wordpress/views/posts-deleted.lua',
    },
}
