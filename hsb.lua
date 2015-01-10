-- HSL
-- require('math')

HSL = {}
HSL.__index = HSL

function HSL.new(h, s, l)
  return setmetatable({h=h or o, s= s or 0, l= l or 0}, HSL)
end

function HSL.from_rgb(rgb) 
  local r, g, b = rgb.r / 255, rgb.g / 255, rgb.b / 255
  local max, min = math.max(r, g, b), math.min(r, g, b)
  local avg = (max + min) / 2
  local h, s, l = avg, avg, avg
  if max == min then
    h, s = 0, 0 -- achromatic
  else
    local d = max - min
    if l > 0.5 then
      s = d / (2 - max - min)
    else
      s = d / (max + min)
    end
      -- s = l > 0.5 ? d / (2 - max - min) : d / (max + min)
    if max == r then
      local d3= 0
      if g < b then d3 = 6 end
      h = (g - b) / d + d3
    elseif max == g then
      h = (b - r) / d  + 2
    elseif max == b then
      h = (r - g) / d + 4
    end
    h = h / 6
  end

  return {h=h, s=s, l=l}
end

function HSL.to_rgb(hsl)
  local hue2rgb = function (p, q, t)
    if t < 0 then t = t + 1 end
    if t > 1 then t = t - 1 end
    if t < 1/6 then return p + (q - p) * 6 * t end
    if t < 1/2 then return q end
    if t < 2/3 then return p + (q - p) * (2/3 - t) * 6 end
    return p;
  end
  local r, g, b = 0, 0, 0

  if hsl.s == 0 then
      r, g, b = hsl.l, hsl.l, hsl.l -- achromatic
  else
    local q = 0
    if hsl.l < 0.5 then
      q = hsl.l * (1 + hsl.s)
    else
      q = hsl.l + hsl.s - hsl.l * hsl.s
    end
    local p = 2 * hsl.l - q;
    r = hue2rgb(p, q, hsl.h + 1/3);
    g = hue2rgb(p, q, hsl.h);
    b = hue2rgb(p, q, hsl.h - 1/3);
  end

  return {r= r * 255, g= g * 255, b= b * 255}
end

