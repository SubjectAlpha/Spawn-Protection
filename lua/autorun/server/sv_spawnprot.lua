util.AddNetworkString( "player_in_spawn" )
local meta = FindMetaTable("Entity")

--Initilization of box areas
local sBoxes = {
    [1] = {
        Vector(-5743.565430, -8658.199219, 1153.013184), --Start of box 1, type getpos to get these vectors to start the box. (Recommended you set this first below the map)
        Vector(-8241.015625, -10732.653320, -156.267517), --End of box 1, type getpos to get the closing area of the box. To work the vector must be set higher (in the map)
    }
}

--Check to see if player is in spawn
function meta:IsInSpawn()
    for _,boxes in pairs(sBoxes) do
        for _,ent in pairs(ents.FindInBox(boxes[1], boxes[2])) do
            if IsValid(ent) and ent == self then
                return true
            end
        end
    end
    return false
end

--Sets players weapon to the one specified specified
function meta:SetWeapon(wep_name)
    for _,v in pairs(self:GetWeapons()) do
        if v:GetClass() == wep_name then
            self:SetActiveWeapon(v)
        end
    end
end

--main timer loop to perform checks on players
timer.Create("SpawnCheck", 0, 0, function()
    for _,v in pairs(player.GetAll()) do
        if IsValid(v) then
            net.Start("player_in_spawn")
            net.WriteEntity(v)
            if v:IsInSpawn() then
                net.WriteBool(true)
                net.Send(v)
                v:SetWeapon("weapon_physgun")
            else
                net.WriteBool(false)
                net.Send(v)
            end
        end
    end
    for _,v in pairs(ents.FindByClass("prop_physics")) do
            if IsValid(v) and v:IsInSpawn() then
                v:Remove()
            end
    end
end)

-- This grants god mode while in spawn.
hook.Add("EntityTakeDamage", "SpawnProt", function(target, dmginfo)
    if target:IsPlayer() and target:IsInSpawn() then
        dmginfo:ScaleDamage(0)
    end
    return dmginfo
end)