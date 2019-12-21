net.Receive("player_in_spawn", function(len)
    local ply = net.ReadEntity()
    local inSpawn = net.ReadBool()
    if(IsValid(ply) and ply:IsPlayer()) then
        if(inSpawn) then
            hook.Add( "HUDPaint", "SpawnProtEnabled", function()
                draw.DrawText("Spawn Protection Enabled", "TargetID", ScrW() * 0.5, ScrH() * 0.25, Color(200,200,200,255), TEXT_ALIGN_CENTER)
            end)
        else
            hook.Remove( "HUDPaint", "SpawnProtEnabled" )
        end
    end
end)