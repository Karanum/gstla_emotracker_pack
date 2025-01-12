local SUMMONS = {"zagan", "megaera", "flora", "moloch", "ulysses", "haures", "eclipse", "coatlicue", "daedalus", "azul", "catastrophe", "charon", "iris"}

local PSY_CACHE = {{}, {}, {}, {}, {}, {}, {}, {}}
local ITEM_CACHE = {{}, {}, {}, {}, {}, {}, {}, {}}
local MULTI_CACHE = {}

-- ===================
-- Auxiliary functions
-- ===================

local function isInGame()
    return AutoTracker:ReadU16(0x02000428) > 1
end

local function getFlagAddr(flag)
    return 0x02000040 + (flag >> 3)
end

local function getFlagMask(flag)
    return 1 << (flag % 8)
end

local function checkFlag(flag)
    local flagByte = AutoTracker:ReadU8(getFlagAddr(flag))
    return (flagByte & getFlagMask(flag)) > 0
end

local function checkByte(addr)
    return AutoTracker:ReadU8(addr) > 0
end

local function setActive(obj, state)
    obj.Active = (AUTOTRACKER_PREVENT_UNTRACK and obj.Active) or state
end

local function convertDjinniFlag(flag)
    local elem = (flag - 0x30) // 0x14
    local id = (elem * 0x12) + ((flag - 0x30) % 0x14)
    local shuffleData = AutoTracker:ReadU16(0x08fa0000 + 2 * id)
    return (shuffleData >> 8) * 0x14 + (shuffleData & 0xFF) + 0x30
end

-- ======================
-- Item updater functions
-- ======================

local function updateInventory(seg, pc)
    if not isInGame() then
        return false
    end
    local addr = 0x020005F8 + (pc * 0x14C)
    
    if not AUTOTRACKER_PREVENT_UNTRACK then
        for _,obj in pairs(ITEM_CACHE[pc + 1]) do
            Tracker:FindObjectForCode(obj[1]).Active = false
        end
        ITEM_CACHE[pc + 1] = {}
    end

    for _,obj in pairs(DATA_ITEMS) do
        if (obj[2] and checkFlag(obj[2])) or (obj[3] and checkByte(0x0200208B + obj[3])) then
            Tracker:FindObjectForCode(obj[1]).Active = true
        end
    end

    for i = 0,14 do
        local itemId = (seg:ReadUInt16(addr + (2 * i)) & 0x1FF)
        local itemData = DATA_ITEMS[itemId]
        if itemData then
            Tracker:FindObjectForCode(itemData[1]).Active = true
            if not AUTOTRACKER_PREVENT_UNTRACK then
                table.insert(ITEM_CACHE[pc + 1], itemData)
            end
        end
    end
end

local function updateInventoryIsaac(seg) updateInventory(seg, 0) end
local function updateInventoryGaret(seg) updateInventory(seg, 1) end
local function updateInventoryIvan(seg) updateInventory(seg, 2) end
local function updateInventoryMia(seg) updateInventory(seg, 3) end
local function updateInventoryFelix(seg) updateInventory(seg, 4) end
local function updateInventoryJenna(seg) updateInventory(seg, 5) end
local function updateInventorySheba(seg) updateInventory(seg, 6) end
local function updateInventoryPiers(seg) updateInventory(seg, 7) end

local function updatePsynergy(seg, pc)
    if not isInGame() then
        return false
    end
    local addr = 0x02000578 + (pc * 0x14C)

    if not AUTOTRACKER_PREVENT_UNTRACK then
        for _,code in pairs(PSY_CACHE[pc + 1]) do
            Tracker:FindObjectForCode(code).Active = false
        end
        PSY_CACHE[pc + 1] = {}
    end

    for i = 0,31 do
        local psyId = seg:ReadUInt16(addr + (4 * i))
        if psyId > 0 and (psyId & 0xF000) == 0 then
            local code = DATA_PSYNERGY[psyId]
            if code then
                Tracker:FindObjectForCode(code).Active = true
                if not AUTOTRACKER_PREVENT_UNTRACK then 
                    table.insert(PSY_CACHE[pc + 1], code) 
                end
            end
        end
    end
end

