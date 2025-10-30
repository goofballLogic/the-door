-- src/entities/door.lua
local Door = {}
Door.__index = Door

function Door.new(x, y, w, h)
  local self = setmetatable({}, Door)
  self.x, self.y, self.w, self.h = x, y, w, h
  self.state = "locked"
  return self
end

function Door:setState(s)
  self.state = s
end

function Door:update(dt) end

function Door:draw()
  if self.state == "locked" then
    love.graphics.setColor(0.3, 0.55, 0.9)
    love.graphics.rectangle("fill", self.x, self.y, self.w, self.h)
  else
    love.graphics.setColor(0.3, 0.85, 0.4)
    love.graphics.rectangle("line", self.x, self.y, self.w, self.h)
  end
end

return Door
