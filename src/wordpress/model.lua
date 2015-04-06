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
end

model.Users = Model:extend(PREFIX .. "users", {
    primary_key = "ID",
    relations = {
        {"usermeta", has_many="UserMeta", key="user_id"}
    },
})

model.UserMeta = Model:extend(PREFIX .. "usermeta", {
    primary_key = "umeta_id",
    relations = {
        {"user", belongs_to="Users", key="user_id"}
    },
})

-- make `require "models"` return this module
-- Lapis uses it in function add_relations
package.loaded['models'] = model

return model
