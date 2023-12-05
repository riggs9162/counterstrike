function GM:InitPostEntity()
    RunConsoleCommand("stopsound")

    cs.util.OpenVGUI("cs.MainMenu")
    cs.util.OpenVGUI("cs.NotificationTab")
end

function GM:CalcView(ply, origin, angles, fov)
    if ( IsValid(cs.ui.menu) and cs.mapConfig[game.GetMap()] and cs.mapConfig[game.GetMap()].menuView ) then
        local view = {
            origin = cs.mapConfig[game.GetMap()].menuView.origin,
            angles = cs.mapConfig[game.GetMap()].menuView.angles,
            fov = cs.mapConfig[game.GetMap()].menuView.fov or fov,
        }

        return view
    end
end

function GM:Think()
    if not ( LocalPlayer():Team() == 0 ) then
        if ( vgui.CursorVisible() ) then
            return
        end

        if ( input.IsKeyDown(KEY_F2) ) then
            cs.util.OpenVGUI("cs.MainMenu")
        elseif ( input.IsKeyDown(KEY_B) ) then
            cs.util.OpenVGUI("cs.Shop")
        elseif ( input.IsKeyDown(KEY_G) ) then
            local radial = vgui.Create("cs.Radial")
            radial.radius = ScreenScale(16) * 4
            
            for k, v in pairs(LocalPlayer():GetNetVar("cs.Items", {})) do
                radial:AddButton(v, "Font-Elements-ScreenScale10", color_white, function()
                    RunConsoleCommand("cs_dropweapon", k)
                    radial:Remove()
                end)
            end

            radial:UpdateButtons()
        end

        hook.Run("CheckMenuInput")
    end
end

local hidden = {}
hidden["CHudHealth"] = true
hidden["CHudBattery"] = true
hidden["CHudAmmo"] = true
hidden["CHudSecondaryAmmo"] = true
hidden["CHudCrosshair"] = true
hidden["CHudHistoryResource"] = true
hidden["CHudPoisonDamageIndicator"] = true
hidden["CHudSquadStatus"] = true
hidden["CHUDQuickInfo"] = true

function GM:HUDShouldDraw(element)
    if ( IsValid(cs.ui.menu) ) then
        return
    end

    if ( hidden[element] ) then
        return false
    end

    return true
end

function GM:ScoreboardShow()
    if ( LocalPlayer():Team() == 0 ) then
        return
    end
    
    cs.util.OpenVGUI("cs.Scoreboard")
end

function GM:ScoreboardHide()
    if ( LocalPlayer():Team() == 0 ) then
        return
    end
    
    if ( IsValid(cs.ui.scoreboard) ) then
        cs.ui.scoreboard:Remove()
    end
end