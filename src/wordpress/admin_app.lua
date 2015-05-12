local lapis = require("lapis")
local http = require("lapis.nginx.http")
local csrf = require("lapis.csrf")
local random_token = require("wordpress.random_token")

local model = require("wordpress.model")

local app = lapis.Application()

app.layout = require("views.layout")

app.cookie_attributes = function(self)
    local expires = date(true):adddays(365):fmt("${http}")
    return "Expires=" .. expires .. "; Path=/; HttpOnly"
end

-- FIXME https://github.com/leafo/lapis/issues/188
app.__class:before_filter(function(self)
    local lang = self.session.lang
    local accept = self.req.headers['Accept-Language']
    if not lang and accept then
        lang = accept:sub(1, 2)
    end
    local tr
    if lang == 'ru' then
        tr = require 'mo'('ru/messages.mo')
    else
        tr = function(t) return t end
    end
    self._ = function(a, t)
        return tr(t)
    end
    self.title = self:_("Lapis for Wordpress")
end)

local check_csrf = function(f)
    return function(self)
        local key = self.session.key
        local csrf_ok, msg = csrf.validate_token(self, key)
        if not key or not csrf_ok then
            self.title = self:_("Permission denied")
            return self:_("Bad csrf token") .. ' ' .. msg
        else
            return f(self)
        end
    end
end

local gen_csrf = function(f)
    return function(self)
        local key = self.session.key
        if not key then
            key = 'csrf' .. random_token()
            self.session.key = key
        end
        self.new_csrf = csrf.generate_token(self, key)
        return f(self)
    end
end

local any_csrf = function(f)
    return function(self)
        if next(self.req.params_post) then
            -- POST
            return gen_csrf(check_csrf(f))(self)
        else
            return gen_csrf(f)(self)
        end
    end
end

local check_user = function(f)
    return any_csrf(function(self)
        if not self.session.user then
            return {redirect_to=self:url_for('index')}
        else
            -- set admin flag
            return f(self)
        end
    end)
end

app:get("index", "/", gen_csrf(function(self)
    if self.session.user then
        return {redirect_to = self:url_for('dashboard')}
    else
        -- TODO
        return {render = 'wordpress.views.welcome'}
    end
end))

app:post("login", "/login", check_csrf(function(self)
    local user = self.req.params_post.user
    -- TODO
    self.session.user = user
    return {redirect_to = self:url_for('dashboard')}
end))

app:post("logout", "/logout", check_user(function(self)
    self.session.user = nil
    return {redirect_to = self:url_for('index')}
end))

app:get("russian", "/ru", function(self)
    self.session.lang = 'ru'
    return {redirect_to = self.req.headers.Referer}
end)

app:get("english", "/en", function(self)
    self.session.lang = 'en'
    return {redirect_to = self.req.headers.Referer}
end)

return app
