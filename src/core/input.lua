local M = { held = {} }

function M.update(dt) end

function M.keypressed(key)
  M.held[key] = true
end

function M.keyreleased(key)
  M.held[key] = false
end

function M.isDown(...)
  for i=1,select("#", ...) do
    local k = select(i, ...)
    if love.keyboard.isDown(k) then return true end
  end
  return false
end

return M
