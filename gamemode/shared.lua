ENTITY = FindMetaTable("Entity")
PLAYER = FindMetaTable("Player")

DeriveGamemode("sandbox")

GM.Name = "Counter-Strike"
GM.Author = "Riggs"
GM.Description = "A light weight Counter-Strike remake for Garry's Mod"

cs.config = cs.config or {}
cs.config["color"] = Color(40, 140, 240)
cs.config["discord"] = "https://discord.gg/dnXSHNBwbP"
cs.config["walkSpeed"] = 250
cs.config["runSpeed"] = 130
cs.config["notificationSound"] = "buttons/blip1.wav"

cs.util.Message(Color(255, 255, 0), "Loading Core...")

cs.util.IncludeDir(GM.FolderName.."/gamemode/core/hooks")
cs.util.IncludeDir(GM.FolderName.."/gamemode/core/libs")
cs.util.IncludeDir(GM.FolderName.."/gamemode/core/mapconfig")
cs.util.IncludeDir(GM.FolderName.."/gamemode/core/meta")
cs.util.IncludeDir(GM.FolderName.."/gamemode/core/net")
cs.util.IncludeDir(GM.FolderName.."/gamemode/core/vgui")

cs.faction.Initialize()

hook.Run("CreateFonts")

cs.util.Message(Color(0, 255, 0), "Core Loaded.")