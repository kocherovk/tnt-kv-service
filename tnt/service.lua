local kv = require('kv')
local string = require('string')
local json = require('json')
local log = require("log")
local RateLimiter = require("rate-limiter")

local RESULT = {
    OK = {200, 'ok'},
    NOT_FOUND = {404, "not found"}
}

box.cfg{listen=3301}
kv:init()

local limit = os.getenv("RATE_LIMIT")
if limit == nil then
    limit = 60
else
    limit = tonumber(limit)
end

local rl = RateLimiter.new(2)


function create(key, value)
    fail, err = kv:create(key, value)

    if fail and err == kv.errors.DUPLICATE then
        return { 409, "key '" .. key .. "' already exists" }
    end

    return RESULT.OK
end


function read(key)
    result = kv:read(key)

    if result then
        return { 200, json.decode(result) }
    else
        return RESULT.NOT_FOUND
    end
end

function update(key, value)
    fail, err = kv:update(key, value)

    if fail and err == kv.errors.NOT_FOUND then
        return RESULT.NOT_FOUND
    end

    return RESULT.OK
end

function delete(key)
    fail, err =  kv:delete(key)

    if fail and err == kv.errors.NOT_FOUND then
        return RESULT.NOT_FOUND
    end

    return RESULT.OK
end

function handle(request)
    fail = RateLimiter.inc(rl)
    if fail then
        return { 429, "rate limit exceeded" }
    end

    log.info('Accepted request ' .. request.method .. " " ..  request.uri)
    key = string.split(request.uri, '/')[3]

    body = nil
    if request.body then
        ok, result = pcall(json.decode, request.body)
        if not ok then
            return { 400, result }
        end
        body = result
    end

    if request.method == "POST" then
        return create(body.key, json.encode(body.value))
    elseif request.method == "GET" then
        return read(key)
    elseif request.method == "PUT" then
        return update(key, json.encode(body.value))
    elseif request.method == "DELETE" then
        return delete(key)
    end
end
