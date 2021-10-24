local log = require("log")

local db = {}

local kv = {
   create = function(key, value)
      log.info('Associating key ' .. key .. ' with value ' .. value)

      db[key] = value
      return "ok"
   end,

   read = function(key)
      log.info('Reading value with key ' .. key)

      return db[key]
   end,

   update = function(key, value)
      log.info('Updating  key ' .. key .. ' with value ' .. value)
      db[key] = value
      return "ok"
   end,

   delete = function(key)
      log.info('Deleting value associated with key ' .. key)
      db[key] = nil
      return "ok"
   end
}

return kv