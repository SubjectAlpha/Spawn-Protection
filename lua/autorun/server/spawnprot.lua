local meta = FindMetaTable("Entity")
--[[ this creates spawn protection boxes
You can create as many boxes as you want. 
Just remember you have to change the number values of the box, as well as add vectors]]
local sBoxes = {
        [1] = {
                Vector(0, 0, 0), --Start of box 1, type getpos to get these vectors to start the box. (Recommended you set this first below the map)
                Vector(0, 0, 0), --End of box 1, type getpos to get the closing area of the box. To work the vector must be set higher (in the map)
        },
        [2] = {
                Vector(0, 0, 0), --Start of box 2
                Vector(0, 0, 0), --End of box 2
        },
}
-- Do not touch this function.
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
-- Do not touch this function.
function meta:SetWeapon(wep_name)
        for _,v in pairs(self:GetWeapons()) do
                if v:GetClass() == wep_name then
                        self:SetActiveWeapon(v)
                end
        end
end
 
-- This strips all weapons while in the box and switchets the players weapon to a physgun.
timer.Create("SpawnCheck", 0, 0, function()
        for _,v in pairs(player.GetAll()) do
                if IsValid(v) then
                        if v:IsInSpawn() then
                                v:SetWeapon("weapon_physgun")
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
