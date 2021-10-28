local log = require("log")

local kv = {
   errors = {
      DUPLICATE = 1,
      NOT_FOUND = 2,
   },

   init = function()
      box.once('init', function()
         kv = box.schema.space.create('kv')
         kv:format({{ name = 'key', type = 'string'}, { name = 'value', type = 'string'}})
         kv:create_index('pk', { parts = { { field = 'key', type = 'string'}}})
         log.info('Successfully created schema kv')
      end)
   end,

   create = function(self, key, value)
      log.info('Associating key ' .. key .. ' with value ' .. value)
      if self:read(key) then
         return true, self.errors.DUPLICATE
      else
         box.space.kv:insert{key, value}
         return nil
      end
   end,

   read = function(self, key)
      log.info('Reading value with key ' .. key)
      first_tuple = box.space.kv:select{key}[1]
      if first_tuple then
         return first_tuple[2]
      else
         return
      end
   end,

   update = function(self, key, value)
      log.info('Updating  key ' .. key .. ' with value ' .. value)

      if self:read(key) then
         box.space.kv:update({key}, {{'=', 2, value}})
         return
      else
         return true, self.errors.NOT_FOUND
      end
   end,

   delete = function(self, key)
      log.info('Deleting value associated with key ' .. key)

      if self:read(key) then
         box.space.kv:delete{key}
         return
      else
         return true, self.errors.NOT_FOUND
      end
   end
}

return kv