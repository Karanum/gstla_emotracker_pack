function canAccessNaribwe()
    if Tracker:ProviderCountForCode("lemurian_ship") > 0 then
        return 1
    end

    if Tracker:ProviderCountForCode("briggs_battle") > 0 then
        return Tracker:ProviderCountForCode("frost") + Tracker:ProviderCountForCode("scoop")
    end

    return 0
end

function canAccessKibombo()
    if canAccessNaribwe() == 0 then
        return 0
    else
        if Tracker:ProviderCountForCode("lemurian_ship") > 0 then
            return 1
        end

        return Tracker:ProviderCountForCode("frost") + Tracker:ProviderCountForCode("whirlwind")
    end
end

function canSailShip()
    return Tracker:ProviderCountForCode("lemurian_ship")
end

function canAccessLemuria()
    return canSailShip() * (Tracker:ProviderCountForCode("grind") + (Tracker:ProviderCountForCode("trident") * hasDjinn("24")))
end

function canFlyShip()
    return canSailShip() * Tracker:ProviderCountForCode("hover") * (Tracker:ProviderCountForCode("wings_of_anemos") + Tracker:ProviderCountForCode("reunion"))
end

function canAccessWesternSeas()
    return canSailShip() * (Tracker:ProviderCountForCode("grind") + canFlyShip())
end

function canAccessShip()
    return (canSailShip() * (canAccessLemuria() + canAccessWesternSeas())) + (Tracker:ProviderCountForCode("gabomba_statue") * Tracker:ProviderCountForCode("black_crystal"))
end

function canAccessUpperMars()
    return Tracker:ProviderCountForCode("grind") * Tracker:ProviderCountForCode("mars_star") * Tracker:ProviderCountForCode("burst") * Tracker:ProviderCountForCode("blaze") * Tracker:ProviderCountForCode("reveal") * Tracker:ProviderCountForCode("teleport") * Tracker:ProviderCountForCode("pound")
end

function canAccessYampiBackside()
    return Tracker:ProviderCountForCode("scoop") + Tracker:ProviderCountForCode("sand") + canSailShip()
end

function neg(code)
    if Tracker:ProviderCountForCode(code) > 0 then
        return 0
    end
    return 1
end

function hasDjinn(num)
    if Tracker:ProviderCountForCode("sett_boss_logic") == 0 then
        return 1
    end

    local djinn = Tracker:ProviderCountForCode("venus") + Tracker:ProviderCountForCode("mars") + Tracker:ProviderCountForCode("jupiter") + Tracker:ProviderCountForCode("mercury")
    if djinn >= tonumber(num) then
        return 1
    end
    return 0
end

function canAccessInnerAnemos()
    local djinn = Tracker:ProviderCountForCode("venus") + Tracker:ProviderCountForCode("mars") + Tracker:ProviderCountForCode("jupiter") + Tracker:ProviderCountForCode("mercury")
    if djinn == 72 then
        return Tracker:ProviderCountForCode("teleport")
    else
        return Tracker:ProviderCountForCode("teleport") * Tracker:ProviderCountForCode("anemos_door")
    end
end