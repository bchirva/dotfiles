local M = {}

function M.mix(color1, color2, ratio)
    local color1num = tonumber(string.sub(color1, 2, -1), 16)
    local color2num = tonumber(string.sub(color2, 2, -1), 16)

    local r = bit.band(bit.rshift(color1num, 16), 0xFF) * ratio + bit.band(bit.rshift(color2num, 16), 0xFF) * (1 - ratio)
    local g = bit.band(bit.rshift(color1num, 8), 0xFF) * ratio + bit.band(bit.rshift(color2num, 8), 0xFF) * (1 - ratio)
    local b = bit.band(color1num, 0xFF) * ratio + bit.band(color2num, 0xFF) * (1 - ratio)

    local colorBlended = bit.bor(b, bit.lshift(g, 8), bit.lshift(r, 16))
    return string.format("#%x", colorBlended)
end

function M.lighten(color, ratio)
    return M.mix(color, "#fff", 1 - ratio)
end

function M.darken(color, ratio)
    return M.mix(color, "#000", 1 - ratio)
end

return M
