local log = require("log")

local kv = {
   init = function()
      box.once('init', function()
         kv = box.schema.space.space('kv')
         kv:format({{ name = 'key', type = 'string'}, { name = 'value', type = 'string'}})
         kv:create_index('pk', { parts = { { field = 'key', type = 'string'}}})
         log.info('Successfully created schema kv')
      end)
   end,

   create = function(key, value)
      log.info('Associating key ' .. key .. ' with value ' .. value)
      return box.space.kv:insert{key, value}
   end,

   read = function(key)
      log.info('Reading value with key ' .. key)
      return box.space.kv:select{key}
   end,

   update = function(key, value)
      log.info('Updating  key ' .. key .. ' with value ' .. value)
      return box.space.kv:update({key}, {{'=', 2, value}})
   end,

   delete = function(key)
      log.info('Deleting value associated with key ' .. key)
      return box.space.kv:delete{key}
   end
}

return kv