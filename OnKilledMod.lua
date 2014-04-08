PLUGIN.Title = "OnKilled"
PLUGIN.Description = "Place all on killed stuff here"
PLUGIN.Version = "1.2"
PLUGIN.Author = "Xevoxe"

local Weapon = nil

function PLUGIN:Init()

        Player = cs.findplugin("PlayerUtil")

end

function PLUGIN:OnKilled(takedamage , damage)
  
  if(damage.victim.client and damage.attacker.client) then
    if (takedamage:GetComponent( "HumanController" )) then
    local killMsg = ""
    local suicide = (damage.victim.client == damage.attacker.client)

       local defenderPosition = damage.victim.client.netUser.playerClient.lastKnownPosition
       local attackerPosition = damage.attacker.networkView.gameObject:GetComponent("Transform").Position
       local distance = UnityEngine.Vector3.Distance( defenderPosition, attackerPosition )
       local weapon
        if(damage.extraData) then
          weapon = damage.extraData.dataBlock.name
        end
        if( weapon) then 
          weapon = weapon
        else 
          weapon = "Unknown"
        end
             
        if( not suicide ) then
        local killMsg = damage.attacker.client.netUser.displayName.." ☠ "..damage.victim.client.netUser.displayName.." at "..math.floor(distance/3.28).." meters with a ["..weapon.."]"
        rust.BroadcastChat(killMsg)
         end    
        local attackernetUser = damage.attacker.client.netUser
        local defendernetUser = damage.victim.client.netUser
        
        --Increase kills for attacker
        local attacker = PlayerUtil:GetPlayer(rust.GetUserID(attackernetUser))
        local defender = PlayerUtil:GetPlayer(rust.GetUserID(defendernetUser))
        
        attacker:Murdered()
        defender:Killed()
        return
    end
  end
  

    --When a player takes damage from all other souces
    if(damage.victim.client) then
   
      local defendernetUser = damage.victim.client.netUser
      local defender = PlayerUtil:GetPlayer(rust.GetUserID(defendernetUser))
      defender:Killed()
      defender.AvgLifeSpan = self:CalculateLifeSpan(defender.LastKilledTime , defender.AvgLifeSpan , defender.Deaths, defender.SurvivalTime )
      defender.LastKilledTime = util.GetTime()
      defender.SurvivalTime = 0 
      return
    end   
end
function PLUGIN:CalculateLifeSpan ( time , avg , deaths, survivalTime)
  local currentTime = util.GetTime()
  local survived = (currentTime - time) +survivalTime
  local lifespan = ((avg * (deaths - 1 )) + survived) / deaths 
  return lifespan
end