local function updatePsynergyIsaac(seg) updatePsynergy(seg, 0) end
local function updatePsynergyGaret(seg) updatePsynergy(seg, 1) end
local function updatePsynergyIvan(seg) updatePsynergy(seg, 2) end
local function updatePsynergyMia(seg) updatePsynergy(seg, 3) end
local function updatePsynergyFelix(seg) updatePsynergy(seg, 4) end
local function updatePsynergyJenna(seg) updatePsynergy(seg, 5) end
local function updatePsynergySheba(seg) updatePsynergy(seg, 6) end
local function updatePsynergyPiers(seg) updatePsynergy(seg, 7) end

local function updateDjinn(seg)
    if not isInGame() then
        return false
    end

    local count = {0, 0, 0, 0}
    local total = 0
    for i = 0,4 do
        local djinniData = seg:ReadUInt16(0x02000046 + (2 * i))
        for j = 0,15 do
            local elem = (total // 20) + 1
            if (djinniData & 1) > 0 then
                count[elem] = count[elem] + 1
            end
            djinniData = djinniData >> 1
            total = total + 1
        end
    end
    
    Tracker:FindObjectForCode("venus").AcquiredCount = count[1]
    Tracker:FindObjectForCode("mercury").AcquiredCount = count[2]
    Tracker:FindObjectForCode("mars").AcquiredCount = count[3]
    Tracker:FindObjectForCode("jupiter").AcquiredCount = count[4]
end

local function updateSummons(seg)
    if not isInGame() then
        return false
    end

    local summonData = seg:ReadUInt16(0x0200024E)
    for i = 1, #SUMMONS do
        local summon = Tracker:FindObjectForCode(SUMMONS[i])
        setActive(summon, (summonData & 1) > 0)
        summonData = summonData >> 1
    end
end

local function updateProgression(seg, flag, code)
    local state = (seg:ReadUInt8(getFlagAddr(flag)) & getFlagMask(flag)) > 0
    setActive(Tracker:FindObjectForCode(code), state)
end

local function updateProgressionBriggs(seg) updateProgression(seg, 0x8AB, "briggs_battle") end
local function updateProgressionPiers(seg) updateProgression(seg, 0x8F4, "piers") end
local function updateProgressionGabomba(seg) updateProgression(seg, 0x8FF, "gabomba_statue") end
local function updateProgressionShip(seg) updateProgression(seg, 0x8DE, "lemurian_ship") end
local function updateProgressionSerpent(seg) updateProgression(seg, 0x9EE, "susa") end
local function updateProgressionEscape(seg) updateProgression(seg, 0x97F, "briggs_jailbreak") end
local function updateProgressionMoapa(seg) updateProgression(seg, 0x94D, "trial_road") end
local function updateProgressionJupiter(seg) updateProgression(seg, 0xA21, "jupiter_lit") end
local function updateProgressionReunion(seg) updateProgression(seg, 0x9D0, "reunion") end
local function updateProgressionCannon(seg) updateProgression(seg, 0xA5F, "cannon") end
local function updateProgressionMars(seg) updateProgression(seg, 0xA4B, "mars_lit") end
local function updateProgressionDoomDragon(seg) updateProgression(seg, 0x778, "doom_dragon") end
local function updateProgressionAnemosDoor(seg) updateProgression(seg, 0xA8B, "anemos_door") end
local function updateProgressionAnemosWings(seg) updateProgression(seg, 0x8DF, "wings_of_anemos") end

local function updateCharactersIsaac(seg) updateProgression(seg, 0x0, "character_isaac") end
local function updateCharactersGarret(seg) updateProgression(seg, 0x1, "character_garret") end
local function updateCharactersIvan(seg) updateProgression(seg, 0x2, "character_ivan") end
local function updateCharactersMia(seg) updateProgression(seg, 0x3, "character_mia") end
local function updateCharactersFelix(seg) updateProgression(seg, 0x4, "character_felix") end
local function updateCharactersJenna(seg) updateProgression(seg, 0x5, "character_jenna") end
local function updateCharactersSheba(seg) updateProgression(seg, 0x6, "character_sheba") end
local function updateCharactersPiers(seg) updateProgression(seg, 0x7, "character_piers") end

-- =====================
-- Location data loading
-- =====================

local LOC_FLAGS = {}
local LOC_DJINN = {}

local function loadSectionData(section, flags)
    if section.HostedItem then
        local flagNum = tonumber(flags.Name)
        if flagNum >= 0x30 and flagNum < 0x100 then
            LOC_DJINN[flagNum] = section
        end
    else
        if string.match(flags.Name, ',') then
            MULTI_CACHE[section] = {}
            for flag in string.gmatch(flags.Name, "([^,]+)") do
                local flagNum = tonumber(flag)
                if LOC_FLAGS[flagNum] == nil then
                    LOC_FLAGS[flagNum] = {}
                end
                table.insert(LOC_FLAGS[flagNum], section)
                MULTI_CACHE[section][flagNum] = false
            end
        else
            local flagNum = tonumber(flags.Name)
            if LOC_FLAGS[flagNum] == nil then
                LOC_FLAGS[flagNum] = {}
            end
            table.insert(LOC_FLAGS[flagNum], section)
        end
    end
end

local function loadLocationData(loc)
    local sections = loc.Sections
    local children = loc.Children

    if sections.Count == 0 then
        for i = 1,children.Count do
            loadLocationData(children[i - 1])
        end
    else
        if sections.Count ~= children.Count then
            print("ERROR: Mismatch in sections and flag data counts for location: ", loc.Name)
            return
        end
        for i = 1,sections.Count do
            loadSectionData(sections[i - 1], children[i - 1])
        end
    end
end

local function initLocationData()
    loadLocationData(Tracker:FindObjectForCode("@Overworld"))
end

-- ==========================
-- Location updater functions
-- ==========================

local function updateDjinnHosts(seg)
    if not isInGame() then
        return false
    end

    local djinn = {}
    local mapping = {}
    for i = 0,4 do
        local djinniData = seg:ReadUInt16(0x02000046 + (2 * i))
        for j = 0,15 do
            local flag = 0x30 + (i * 16) + j
            local section = LOC_DJINN[flag]
            if section then
                local newFlag = convertDjinniFlag(flag)
                mapping[newFlag] = section
            end
            djinn[flag] = (djinniData & 1) > 0
            djinniData = djinniData >> 1
        end
    end

    for k,v in pairs(djinn) do
        local section = mapping[k]
        if section then
            setActive(section.HostedItem, v)
        end
    end
end

local function updateSingularSection(section, state)
    local count = 1
    if (AUTOTRACKER_PREVENT_UNTRACK and section.AvailableChestCount == 0) or state then
        count = 0
    end
    section.AvailableChestCount = count
end

local function updateMultiSection(section, flag, state)
    local oldState = MULTI_CACHE[section][flag]
    local newState = (AUTOTRACKER_PREVENT_UNTRACK and oldState) or state
    if oldState == newState then
        return nil
    end
    MULTI_CACHE[section][flag] = newState

    local count = 0
    for _,flagState in pairs(MULTI_CACHE[section]) do
        if flagState then
            count = count + 1
        end
    end

    if count > section.ChestCount then
        count = section.ChestCount
    end
    section.AvailableChestCount = section.ChestCount - count
end

local function updateTablets(seg)
    if not isInGame() then
        return false
    end

    local tabletData = seg:ReadUInt16(0x02000042)
    for flag = 0x10,0x1F do
        local sectionTable = LOC_FLAGS[flag]
        if sectionTable and #sectionTable > 0 then
            for _,section in pairs(sectionTable) do
                updateSingularSection(section, (tabletData & 1) > 0)
            end
        end
        tabletData = tabletData >> 1
    end
end

local function updateChests(seg, startFlag)
    if not isInGame() then
        return false
    end

    local addr = 0x02000040 + (startFlag >> 3)
    for i = 0,15 do
        local chestData = seg:ReadUInt16(addr + 2 * i)
        for j = 0,15 do
            local flag = startFlag + (i * 16) + j
            local sectionTable = LOC_FLAGS[flag]
            if sectionTable and #sectionTable > 0 then
                for _,section in pairs(sectionTable) do
                    if section.ChestCount > 1 then
                        updateMultiSection(section, flag, (chestData & 1) > 0)
                    else
                        updateSingularSection(section, (chestData & 1) > 0)
                    end
                end
            end
            chestData = chestData >> 1
        end
    end
end

local function updateChests8(seg) updateChests(seg, 0x800) end
local function updateChests9(seg) updateChests(seg, 0x900) end
local function updateChestsA(seg) updateChests(seg, 0xA00) end
local function updateChestsB(seg) updateChests(seg, 0xB00) end
local function updateChestsC(seg) updateChests(seg, 0xC00) end
local function updateChestsD(seg) updateChests(seg, 0xD00) end
local function updateChestsE(seg) updateChests(seg, 0xE00) end
local function updateChestsF(seg) updateChests(seg, 0xF00) end

-- ==============
-- Memory watches
-- ==============

local function registerCharacterWatches()
    ScriptHost:AddMemoryWatch("Char - Felix", getFlagAddr(0x4), 1, updateCharactersFelix, 2000)
    ScriptHost:AddMemoryWatch("Char - Jenna", getFlagAddr(0x5), 1, updateCharactersJenna, 2000)
    ScriptHost:AddMemoryWatch("Char - Sheba", getFlagAddr(0x6), 1, updateCharactersSheba, 2000)
    ScriptHost:AddMemoryWatch("Char - Piers", getFlagAddr(0x7), 1, updateCharactersPiers, 2000)
    ScriptHost:AddMemoryWatch("Char - Isaac", getFlagAddr(0x0), 1, updateCharactersIsaac, 2000)
    ScriptHost:AddMemoryWatch("Char - Garret", getFlagAddr(0x1), 1, updateCharactersGarret, 2000)
    ScriptHost:AddMemoryWatch("Char - Ivan", getFlagAddr(0x2), 1, updateCharactersIvan, 2000)
    ScriptHost:AddMemoryWatch("Char - Mia", getFlagAddr(0x3), 1, updateCharactersMia, 2000)
end

local function registerProgressionWatches()
    ScriptHost:AddMemoryWatch("Prog - Briggs", getFlagAddr(0x8AB), 1, updateProgressionBriggs, 2000)
    ScriptHost:AddMemoryWatch("Prog - Piers", getFlagAddr(0x8F4), 1, updateProgressionPiers, 2000)
    ScriptHost:AddMemoryWatch("Prog - Gabomba", getFlagAddr(0x8FF), 1, updateProgressionGabomba, 2000)
    ScriptHost:AddMemoryWatch("Prog - Ship", getFlagAddr(0x8DE), 1, updateProgressionShip, 2000)
    ScriptHost:AddMemoryWatch("Prog - Serpent", getFlagAddr(0x9EE), 1, updateProgressionSerpent, 2000)
    ScriptHost:AddMemoryWatch("Prog - Escape", getFlagAddr(0x97F), 1, updateProgressionEscape, 2000)
    ScriptHost:AddMemoryWatch("Prog - Moapa", getFlagAddr(0x94D), 1, updateProgressionMoapa, 2000)
    ScriptHost:AddMemoryWatch("Prog - Jupiter LH", getFlagAddr(0xA21), 1, updateProgressionJupiter, 2000)
    ScriptHost:AddMemoryWatch("Prog - Reunion", getFlagAddr(0x9D0), 1, updateProgressionReunion, 2000)
    ScriptHost:AddMemoryWatch("Prog - Cannon", getFlagAddr(0xA5F), 1, updateProgressionCannon, 2000)
    ScriptHost:AddMemoryWatch("Prog - Mars LH", getFlagAddr(0xA4B), 1, updateProgressionMars, 2000)
    ScriptHost:AddMemoryWatch("Prog - Doom Dragon", getFlagAddr(0x778), 1, updateProgressionDoomDragon, 2000)
    ScriptHost:AddMemoryWatch("Prog - Anemos Door", getFlagAddr(0xA8B), 1, updateProgressionAnemosDoor, 2000)
    ScriptHost:AddMemoryWatch("Prog - Anemos Wings", getFlagAddr(0x8DF), 1, updateProgressionAnemosWings, 2000)
end

if AUTOTRACKER_TRACK_ITEMS then
    ScriptHost:AddMemoryWatch("Djinn", 0x02000046, 0xA, updateDjinn, 2000)
    ScriptHost:AddMemoryWatch("Summons", 0x0200024E, 0x2, updateSummons, 2000)
    
    ScriptHost:AddMemoryWatch("Inventory (Isaac)", 0x020005F8, 0x1E, updateInventoryIsaac, 2000)
    ScriptHost:AddMemoryWatch("Inventory (Garet)", 0x02000744, 0x1E, updateInventoryGaret, 2000)
    ScriptHost:AddMemoryWatch("Inventory (Ivan)", 0x02000890, 0x1E, updateInventoryIvan, 2000)
    ScriptHost:AddMemoryWatch("Inventory (Mia)", 0x020009DC, 0x1E, updateInventoryMia, 2000)
    ScriptHost:AddMemoryWatch("Inventory (Felix)", 0x02000B28, 0x1E, updateInventoryFelix, 2000)
    ScriptHost:AddMemoryWatch("Inventory (Jenna)", 0x02000C74, 0x1E, updateInventoryJenna, 2000)
    ScriptHost:AddMemoryWatch("Inventory (Sheba)", 0x02000DC0, 0x1E, updateInventorySheba, 2000)
    ScriptHost:AddMemoryWatch("Inventory (Piers)", 0x02000F0C, 0x1E, updateInventoryPiers, 2000)

    ScriptHost:AddMemoryWatch("Psynergy (Isaac)", 0x02000578, 0x80, updatePsynergyIsaac, 2000)
    ScriptHost:AddMemoryWatch("Psynergy (Garet)", 0x020006C4, 0x80, updatePsynergyGaret, 2000)
    ScriptHost:AddMemoryWatch("Psynergy (Ivan)", 0x02000810, 0x80, updatePsynergyIvan, 2000)
    ScriptHost:AddMemoryWatch("Psynergy (Mia)", 0x0200095C, 0x80, updatePsynergyMia, 2000)
    ScriptHost:AddMemoryWatch("Psynergy (Felix)", 0x02000AA8, 0x80, updatePsynergyFelix, 2000)
    ScriptHost:AddMemoryWatch("Psynergy (Jenna)", 0x02000BF4, 0x80, updatePsynergyJenna, 2000)
    ScriptHost:AddMemoryWatch("Psynergy (Sheba)", 0x02000D40, 0x80, updatePsynergySheba, 2000)
    ScriptHost:AddMemoryWatch("Psynergy (Piers)", 0x02000E8C, 0x80, updatePsynergyPiers, 2000)

    registerProgressionWatches()
    registerCharacterWatches()

    print("Autotracker is set up for item tracking")
end

if AUTOTRACKER_TRACK_LOCATIONS then
    initLocationData()

    ScriptHost:AddMemoryWatch("Djinn Hosts", 0x02000046, 0xA, updateDjinnHosts, 2000)
    ScriptHost:AddMemoryWatch("Summon Tablets", 0x02000042, 0x2, updateTablets, 2000)

    ScriptHost:AddMemoryWatch("Chests (0x800)", 0x02000140, 0x20, updateChests8, 2000)
    ScriptHost:AddMemoryWatch("Chests (0x900)", 0x02000160, 0x20, updateChests9, 2000)
    ScriptHost:AddMemoryWatch("Chests (0xA00)", 0x02000180, 0x20, updateChestsA, 2000)
    ScriptHost:AddMemoryWatch("Chests (0xB00)", 0x020001A0, 0x20, updateChestsB, 2000)
    ScriptHost:AddMemoryWatch("Chests (0xC00)", 0x020001C0, 0x20, updateChestsC, 2000)
    ScriptHost:AddMemoryWatch("Chests (0xD00)", 0x020001E0, 0x20, updateChestsD, 2000)
    ScriptHost:AddMemoryWatch("Chests (0xE00)", 0x02000200, 0x20, updateChestsE, 2000)
    ScriptHost:AddMemoryWatch("Chests (0xF00)", 0x02000220, 0x20, updateChestsF, 2000)

    if not AUTOTRACKER_TRACK_ITEMS then
        registerProgressionWatches()
        registerCharacterWatches()
    end

    print("Autotracker is set up for location tracking")
end