PLUGIN.Title = "PlayerClass"
PLUGIN.Description = " Player Class "
PLUGIN.Version = "2.0"
PLUGIN.Author = "Xevoxe"

local Player = {}
Player.__index = Player

function PLUGIN:CreatePlayer( playerData)
  return setmetatable(playerData , Player)
end

 Player.__newindex = function ( tab , key , value )
   if ( key == "Name") then tab.Members[key] = value return end
   if ( key == "Creation") then tab.Members[key] = value return end
   if ( key == "LastLogin") then tab.Members[key] = value return end
   if ( key == "Deaths") then tab.Members[key] = value return end
   if ( key == "Kills") then tab.Members[key] = value return end
   print(key.." is not a property of Player")
   
 end

api.Bind(PLUGIN, "PlayerClass")