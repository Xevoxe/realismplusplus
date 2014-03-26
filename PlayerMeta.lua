PLUGIN.Title = "PlayerClass"
PLUGIN.Description = " Player Class "
PLUGIN.Version = "2.0"
PLUGIN.Author = "Xevoxe"

local Player = {}
Player.__index = Player

function PLUGIN:New()    --send in a new player Table
  return Player
  end

 Player.__newindex = function ( tab, key , value )
    if(  key == "Name" )        then rawset( tab, key, value ) return end
    if(  key == "Creation" )    then rawset( tab, key , value) return end 
    if(  key == "LastLogin" )   then rawset( tab, key , value) return end 
    if(  key == "TimePlayed" )  then rawset( tab, key , value) return end 
    if(  key == "Deaths" )      then rawset( tab, key , value) return end
    if(  key == "Kills" )       then rawset( tab, key , value) return end
   print(key.." is not a property of Player") 
 end
 
 

api.Bind(PLUGIN, "PlayerClass")