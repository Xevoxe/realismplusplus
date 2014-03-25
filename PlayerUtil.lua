PLUGIN.Title = "PlayerUtility"
PLUGIN.Description = " Help script for playerdata"
PLUGIN.Version = "3.0"
PLUGIN.Author = "Xevoxe"

function PLUGIN:Init()
  
  print("Loading Player Utility Realism++ Version 3.0")
  if( not api.Exists( "PlayerMeta" )) then print("PlayerData Utility needs PlayerMeta")
  end
  Player = plugins.Find("PlayerMeta")
  
   local b , res = config.Read("playerdata")
  self.Config = res or {}
 
 --self.saveTimer = timer.Repeat( 600 , function() self:SaveServer() end )
end

--***************************************
--On Player Connect HOOK
--***************************************
function PLUGIN:OnUserConnect(netuser)
  local userID = rust.GetUserID(netuser)
  --Check if player table already exists
  if(config[userID]) then
    --exists
    --Set Player as a metatable to data
    config[userID] = Player:Create(config[userID])
else
  --does not exist
  --create new data and set player as a metatable
  local newplayer = { true , true , true , true , true , true }
  newplayer = Player:Create(newplayer)
  
  newplayer.Name = netuser.displayName
  
  local creation = System.DateTime.Now:ToString("M/dd/yyyy")
  newplayer.Creation = creation
  local date = System.DateTime.Now:ToString("M/dd/yyyy")
  local time = System.DateTime.Now:ToString("hhmm")
  newplayer.LastLogin = date.." "..time 
  local timePlayed = util.GetTime()
  newplayer.TimePlayerd = timePlayed
  newplayer.Deaths = 0 
  newplayer.Kills = 0 
  end
  
end

--*************************************
--Get player data using userID
--*************************************
function PLUGIN:GetPlayerData( userID )
  if(userID ~= nil) then
  return config[userID]
else
  print("Error: FUNC:GetPlayerData - expected userID got nil")
  return
end
end





