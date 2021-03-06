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
  newplayer.Friends = playerData.Friends or {}
  newplayer.Teleport = playerData.Teleport or 0
  newplayer.VisitStore = playerData.VisitStore or 1  
  newplayer.Vault = playerData.Vault or 0
  newplayer.Stores = playerData.Stores or 0
  newplayer.SupporterFlags = playerData.SupporterFlags or {}
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

function Player:AddFriend( steamID )
  local b , res = self.Friends[steamID]
  if(b) then 
    return false
  else 
    self.Friends[steamID] = steamID 
    return true
    end
end

function Player:RemoveFriend( steamID )
  if(self.Friends[steamID] ~= nil ) then
    self.Friends[steamID] = nil
    return true --Friend Removed
  else
    return false --Friend does not exist
  end
end

function Player:GetSupporterFlag( flag )
  local b , res = self.SupporterFlags[flag]
  if(b) then 
    return self.SupporterFlags[flag]
  else return false end
end


function Player:SetSupporterFlag( table )
  self.SupporterFlags[table.Name] = table
end

function Player:GetSupporterAttrib( flag , attrib )
  local b , res = self.SupporterFlags[flag]
  if(b) then
  return self.SupporterFlags[flag][attrib]
  else return false end
end

function Player:SetSupporterAttrib( flag , attrib , value )
  local b , res = self.SupporterFlags[flag]
  if(b) then
  self.SupporterFlags[flag][attrib] = value
  else return false end
end

 function Player:Killed()
   self.Deaths = self.Deaths + 1
   return
 end
 
 function Player:Murdered()
   self.Kills = self.Kills + 1
   return
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
    if(  key == "SteamID" )     then rawset( tab, key , value) return end
    if(  key == "Friends" )     then rawset( tab, key , value) return end
    if(  key == "Teleport" )    then rawset( tab, key , value) return end
    if(  key == "VisitStore" )  then rawset( tab, key , value) return end
    if(  key == "Vault")        then rawset( tab, key , value) return end
    if(  key == "Stores")       then rawset( tab, key , value) return end
    if(  key == "SupporterFlags") then rawset( tab, key , value) return end
   print(key.." is not a property of Player") 
 end
 
 
api.Bind(PLUGIN, "PlayerMeta")