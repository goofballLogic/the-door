package.path = package.path .. ";src/?.lua;src/?/init.lua;src/core/?.lua;src/entities/?.lua;src/rooms/?.lua;src/systems/?.lua"

local BASE_W, BASE_H = 480, 320
local SCALE = 2

local room_manager = require("room_manager")
local input = require("input")

function love.load()
  love.window.setTitle("Room → Switch → Door (Starter)")
  love.window.setMode(BASE_W * SCALE, BASE_H * SCALE, {resizable=true})
  love.graphics.setDefaultFilter("nearest", "nearest")

  room_manager.set("room_one")
end

function love.update(dt)
  input.update(dt)
  room_manager.update(dt)
end

function love.draw()
  love.graphics.push()
  love.graphics.scale(SCALE, SCALE)
  room_manager.draw()
  love.graphics.pop()

  love.graphics.setColor(1,1,1,0.8)
  love.graphics.print("Move: WASD/Arrows   Interact: E", 8, 8)
end

function love.keypressed(key)
  input.keypressed(key)
  room_manager.keypressed(key)
end

function love.keyreleased(key)
  input.keyreleased(key)
  room_manager.keyreleased(key)
end