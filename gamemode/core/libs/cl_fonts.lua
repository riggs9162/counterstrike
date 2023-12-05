cs.fonts = cs.fonts or {}
cs.fonts.stored = cs.fonts.stored or {}

function cs.fonts.Register(name, data)
    surface.CreateFont(name, data)

    cs.fonts.stored[name] = {
        name = name,
        data = data
    }
end

hook.Add("CreateFonts", "DefaultFonts", function()
    for i = 1, 15 do
        cs.fonts.Register("Font-Elements"..i * 5, {
            font = "Futura Std Medium",
            size = i * 5,
            antialias = true,
        })

        cs.fonts.Register("Font-Elements-Italic"..i * 5, {
            font = "Futura Std Medium",
            size = i * 5,
            antialias = true,
            italic = true,
        })

        cs.fonts.Register("Font-Elements-Light"..i * 5, {
            font = "Futura Std Light",
            size = i * 5,
            antialias = true,
        })

        cs.fonts.Register("Font-Elements-Lines"..i * 2, {
            font = "Futura Std Medium",
            size = i * 5,
            scanlines = 4,
        })

        cs.fonts.Register("Font-Elements-ItalicLines"..i * 2, {
            font = "Futura Std Medium",
            size = i * 5,
            italic = true,
            scanlines = ScreenScale(1),
        })
    end

    for i = 3, 30 do
        cs.fonts.Register("Font-Elements-ScreenScale"..i * 2, {
            font = "Futura Std Medium",
            size = ScreenScale(i * 2),
            antialias = true,
        })

        cs.fonts.Register("Font-Elements-Italic-ScreenScale"..i * 2, {
            font = "Futura Std Medium",
            size = ScreenScale(i * 2),
            antialias = true,
            italic = true,
        })

        cs.fonts.Register("Font-Elements-Light-ScreenScale"..i * 2, {
            font = "Futura Std Light",
            size = ScreenScale(i * 2),
            antialias = true,
        })

        cs.fonts.Register("Font-Elements-Lines-ScreenScale"..i * 2, {
            font = "Futura Std Medium",
            size = ScreenScale(i * 2),
            scanlines = 4,
        })

        cs.fonts.Register("Font-Elements-ItalicLines-ScreenScale"..i * 2, {
            font = "Futura Std Medium",
            size = ScreenScale(i * 2),
            italic = true,
            scanlines = ScreenScale(1),
        })
    end

    cs.util.Message(Color(0, 255, 0), "Fonts Loaded.")
end)

concommand.Add("cs_loadfonts", function()
    cs.util.Message(Color(255, 255, 0), "Loading Fonts...")

    hook.Run("CreateFonts")
end)

concommand.Add("cs_getfonts", function()
    cs.util.Message(Color(0, 255, 0), "Stored Fonts:")

    for k, v in SortedPairs(cs.fonts.stored) do
        cs.util.Message(Color(0, 150, 150), k)
    end
end)