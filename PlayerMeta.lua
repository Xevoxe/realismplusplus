PLUGIN.Title = "PlayerClass"
PLUGIN.Description = " Player Class "
PLUGIN.Version = "2.0"
PLUGIN.Author = "Xevoxe"

local Player = {}
Player.__index = Player

function PLUGIN:Init()
  print("Player Metatable Loading")
end

function Player.New()    --send in a new player Table
    
    local object = {}  --Class Object

    return setmetatable( object , Player )
  end

function PLUGIN:CreatePlayer( playerData)
  print("Creating Player")
  local newplayer = Player.New()
  newplayer.SteamID = playerData.SteamID or 0
  newplayer.Deaths = playerData.Deaths or 0
  newplayer.Kills = playerData.Kills or 0
  newplayer.Name = playerData.Name or "Name"
  newplayer.LastLogin = playerData.LastLogin or "12/1/11"
  newplayer.Creation = playerData.Creation or "12/1/11"
  newplayer.TimePlayed = playerData.TimePlayed or 0
  newplayer.BluePrints = playerData.BluePrints or {}
  return newplayer
end


--***********************************************************************
--Learn Blueprint
--***********************************************************************
function Player:LearnBlueprint( item )
  
  local b , res = self.BluePrints[item]
  if(b) then 
    return false
  else 
    self.BluePrints[item] = 0 
    return true
    end
end

--***********************************************************************
--Get Blueprint Level
--***********************************************************************
function Player:GetBlueprintLevel ( item )
  return self.BluePrints[item]
end


 Player.__newindex = function ( tab, key , value )
    if(  key == "Name" )        then rawset( tab, key, value ) return end
    if(  key == "Creation" )    then rawset( tab, key , value) return end 
    if(  key == "LastLogin" )   then rawset( tab, key , value) return end 
    if(  key == "TimePlayed" )  then rawset( tab, key , value) return end 
    if(  key == "Deaths" )      then rawset( tab, key , value) return end
    if(  key == "Kills" )       then rawset( tab, key , value) return end
    if(  key == "Skills" )      then rawset( tab, key , value) return end
    if(  key == "BluePrints" )  then rawset( tab, key , value) return end
     if( key == "SteamID" )     then rawset( tab, key , value) return end
   print(key.." is not a property of Player") 
 end
 
 
api.Bind(PLUGIN, "PlayerMeta")