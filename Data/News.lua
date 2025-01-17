CraftSimAddonName, CraftSim = ...

CraftSim.NEWS = {}

function CraftSim.NEWS:GET_NEWS()
    -- minimize names to make manual formatting easier :p
    local f = CraftSim.UTIL:GetFormatter()
    local function newP(v) return f.l("\n                                   --- Version " .. v .. " ---\n") end
    local news = {
        f.bb("                   Hello and thank you for using CraftSim!\n"),
        f.bb("                                 ( You are awesome! )"),
        newP("11.3.7"),
        f.P .. "Reworked " .. f.bb("Customer History"),
        f.p .. f.bb("CraftQueue") .. " fixed total crafting costs not calculating",
        f.p .. "Preparations for the new " .. f.bb("Auctionator") .. " API",
        f.a .. "to create Shopping Lists.",
        newP("11.3.6"),
        f.s .. f.bb("CraftQueue") .. " now shows total average profit and crafting costs",
        f.s .. "Updated Italian Localizations",
        f.a .. "Thanks to " .. f.bb("https://github.com/SirDester"),
        f.p .. f.bb("CraftQueue") .. " Restock Options now correctly display",
        f.a .. "the saved sale rate threshold upon reloading",
        newP("11.3.3"),
        f.p .. f.bb("CraftQueue: ") .. "When adding the currently open recipe, recipes",
        f.a .. "that have not enough quantity allocated for a quality reagent",
        f.a .. "now use the cheapest quality of that reagent when adding it to",
        f.a .. "the queue",
        f.p .. "Ensured that all recipes added to the " .. f.bb("CraftQueue"),
        f.a .. "have enough required reagents allocated to be crafted",
        f.p .. "Recipes that are on cooldown now show that in the craft queue",
        newP("11.3.2"),
        f.p .. "Fixed recipe restock option for salerate false positive if",
        f.a .. "all qualities are toggled off",
        newP("11.3.1"),
        f.p .. "Fixed GeneralRestockAmount Options having no default value",
        newP("11.3.0"),
        f.s .. "Changed " .. f.bb("CraftQueue") .. " Restock Option for Sale Rate",
        f.a .. "behaviour to check wether any of the chosen qualities reaches",
        f.a .. "the threshold instead of the average",
        f.p .. "Added Sale Rate Threshold option to General Restock Options",
        newP("11.2.2"),
        f.P .. f.bb("CraftQueue") .. " now has configureable " .. f.g("Restock Options"),
        f.a .. "affecting " .. f.bb("Restock from Recipe Scan") .. " Behaviour",
        f.a .. "This includes " .. f.g("Restock Amount") .. " and thresholds",
        f.a .. "like " .. f.g("Profit Margin") .." and " .. f.g("Sale Rate"),
        f.a .. f.bb("Sale Rate Thresholds") .. " are only available if TSM is loaded!",
        f.s .. f.bb("CraftQueue") .. " now shows average profit margin per recipe",
        f.p .. f.bb("PriceDetails:") .. " fixed a bug where not all qualities were listed",
        f.a .. "when opening a recipe the first time a session",
        newP("11.1.2"),
        f.p .. "Fixed " .. f.bb("CraftResults") .. " incorrectly adding multicraft results",
        f.p .. "Fixed " .. f.bb("CraftQueue") .. " not being initialized sometimes",
        f.p .. "Fixed " .. f.bb("Create Auctionator Shopping List") .. " button not working",
        f.p .. f.bb("Shopping List") .. " will now exclude soulbound items",
        f.p .. f.bb("Shopping List") .. " will now remove/reduce items when bought",
        f.p .. "Added a delete button for each " .. f.bb("CraftQueue Row"),
        f.p .. "Unlearned recipes are now not addable to the " .. f.bb("CraftQueue"),
        f.p .. f.g("Increased CraftQueue Performance") .. " using an ItemCount Cache",
        f.a .. "and a lot of precalculations",
        f.p .. f.bb("CraftQueue Rows") .. " are now sorted by",
        f.a .. "craftable status > profit per craft",
        f.p .. "Supporter List Update!",
        f.a .. "Thanks to " .. f.patreon("Jose Luis") .. " for that huge donation! <3",
        newP("11.0.0"),
        f.P .. f.g("New Module:") .. f.l(" CraftQueue"),
        f.a .. "Queue Recipes from your currently open recipe or even",
        f.a .. "from your last " .. f.bb("Recipe Scan") .. " results ",
        f.a .. "and craft them all in one place!",
        f.a .. "Directly create an " .. f.bb("Auctionator Shopping List"),
        f.a .. "to buy every reagent you are missing!",
        f.a .. "- More restock options are coming!",
        f.a .. "- CraftQueue consisting over sessions is also planned",
        f.a .. "(Very new feature, please report any bugs in the discord)",
    }
    return table.concat(news, "\n")
end

function CraftSim.NEWS:GetChecksum()
    local checksum = 0
    local newsString = CraftSim.NEWS:GET_NEWS()
    local checkSumBitSize = 256

    -- Iterate through each character in the string
    for i = 1, #newsString do
        checksum = (checksum + string.byte(newsString, i)) % checkSumBitSize
    end

    return checksum
end

---@return string | nil newChecksum newChecksum when news should be shown, otherwise nil
function CraftSim.NEWS:IsNewsUpdate()
    local newChecksum = CraftSim.NEWS:GetChecksum()
    local oldChecksum = CraftSimOptions.newsChecksum
    if newChecksum ~= oldChecksum then
        return newChecksum
    end
    return nil
end

function CraftSim.NEWS:ShowNews(force)
    local infoText = CraftSim.NEWS:GET_NEWS()
    local newChecksum = CraftSim.NEWS:IsNewsUpdate()
    if newChecksum == nil and (not force) then
       return 
    end

    CraftSimOptions.newsChecksum = newChecksum

    local infoFrame = CraftSim.GGUI:GetFrame(CraftSim.MAIN.FRAMES, CraftSim.CONST.FRAMES.INFO)
    -- resize
    infoFrame:SetSize(CraftSim.CONST.infoBoxSizeX, CraftSim.CONST.infoBoxSizeY)
    infoFrame.originalX = CraftSim.CONST.infoBoxSizeX
    infoFrame.originalY = CraftSim.CONST.infoBoxSizeY
    infoFrame.showInfo(infoText)
end