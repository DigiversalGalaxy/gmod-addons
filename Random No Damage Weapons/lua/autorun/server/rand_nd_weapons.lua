nd_weapons = {}

function randNDInitialWeapons()

    local player_ent_list = ents.GetAll()
    local player_npc_list = {}
    
    local i, v = nil, nil

    for i, v in ipairs(player_ent_list) do

        if(v:IsPlayer() or v:IsNPC()) then

            table.insert(player_npc_list, v)

        end

    end

    for i, v in ipairs(player_npc_list) do

        insertRandWeapons(v:GetWeapons())

    end

end

function insertRandWeapons(t)

    for i, v in ipairs(t) do

        if(math.random() - 0.5 >= 0) then

            table.insert(nd_weapons, v)
            print(v)

        end

    end

end

concommand.Add("rand_ndw", function(ply, cmd, args, str)

    if(tobool(args[1]) == GetGlobalBool("rand_ndw")) then return end
    
    SetGlobalBool("rand_ndw", tobool(args[1]))
    
    if(GetGlobalBool("rand_ndw")) then 
        
        randNDInitialWeapons()

        hook.Add("EntityTakeDamage", "checkND", function(t, d)

            local attac = d:GetAttacker()

            if(not attac:IsValid()) then return end
            
            local wep = attac:GetActiveWeapon()

            if(not wep:IsValid()) then return end

            for i, v in ipairs(nd_weapons) do

                if(wep == v) then

                    d:SetDamage(0)
                    return
                
                end

            end
        
        end)

        hook.Add("OnEntityCreated", "randNDNewWeapons", function(e)

            if(not e:IsValid() or not e:IsWeapon()) then return end

            insertRandWeapons({e})
        
        end)
    
    else
        
        nd_weapons = {}
        hook.Remove("EntityTakeDamage", "checkND")
        hook.Remove("OnEntityCreated", "randNDNewWeapons")
    
    end

end)

hook.Add("ShutDown", "RemoveCommand", function()

    concommand.Remove("rand_ndw")

end)