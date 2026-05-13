local env = env
env._G = GLOBAL

local Id2Utils = require("id2_utils")
local Id2Database = require("id2_database")
local fresherPrefabs = { "sisturn", "icepack", "spicepack", "seedpouch", "beargerfur_sack" }

for _, entry in ipairs(Id2Database) do
    local config = entry.config
    local enabled = GetModConfigData(config)
    if enabled then
        for _, prefab in ipairs(entry.prefabs) do
            AddPrefabPostInit(prefab, Id2Utils.ProcessPrefabPostInit)
        end
    end
end

local fixPerishTunings = GetModConfigData("FRESHNESS")
if fixPerishTunings then
    _G.TUNING.PERISH_MUSHROOM_LIGHT_MULT = 0.0
    _G.TUNING.PERISH_FRIDGE_MULT = 0.0
    _G.TUNING.PERISH_SALTBOX_MULT = 0.0
    _G.TUNING.PERISH_CAGE_MULT = 0.0

    for _, prefab in ipairs(fresherPrefabs) do
        AddPrefabPostInit(prefab, Id2Utils.FixPreserver)
    end
end

local fixBoats = GetModConfigData("BOATS")
if fixBoats then
    AddComponentPostInit("hullhealth", function(self)
        self.leakproof = true
        function self:OnCollide(data)
        end

        function self:UpdateHealth()
            if self.inst.components.health ~= nil and self.inst.components.health:IsDead() then
                return
            end
            self.inst:RemoveTag("is_leaking")
        end
    end)
end

local structuresIndestructible = GetModConfigData("STRUCTURES_INDESTRUCTIBLE")
if structuresIndestructible == "all" or structuresIndestructible == "containers" then
    AddPrefabPostInitAny(function(inst)
        if inst:HasTag("structure") and inst.components.workable then
            if structuresIndestructible == "all" then
                Id2Utils.MakeIndestructible(inst)
            elseif structuresIndestructible == "containers" and (inst.components.container or inst.components.container_proxy) then
                Id2Utils.MakeIndestructible(inst)
            end
        end
    end)
end

local structuresFireImmune = GetModConfigData("STRUCTURES_FIRE_IMMUNE")
if structuresFireImmune == "all" or structuresFireImmune == "containers" then
    AddPrefabPostInitAny(function(inst)
        if inst:HasTag("structure") and inst.components.burnable then
            if structuresIndestructible == "all" then
                Id2Utils.MakeFireImmune(inst)
            elseif structuresIndestructible == "containers" and (inst.components.container or inst.components.container_proxy) then
                Id2Utils.MakeFireImmune(inst)
            end
        end
    end)
end

local fixOceanTrawler = GetModConfigData("OCEAN_TRAWLER")
if fixOceanTrawler then
    _G.TUNING.OCEAN_TRAWLER_LOWERED_PERISH_RATE = 0

    AddPrefabPostInit("ocean_trawler", function(inst)
        local oceanTrawler = inst.components.oceantrawler
        if oceanTrawler then
            oceanTrawler.overflowescapepercent = 0
        end
    end)
end
