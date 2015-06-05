local schema = require("lapis.db.schema")
local Model = require("lapis.db.model").Model
local config = require("lapis.config").get()

local model = {}

local PREFIX = "wp_"

function model.create_schema()
    local types = {
        text = schema.types.varchar,
        varchar = schema.types.varchar,
        integer = schema.types.integer,
        boolean = schema.types.boolean,
    }
    if config.postgres then
        types.id = schema.types.serial({primary_key=true})
        types.foreign_key = schema.types.foreign_key
        types.datetime = schema.types.time
    elseif config.mysql then
        types.id = schema.types.id
        types.foreign_key = schema.types.integer
        types.datetime = schema.types.datetime
    else
        error('Unknown database type')
    end

    schema.create_table(PREFIX .. "users", {
        {"ID", types.id},
        {"user_login", types.varchar(60)},
        {"user_pass", types.varchar(64)},
        {"user_nicename", types.varchar(50)},
        {"user_email", types.varchar(100)},
        {"user_url", types.varchar(100)},
        {"user_registered", types.datetime},
        {"user_activation_key", types.varchar(60)},
        {"user_status", types.integer({default="0"})},
        {"display_name", types.varchar(250)},
    })

    schema.create_table(PREFIX .. "usermeta", {
        {"umeta_id", types.id},
        {"user_id", types.foreign_key},
        {"meta_key", types.varchar(255)},
        {"meta_value", types.text},
    })

    schema.create_table(PREFIX .. "posts", {
        {"ID", types.id},
        {"post_author", types.foreign_key},
        {"post_date", types.datetime},
        {"post_date_gmt", types.datetime},
        {"post_content", types.text},
        {"post_title", types.text},
        {"post_excerpt", types.text},
        {"post_status", types.varchar(20, {default="publish"})},
        {"comment_status", types.varchar(20, {default="open"})},
        {"ping_status", types.varchar(20, {default="open"})},
        {"post_password", types.varchar(20)},
        {"post_name", types.varchar(200)},
        {"to_ping", types.text},
        {"pinged", types.pinged},
        {"post_modified", types.datetime},
        {"post_modified_gmt", types.datetime},
        {"post_content_filtered", types.text},
        {"post_parent", types.foreign_key},
        {"guid", types.varchar(255)},
        {"menu_order", types.integer},
        {"post_type", types.varchar(20, {default="post"})},
        {"post_mime_type", types.varchar(100)},
        {"comment_count", types.integer({default=0})},
    })

    schema.create_table(PREFIX .. "postmeta", {
        {"meta_id", types.id},
        {"post_id", types.foreign_key},
        {"meta_key", types.varchar(255)},
        {"meta_value", types.text},
    })

    schema.create_table(PREFIX .. "comments", {
        {"comment_ID", types.id},
        {"comment_post_ID", types.foreign_key},
        {"comment_author", types.text},
        {"comment_author_email", types.varchar(100)},
        {"comment_author_url", types.varchar(200)},
        {"comment_author_IP", types.varchar(100)},
        {"comment_date", types.datetime},
        {"comment_date_gmt", types.datetime},
        {"comment_content", types.text},
        {"comment_karma", types.integer},
        {"comment_approved", types.varchar(20, {default=1})},
        {"comment_agent", types.varchar(255)},
        {"comment_type", types.varchar(20)},
        {"comment_parent", types.foreign_key},
        {"user_id", types.foreign_key},
    })

    schema.create_table(PREFIX .. "commentmeta", {
        {"meta_id", types.id},
        {"comment_id", types.foreign_key},
        {"meta_key", types.varchar(255)},
        {"meta_value", types.text},
    })

    schema.create_table(PREFIX .. "terms", {
        {"term_id", types.id},
        {"name", types.varchar(200)},
        {"slug", types.varchar(200)},
        {"term_group", types.integer({default=0})},
    })

    schema.create_table(PREFIX .. "term_relationships", {
        {"object_id", types.id},
        {"term_taxonomy_id", types.foreign_key},
        {"term_order", types.integer},
    })

    schema.create_table(PREFIX .. "term_taxonomy", {
        {"term_taxonomy_id", types.id},
        {"term_id", types.foreign_key},
        {"taxonomy", types.varchar(32)},
        {"description", types.text},
        {"parent", types.foreign_key},
        {"count", types.integer({default=0})},
    })

    schema.create_table(PREFIX .. "links", {
        {"link_id", types.id},
        {"link_url", types.varchar(255)},
        {"link_name", types.varchar(255)},
        {"link_image", types.varchar(255)},
        {"link_target", types.varchar(25)},
        {"link_description", types.varchar(255)},
        {"link_visible", types.varchar(20, {default='Y'})},
        {"link_owner", types.foreign_key({default=1})},
        {"link_rating", types.integer},
        {"link_updated", types.datetime},
        {"link_rel", types.varchar(255)},
        {"link_notes", types.text},
        {"link_rss", types.varchar(255)},
    })

    schema.create_table(PREFIX .. "options", {
        {"option_id", types.id},
        {"option_name", types.varchar(54)},
        {"option_value", types.text},
        {"autoload", types.varchar(20, {default='yes'})},
    })
