-- Mobile-optimized version of Library.lua

-- Proper viewport clamping
function clampViewport(width, height)
    local minWidth, minHeight = 320, 480  -- Minimum dimensions for mobile
    return math.max(minWidth, math.min(width, 1920)), math.max(minHeight, math.min(height, 1080))
end

-- Touch input support
function handleTouchInput(touch)
    if touch.phase == "began" then
        -- Handle touch start
    elseif touch.phase == "moved" then
        -- Handle touch move
    elseif touch.phase == "ended" then
        -- Handle touch end
    end
end

-- Responsive UI scaling
function scaleUI(width, height)
    local scaleX = width / 1920
    local scaleY = height / 1080
    return scaleX, scaleY
end

-- Usage example
local viewportWidth, viewportHeight = clampViewport(display.contentWidth, display.contentHeight)
local scaleX, scaleY = scaleUI(viewportWidth, viewportHeight)

-- Initialize touch listener
Runtime:addEventListener("touch", handleTouchInput)