local current = nil

local function require_room(name)
  return require(name)
end

local M = {}

function M.set(name, ...)
  if current and current.teardown then current.teardown() end
  package.loaded[name] = nil -- allow hot-reload during dev
  local room = require_room(name)
  current = room
  if current and current.load then current.load(...) end
end

function M.update(dt)
  if current and current.update then current.update(dt) end
end

function M.draw()
  if current and current.draw then current.draw() end
end

function M.keypressed(key)
  if current and current.keypressed then current.keypressed(key) end
end

function M.keyreleased(key)
  if current and current.keyreleased then current.keyreleased(key) end
end

return M
