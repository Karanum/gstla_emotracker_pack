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
    if Tracker:ProviderCountForCode("burst") > 0 and Tracker:ProviderCountForCode("blaze") > 0 and Tracker:ProviderCountForCode("reveal") > 0 and Tracker:ProviderCountForCode("teleport") > 0 and Tracker:ProviderCountForCode("pound") > 0 then
        return Tracker:ProviderCountForCode("mars_star")
    end
	return 0
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
        return Tracker:ProviderCountForCode("teleport") * ( ((djinn >= 72) and 1 or 0) + Tracker:ProviderCountForCode("anemos_door"))
    end
end