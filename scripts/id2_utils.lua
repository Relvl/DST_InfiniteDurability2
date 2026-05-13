local Id2Utils = {}

--- Does nothing
function Id2Utils.Foo()
end

function Id2Utils.FixFiniteUsesComponent(inst)
    if inst.components.finiteuses then
        local oldSetUses = inst.components.finiteuses.SetUses
        local oldOnLoad = inst.components.finiteuses.OnLoad

        function inst.components.finiteuses:SetUses(uses)
            oldSetUses(self, self.total)
        end
        function inst.components.finiteuses:OnLoad(data)
            oldOnLoad(self, data)
            self:SetUses(self.total)
        end
    end
end

function Id2Utils.FixFueledComponent(inst)
    if inst.components.fueled then
        inst.components.fueled.rate_modifiers:SetModifier(inst, 0)

        local oldDoDelta = inst.components.fueled.DoDelta
        function inst.components.fueled:DoDelta(amount, doer)
            oldDoDelta(self, 0, doer)
        end
    end
end

function Id2Utils.FixPerishableComponent(inst)
    if inst.components.perishable then
        inst.components.perishable.ReducePercent = Id2Utils.Foo
        inst.components.perishable.Dilute = Id2Utils.Foo
        inst.components.perishable.localPerishMultiplyer = 0
        inst.components.perishable.perishremainingtime = inst.components.perishable.perishtime
        inst.components.perishable:OnRemoveFromEntity()
        inst:RemoveTag("icebox_valid")
        inst:RemoveTag("show_spoilage")
    end
end

function Id2Utils.FixWeaponComponent(inst)
    if inst.components.weapon then
        inst.components.weapon.attackwear = 0
    end
end

function Id2Utils.FixArmorComponent(inst)
    if inst.components.armor then
        inst.components.armor.indestructible = true
    end
end

function Id2Utils.FixPreserver(inst)
    if not inst.components.preserver then
        inst:AddComponent("preserver")
    end
    inst.components.preserver:SetPerishRateMultiplier(0.0)
    inst._is_infinite_durability_2 = true
end

function Id2Utils.FixPrefab(inst)
    inst:AddTag("hide_percentage")
    Id2Utils.FixFiniteUsesComponent(inst)
    Id2Utils.FixPerishableComponent(inst)
    Id2Utils.FixWeaponComponent(inst)
    Id2Utils.FixArmorComponent(inst)
    Id2Utils.FixFueledComponent(inst)
    inst._is_infinite_durability_2 = true
end

function Id2Utils.MakeIndestructible(inst)
    if inst.components.workable then
        print("[InfiniteDurability2] Making " .. tostring(inst) .. " indestructible")
        local oldWorkedBy = inst.components.workable.workedby
        function inst.components.workable:WorkedBy(worker, numworks)
            if not worker:HasTag("player") then
                return
            end
            oldWorkedBy(self, worker, numworks)
        end
    end
end

function Id2Utils.MakeFireImmune(inst)
    if inst.components.burnable and inst.components.burnable.canlight and not inst:HasTag("wildfireprotected") then
        print("[InfiniteDurability2] Making " .. tostring(inst) .. " fire immune")
        inst:AddTag("fireimmune")
    end
end

function Id2Utils.ProcessPrefabPostInit(inst)
    Id2Utils.FixPrefab(inst)

    if inst.components.upgradeable then
        local oldOnUpgradeFn = inst.components.upgradeable.onupgradefn
        function inst.components.upgradeable.onupgradefn(inst, ...)
            oldOnUpgradeFn(inst, ...)
            Id2Utils.FixPrefab(inst)
        end

        local oldOnLoad = inst.OnLoad
        function inst:OnLoad(data)
            oldOnLoad(self, data)
            Id2Utils.FixPrefab(self)
        end
    end
end

return Id2Utils