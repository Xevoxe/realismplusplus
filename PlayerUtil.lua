PLUGIN.Title = "PlayerUtility"
PLUGIN.Description = " Help script for playerdata"
PLUGIN.Version = "3.0"
PLUGIN.Author = "Xevoxe"

local Player = {}
local Crafting = {}

function PLUGIN:Init()
  
  print("Loading Player Utility Realism++ Version 3.0")

        if( not api.Exists( "PlayerUtil" )) then print("PlayerUtil needs PlayerMeta")
        end
        Player = plugins.Find("PlayerMeta")
        
        
        
   local b , res = config.Read("playerData")
    self.Config = res or {}
  if( not b ) then 
   -- self:LoadDefaultConfig()
   if ( res ) then config.Save("playerData") end
 end
 
 self.saveTimer = timer.Repeat( 90 , function() self:SaveServer() end )
 self:AddChatCommand( "saveall" , self.cmdSaveAll )
end

--***************************************
--Saves all realism player data
--***************************************
function PLUGIN:cmdSaveAll()
  self:SaveServer()
end




--***************************************
--On Player Connect HOOK
--***************************************
function PLUGIN:OnUserConnect(netuser)
  local userID = rust.GetUserID(netuser)
  --Check if player table already exists
  if(self.Config[userID]) then
    --exists
    --Set Player as a metatable to data
    self.Config[userID] = Player:CreatePlayer(self.Config[userID])
else
  --does not exist
  --create new data and set player as a metatable
  local newplayer = {}
  newplayer.Name = netuser.displayName
  newplayer.SteamID = userID
  newplayer.Creation = System.DateTime.Now:ToString("M/dd/yyyy")
  newplayer.LastLogin = util.GetTime() 
  self.Config[userID] = newplayer
  self.Config[userID] = Player:CreatePlayer(newplayer) 
  config.Save("playerData") --Remove this line for release version
  end 
end

--*************************************
--Get player data using userID
--*************************************
function PLUGIN:GetPlayer( userID )
  if(userID ~= nil) then
  return self.Config[userID]
else
  print("Error: FUNC:GetPlayerData - expected userID got nil")
  return
end
end

--**************************************
-- Save Player Data
--**************************************
function PLUGIN:SaveServer()
  config.Save("playerData")  
end

--**************************************
-- Find Netuser of player with displayname
--**************************************
function PLUGIN:FindPlayerNetuser ( name )
 local t , member = rust.FindNetUsersByName( util.QuoteSafe(name))
    if (not t) then
        if (targetuser == 0) then
          rust.Notice( member, "No players found with that name!" )
				return
			  else
				rust.Notice( member, "Multiple players found with that name!" )
				return
			  end
		end 
    return member
end  

--***************************************
--Add excess vault on player on respawn
--***************************************
function PLUGIN:OnSpawnPlayer( playerclient , usecamp , avatar )
  
  local netuser = playerclient.netuser
  timer.NextFrame( function() self:SpawnVault( netuser ) end )

end

function PLUGIN:SpawnVault(netuser)
  
  local userID = rust.GetUserID(netuser)
  local player = self:GetPlayer(userID)
  
  if(player.Vault > 0 ) then
  print(player.Vault)
  local inv = netuser.playerClient.rootControllable.idMain:GetComponent( "Inventory" )
  local datablock = rust.GetDatablockByName( "Sulfur" )
  local pref = rust.InventorySlotPreference( InventorySlotKind.Default, false, InventorySlotKindFlags.Belt )
  local arr = util.ArrayFromTable( System.Object, { datablock, player.Vault, pref } )
  inv:AddItemAmount( datablock, player.Vault , pref )
  player.Vault = 0
  end
end


api.Bind(PLUGIN, "PlayerUtil")


