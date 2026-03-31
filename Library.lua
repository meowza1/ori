-- Mobile-optimized version of Library.lua

local Library = {
    MobilePadding = 12,
    MinimumTapSize = 44,
    MaxReferenceWidth = 1920,
    MaxReferenceHeight = 1080,
}

-- Proper viewport clamping
function Library:ClampViewport(width, height)
    local minWidth, minHeight = 320, 480

    return math.max(minWidth, math.min(width, self.MaxReferenceWidth)), math.max(minHeight, math.min(height, self.MaxReferenceHeight))
end

-- Responsive UI scaling with mobile bias to prevent tiny controls
function Library:ScaleUI(width, height)
    local scaleX = width / self.MaxReferenceWidth
    local scaleY = height / self.MaxReferenceHeight

    local baseScale = math.min(scaleX, scaleY)
    local mobileBoost = (width <= 900 or height <= 700) and 1.12 or 1

    return math.max(0.75, baseScale * mobileBoost)
end

-- Keep root UI containers on-screen (safe-area aware)
function Library:ClampToSafeArea(element, viewportWidth, viewportHeight)
    if not element then
        return
    end

    local pad = self.MobilePadding
    local insetTop = (display and display.safeScreenOriginY) or 0
    local insetBottom = (display and display.actualContentHeight and display.contentHeight) and (display.actualContentHeight - (display.contentHeight + insetTop)) or 0

    local minX = pad
    local minY = insetTop + pad
    local maxX = viewportWidth - (element.width or 0) - pad
    local maxY = viewportHeight - (element.height or 0) - insetBottom - pad

    element.x = math.max(minX, math.min(element.x or minX, maxX))
    element.y = math.max(minY, math.min(element.y or minY, maxY))
end

-- Ensure buttons and touch targets are easy to press on mobile
function Library:ApplyTouchTargetSizing(element)
    if not element then
        return
    end

    if element.width and element.width < self.MinimumTapSize then
        element.width = self.MinimumTapSize
    end

    if element.height and element.height < self.MinimumTapSize then
        element.height = self.MinimumTapSize
    end
end

-- Recursively apply mobile adjustments to all UI elements
function Library:ApplyMobileSupport(root, viewportWidth, viewportHeight)
    if not root then
        return
    end

    self:ClampToSafeArea(root, viewportWidth, viewportHeight)
    self:ApplyTouchTargetSizing(root)

    if root.numChildren and root.numChildren > 0 then
        for i = 1, root.numChildren do
            local child = root[i]

            if child then
                self:ApplyTouchTargetSizing(child)

                if child.numChildren and child.numChildren > 0 then
                    self:ApplyMobileSupport(child, viewportWidth, viewportHeight)
                end
            end
        end
    end
end

-- Touch input support
function Library:HandleTouchInput(touch)
    if touch.phase == "began" then
        -- Handle touch start
    elseif touch.phase == "moved" then
        -- Handle touch move
    elseif touch.phase == "ended" or touch.phase == "cancelled" then
        -- Handle touch end
    end
end

-- Usage example
local viewportWidth, viewportHeight = Library:ClampViewport(display.contentWidth, display.contentHeight)
local uiScale = Library:ScaleUI(viewportWidth, viewportHeight)

if uiRoot then
    uiRoot.xScale, uiRoot.yScale = uiScale, uiScale
    Library:ApplyMobileSupport(uiRoot, viewportWidth, viewportHeight)
end

-- Initialize touch listener
Runtime:addEventListener("touch", function(touch)
    return Library:HandleTouchInput(touch)
end)

return Library
