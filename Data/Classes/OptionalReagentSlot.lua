_, CraftSim = ...

---@class CraftSim.OptionalReagentSlot
---@field possibleReagents CraftSim.OptionalReagent[]
---@field activeReagent CraftSim.OptionalReagent
---@field slotText string
---@field dataSlotIndex number
---@field locked boolean
---@field lockedReason? string

CraftSim.OptionalReagentSlot = CraftSim.Object:extend()

---@param reagentSlotSchematic CraftingReagentSlotSchematic
function CraftSim.OptionalReagentSlot:new(recipeData, reagentSlotSchematic)
    self.recipeData = recipeData
    if not reagentSlotSchematic then
        return
    end
    self.dataSlotIndex = reagentSlotSchematic.dataSlotIndex
    self.possibleReagents = {}

    if reagentSlotSchematic.slotInfo and reagentSlotSchematic.slotInfo.mcrSlotID then
        self.slotText = reagentSlotSchematic.slotInfo.slotText
        self.locked, self.lockedReason = C_TradeSkillUI.GetReagentSlotStatus(reagentSlotSchematic.slotInfo.mcrSlotID, recipeData.recipeID, recipeData.professionData.skillLineID)
    end

    for _, reagent in pairs(reagentSlotSchematic.reagents) do
        table.insert(self.possibleReagents, CraftSim.OptionalReagent(reagent))
    end
end

---@param itemID number
function CraftSim.OptionalReagentSlot:SetReagent(itemID)
    if not itemID then
        self.activeReagent = nil
        return
    end

    self.activeReagent = CraftSim.UTIL:Find(self.possibleReagents, function(possibleReagent) return possibleReagent.item:GetItemID() == itemID end)
end

---@return CraftingReagentInfo?
function CraftSim.OptionalReagentSlot:GetCraftingReagentInfo()
    if self.activeReagent then
        return {
            itemID = self.activeReagent.item:GetItemID(),
            dataSlotIndex = self.dataSlotIndex,
            quantity = 1,
        }
    end
end

function CraftSim.OptionalReagentSlot:Debug()
    local debugLines = {
        "slotText: " .. tostring(self.slotText),
        "dataSlotIndex: " .. tostring(self.dataSlotIndex),
        "locked: " .. tostring(self.locked),
        "lockedReason: " .. tostring(self.lockedReason),
        "activeReagent: " .. ((self.activeReagent and (self.activeReagent.item:GetItemLink() or self.activeReagent.item:GetItemID()) or "None")),
        "possibleReagents: ",
    }

    for _, reagent in pairs(self.possibleReagents) do
        debugLines = CraftSim.UTIL:Concat({debugLines, reagent:Debug()})
    end

    return debugLines
end

function CraftSim.OptionalReagentSlot:Copy(recipeData)

    local copy = CraftSim.OptionalReagentSlot(recipeData)
    copy.possibleReagents = CraftSim.UTIL:Map(self.possibleReagents, function(r) return r:Copy() end)
    if self.activeReagent then
        copy.activeReagent = CraftSim.UTIL:Find(copy.possibleReagents, function(r) return r.item:GetItemID() == self.activeReagent.item:GetItemID() end)
    end

    copy.slotText = self.slotText
    copy.dataSlotIndex = self.dataSlotIndex
    copy.locked = self.locked
    copy.lockedReason = self.lockedReason

    return copy
end