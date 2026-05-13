name = "Infinite Durability 2"
description = "Gives selected item types infinite durability or uses, and makes structures indestructible and immune to fire. Everything can be configured in the mod settings."
author = "Johnson1893"
version = "1.0"

api_version_dst = 10
dst_compatible = true

all_clients_require_mod = false
client_only_mod = false
server_only_mod = true
server_filter_tags = { "Infinite Durability" }

icon_atlas = "modicon.xml"
icon = "modicon.tex"

local separatorOptions = { { description = "", data = false } }

---@param title string
---@param hover string|nil
local function Title(title, hover)
    return { name = "", label = title, hover = hover, options = separatorOptions, default = false }
end

---@param name string
---@param label string
---@param hover string|nil
---@param default boolean
local function Boolean(name, label, hover, default)
    return { name = name, label = label, hover = hover, options = { { description = "Yes", data = true }, { description = "No", data = false } }, default = default }
end

configuration_options = {
    Title("Common items"),
    Boolean("WEAPONS", "Weapons", nil, true),
    Boolean("TOOLS", "Tools", nil, true),
    Boolean("ARMOR", "Armor", nil, true),
    Boolean("HATS", "Hats, Helmets", nil, true),
    Boolean("MAGIC", "Magic items", "Charges of magic items (amulets, staffs, etc.)", false),
    Boolean("LIGHT_SOURCE", "Light sources", "Torches, lanterns, etc. (including Firepit and Endothermic Fire Pit)", false),
    Boolean("CAMPFIRE", "Small campfires", "Campfire, Endothermic Fire", false),
    Boolean("FRESHNESS", "Freshness", "Keep freshness in different containers like Icebox, Saltbox, Sisturn, Bird Cage, Insulated Pack, etc. excluding normal containers like Chest.", true),
    Boolean("BUILDINGS", "Buildings", "Ice Flingomatic, Tent, Siesta Lean-to, Astral Detector", true),

    Title("Character items"),
    Boolean("WILLOW", "Willow", "All Willow-specific items (Lighter, Bernie)", true),
    Boolean("WOLFGANG", "Wolfgang", "All Wolfgang-specific items (Dumells)", true),
    Boolean("WX-78", "WX-78", "All WX-78-specific items (Circuits, Zaptrocuter)", true),
    Boolean("WICKERBOTTOM", "Wickerbottom", "All Wickerbottom-specific items (Books)", true),
    Boolean("WOODIE", "Woodie", "All Woodie-specific items (Walking stick, Carving hat)", true),
    Boolean("WES", "Wes", "All Wes-specific items (Balloon hat, vest, Speedy Balloon)", true),
    Boolean("MAXWELL", "Maxwell", "All Maxwell-specific items (Codex Umbra)", true),
    Boolean("WIGFRID", "Wigfrid", "All Wigfrid-specific items (Battle Spear, Battle Rönd, Battle Helm, Commander's Helm)", true),
    Boolean("WEBBER", "Webber", "All Webber-specific items (Webby Whistle, Shoo Box)", true),
    Boolean("WALTER", "Walter", "All Walter-specific items (Pinetree Pioneer Hat)", true),
    Boolean("WORMWOOD", "Wormwood", "All Wormwood-specific items (Bramble Husk, Brambleshade Armor, Bramble Trap)", true),
    Boolean("WANDA", "Wanda", "All Wanda-specific items (Alarming Clock)", true),

    Title("Other"),
    Boolean("OCEAN_TRAWLER", "Ocean trawler", "Ocean trawler net can't be broken and fish can't escape, also fish can't spoil inside.", true),
    Boolean("BOATS", "Boats", "Boats don't receive collision and leak damage", false),

    Title("Indestructible Structures"),
    {
        name = "STRUCTURES_INDESTRUCTIBLE",
        label = "Indestructible by monsters",
        hover = "Set workable structures to never break by the monsters/giants. Players still can break them.",
        options = {
            { description = "All", data = "all", haver = "All structures are indestructible" },
            { description = "Containers", data = "containers", "Container structures are indestructible" },
            { description = "Disabled", data = "disabled" }
        },
        default = "all"
    },
    {
        name = "STRUCTURES_FIRE_IMMUNE",
        label = "Fire Immune",
        hover = "Set structures to be immune to fire",
        options = {
            { description = "All", data = "all", haver = "All structures are fire immune" },
            { description = "Containers", data = "containers", "Container structures are fire immune" },
            { description = "Disabled", data = "disabled" }
        },
        default = "disabled"
    }
}