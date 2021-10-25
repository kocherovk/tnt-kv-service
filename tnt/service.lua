local kv = require('kv')
local string = require('string')
local json = require('json')

box.cfg{listen=3301}
kv.init()

function handle(request)
    key = string.split(request.uri, '/')[3]

    if request.method == "POST" then
        body = json.decode(request.body)
        return kv.create(body.key, body.value)
    end

    if request.method == "GET" then
        return kv.read(key)
    end

    if request.method == "PUT" then
        body = json.decode(request.body)
        return kv.update(key, body.value)
    end

    if request.method == "DELETE" then
        return kv.delete(key)
    end
end