end

model.Users = Model:extend(PREFIX .. "users", {
    primary_key = "ID",
    relations = {
        {"usermeta", has_many="UserMeta", key="user_id"},
    },
})

model.UserMeta = Model:extend(PREFIX .. "usermeta", {
    primary_key = "umeta_id",
    relations = {
        {"user", belongs_to="Users", key="user_id"},
    },
})

model.Posts = Model:extend(PREFIX .. "posts", {
    primary_key = "ID",
    relations = {
        {"author", belongs_to="Users", key="post_author"},
        {"parent", belongs_to="Posts", key="post_parent"},
        {"comments", has_many="Comments", key="comment_post_ID"},
    },
})

model.PostMeta = Model:extend(PREFIX .. "postmeta", {
    primary_key = "meta_id",
    relations = {
        {"post", belongs_to="Posts", key="post_id"},
    },
})

model.Comments = Model:extend(PREFIX .. "comments", {
    primary_key = "comment_ID",
    relations = {
        {"post", belongs_to="Posts", key="comment_post_ID"},
        {"parent", belongs_to="Comments", key="comment_parent"},
        {"user", belongs_to="Users", key="user_id"},
    },
})

model.CommentMeta = Model:extend(PREFIX .. "commentmeta", {
    primary_key = "meta_id",
    relations = {
        {"comment", belongs_to="Comments", key="comment_id"},
    },
})

model.Terms = Model:extend(PREFIX .. "terms", {
    primary_key = "term_id",
})

model.TermRelationships = Model:extend(
        PREFIX .. "term_relationships", {
    primary_key = {"object_id", "term_taxonomy_id"},
    relations = {
        -- TODO object_id can be post or link
        --{"post", belongs_to="Posts", key="object_id"},
        {"term_taxonomy", belongs_to="TermTaxonomy",
            key="term_taxonomy_id"},
    },
})

model.TermTaxonomy = Model:extend(PREFIX .. "term_taxonomy", {
    primary_key = "term_taxonomy_id",
    relations = {
        {"term", belongs_to="Terms", key="term_id"},
        {"parent", belongs_to="TermTaxonomy", key="parent"},
    },
})

model.Links = Model:extend(PREFIX .. "links", {
    primary_key = "link_id",
    relations = {
        {"owner", belongs_to="Users", key="link_owner"},
    },
})

model.Options = Model:extend(PREFIX .. "options", {
    primary_key = "option_id",
})

-- make `require "models"` return this module
-- Lapis uses it in function add_relations
package.loaded['models'] = model

function model.checkPassword(username, password)
    local user = model.Users:find({user_login=username})
    if not user then
        return nil, 'No such user'
    end
    local phpass = require 'phpass'
    return phpass.checkPassword(password, user.user_pass)
end

function model.publishedPosts()
    return model.Posts:select("where post_status = ?",
      'publish')
end

function model.deletedPosts()
    return model.Posts:select("where post_status = ?", 'trash')
end

function model.deletePost(post_id)
    local post = model.Posts:find(post_id)
    post:update {post_status = 'trash'}
end

function model.recoverPost(post_id)
    local post = model.Posts:find(post_id)
    post:update {post_status = 'publish'}
end

function model.updatePost(post_id, title, content)
    local post = model.Posts:find(post_id)
    post:update {post_title = title, post_content=content}
end

return model
