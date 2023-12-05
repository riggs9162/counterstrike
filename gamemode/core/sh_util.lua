cs.util = cs.util or {}

function cs.util.Message(color, message)
    MsgC(cs.config["color"], "[Counter-Strike] ", color or color_white, tostring(message).."\n")
end

local realms = {
    ["cl"] = function(dir)
        if ( SERVER ) then
            AddCSLuaFile(dir)
            return
        end

        return include(dir)
    end,
    ["sh"] = function(dir)
        if ( SERVER ) then
            AddCSLuaFile(dir)
        end

        return include(dir)
    end,
    ["sv"] = function(dir)
        if ( CLIENT ) then
            return
        end

        return include(dir)
    end,
}
realms["client"] = realms["cl"]
realms["shared"] = realms["sh"]
realms["server"] = realms["sv"]

function cs.util.Include(dir, realm)
    if not ( file.Exists(dir, "LUA") ) then
        return
    end

    if ( realms[realm] ) then
        return realms[realm](dir)
    end

    if ( dir:match("sh_") ) then
        return realms["sh"](dir)
    elseif ( dir:match("cl_") ) then
        return realms["cl"](dir)
    elseif ( dir:match("sv_") ) then
        return realms["sv"](dir)
    else
        return realms["sh"](dir)
    end
end

function cs.util.IncludeDir(dir)
    local files, dirs = file.Find(dir .. "/*", "LUA")

    for k, v in ipairs(files) do
        cs.util.Include(dir .. "/" .. v)
    end

    for k, v in ipairs(dirs) do
        cs.util.IncludeDir(dir .. "/" .. v)
    end
end

cs.util.materials = cs.util.materials or {}
function cs.util.GetMaterial(name, ...)
    if ( cs.util.materials[name] ) then
        cs.util.materials[name] = Material(name, ...)
    end

    return cs.util.materials[name] or Material(name, ...)
end

function cs.util.GetTextSize(text, font)
    surface.SetFont(font)
    return surface.GetTextSize(text)
end

function cs.util.LerpColor(delta, start, finish)
    local c = Color(start.r, start.g, start.b, start.a)
    c.r = Lerp(delta, start.r, finish.r)
    c.g = Lerp(delta, start.g, finish.g)
    c.b = Lerp(delta, start.b, finish.b)
    c.a = Lerp(delta, start.a, finish.a)

    return c
end

function cs.util.OpenVGUI(ui, ply)
    if ( SERVER ) then
        net.Start("cs.OpenVGUI")
            net.WriteString(ui)
        net.Send(ply)
    else
        vgui.Create(ui)
    end
end

function cs.util.GetAllCombine()
    local combine = {}

    for _, v in ipairs(player.GetAll()) do
        if ( v:Team() == FACTION_CTERRORIST ) then
            table.insert(combine, v)
        end
    end

    return combine
end

function cs.util.GetAllRebels()
    local rebels = {}

    for _, v in ipairs(player.GetAll()) do
        if ( v:Team() == FACTION_TERRORIST ) then
            table.insert(rebels, v)
        end
    end

    return rebels
end

if ( CLIENT ) then
    local bMat = cs.util.GetMaterial("pp/blurscreen")
    function cs.util.DrawBlur(panel, amount, passes, alpha)
        amount = amount or 3

        surface.SetMaterial(bMat )
        surface.SetDrawColor(255, 255, 255, alpha or 255)

        local x, y = panel:LocalToScreen(0, 0)

        for i = -( 0.2 or passes ), 1, 0.2 do
            bMat:SetFloat("$blur", i * amount)
            bMat:Recompute()

            render.UpdateScreenEffectTexture()
            surface.DrawTexturedRect(x * -1, y * -1, ScrW(), ScrH())
        end
    end
    
    function cs.util.DrawBlurAt(x, y, w, h, amount, passes, alpha)
        amount = amount or 3

        surface.SetMaterial(bMat)
        surface.SetDrawColor(255, 255, 255, alpha or 255)

        local sW = ScrW()
        local sH = ScrH()

        local x2 = x / sW
        local y2 = y / sH

        local w2 = ( x + w ) / sW
        local h2 = ( y + h ) / sH

        for i = -( passes or 0.2 ), 1, 0.2 do
            bMat:SetFloat("$blur", i * amount)
            bMat:Recompute()

            render.UpdateScreenEffectTexture()
            surface.DrawTexturedRectUV(x, y, w, h, x2, y2, w2, h2)
        end
    end

    function cs.util.DrawTexture(material, color, x, y, w, h, ...)
        surface.SetDrawColor(color or color_white)
        surface.SetMaterial(Material(material, ...))
        surface.DrawTexturedRect(x, y, w, h)
    end

    function cs.util.DrawFilledCircle(x, y, segments, radius, color)
        if not ( segments ) then
            segments = 36
        end
    
        local segmentAngle = 360 / segments
        local circle = {}
    
        for i = 1, segments do
            local radians = math.rad(i * segmentAngle)
            local vertex = {
                x = x + math.cos(radians) * radius,
                y = y + math.sin(radians) * radius,
            }
    
            table.insert(circle, vertex)
        end
        
        draw.NoTexture()
        surface.SetDrawColor(color or color_white)
        surface.DrawPoly(circle)
    end
end