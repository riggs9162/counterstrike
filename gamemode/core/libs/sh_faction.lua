cs.faction = cs.faction or {}
cs.faction.stored = cs.faction.stored or {}

FACTION_CTERRORIST = 1
FACTION_TERRORIST = 2
FACTION_SPECTATOR = 3

cs.faction.list = {
    [FACTION_CTERRORIST] = {
        name = "Counter-Terrorist Force",
        color = Color(25, 125, 250),
        description = "",
        weapons = {
            "tfa_pist_usp",
        },
        items = {
            "USP Tactical",
        },
        models = {
            ["Seal Team 6"] = "models/player/urban.mdl",
            ["GSG-9"] = "models/player/riot.mdl",
            ["SAS"] = "models/player/gasmask.mdl",
            ["GIGN"] = "models/player/swat.mdl",
        },
    },
    [FACTION_TERRORIST] = {
        name = "Terrorist Force",
        color = Color(250, 150, 50),
        description = "",
        weapons = {
            "tfa_pist_glock",
        },
        items = {
            "Glock 18",
        },
        models = {
            ["Phoenix Conexion"] = "models/player/phoenix.mdl",
            ["Elite Crew"] = "models/player/leet.mdl",
            ["Artic Avengers"] = "models/player/arctic.mdl",
            ["Guerilla Warfare"] = "models/player/guerilla.mdl",
        },
    },
    [FACTION_SPECTATOR] = {
        name = "Spectator",
        color = Color(150, 150, 150),
        description = "",
        weapons = nil,
        items = nil,
        models = nil,
    },
}

function cs.faction.Initialize()
    for k, v in pairs(cs.faction.list) do
        cs.faction.stored[k] = v

        team.SetUp(k, v.name, v.color, false)
    end
end