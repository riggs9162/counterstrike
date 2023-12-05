cs.shop = cs.shop or {}
cs.shop.stored = {}

function cs.shop.Get(itemIndex)
    return cs.shop.stored[itemIndex]
end

function cs.shop.GetAll()
    return cs.shop.stored
end

function cs.shop.Register(itemData)
    if not ( itemData.name ) then
        error("No name provided for item "..#itemData.."!")
    end

    local itemDataIndex = #cs.shop.stored + 1
    itemData.index = itemDataIndex

    cs.shop.stored[#cs.shop.stored + 1] = itemData

    return itemDataIndex
end

cs.util.IncludeDir(GM.FolderName.."/gamemode/shop")