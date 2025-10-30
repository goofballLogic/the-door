local Room = {}
Room.__index = Room

function Room:new()
  local r = setmetatable({}, self)
  return r
end

function Room:load() end
function Room:update(dt) end
function Room:draw() end
function Room:keypressed(key) end
function Room:keyreleased(key) end
function Room:teardown() end

return Room
