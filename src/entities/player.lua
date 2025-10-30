local input = require("input")
local collision = require("collision")

local Player = {}
Player.__index = Player

local SPRITE = nil
local SPRITE_W, SPRITE_H = 20, 24

function Player.new(x, y)
  local self = setmetatable({}, Player)
  self.x, self.y = x, y
  self.w, self.h = 14, 18
  self.speed = 120
  if not SPRITE then
    SPRITE = love.graphics.newImage("assets/sprites/player.png")
    SPRITE:setFilter("nearest", "nearest")
    SPRITE_W, SPRITE_H = SPRITE:getWidth(), SPRITE:getHeight()
  end
  return self
end

function Player:update(dt, colliders)
  local dx, dy = 0, 0
  if input.isDown("left","a")  then dx = dx - self.speed * dt end
  if input.isDown("right","d") then dx = dx + self.speed * dt end
  if input.isDown("up","w")    then dy = dy - self.speed * dt end
  if input.isDown("down","s")  then dy = dy + self.speed * dt end
  collision.moveAndCollide(self, dx, dy, colliders)
end

function Player:draw()
  love.graphics.setColor(1,1,1,1)
  if SPRITE then
    love.graphics.draw(SPRITE, self.x - (SPRITE_W - self.w)/2, self.y - (SPRITE_H - self.h)/2)
  else
    love.graphics.rectangle("fill", self.x, self.y, self.w, self.h)
  end
end

return Player
