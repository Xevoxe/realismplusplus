PLUGIN.Title = "Friends"
PLUGIN.Description = " Friends related code. "
PLUGIN.Version = "1.0"
PLUGIN.Author = "Xevoxe"

local TELEPORTCD = 21600 --6 Hours
local pending = {}
function PLUGIN:Init()
  print("Loading Who Mod")
  PlayerUtil = plugins.Find("PlayerUtil")
  if( not api.Exists( "PlayerUtil" )) then print("Friends needs PlayerUtil1.0") end
  
  self:AddChatCommand( "who" , self.cmdWho )
  self:AddChatCommand( "friend" , self.cmdFriend)
end

--**********************************************
--List Friends that are online as well as total players online
--**********************************************
function PLUGIN:cmdWho( netuser , cmd , args )
  local userID = rust.GetUserID(netuser)
  local player = PlayerUtil:GetPlayer( userID )
  local list = player.Friends
  local counter = 0
  local cnt = 0 
  for key , value in pairs(rust.GetAllNetUsers()) do
    local otherUserID = rust.GetUserID(value)
    if(list[otherUserID] ~= nil ) then
      rust.SendChatToUser( netuser , value.displayName )
      cnt = cnt + 1
    end
    counter = counter + 1    
  end
  rust.SendChatToUser( netuser , "["..cnt.."] Friends out of ["..counter.."] connected players.")
end

--**********************************************
--/friend All friend commands
--**********************************************
function PLUGIN:cmdFriend( netuser , cmd , args )
  
if(args[1] ~= nil ) then
   args[1] = string.lower(args[1])
   
   local userID = rust.GetUserID(netuser)
   local player = PlayerUtil:GetPlayer(userID)
--**********************************************
--/pending --List pending friend request.  Resets on reboot.
--**********************************************
  if(args[1] == "pending") then
    rust.SendChatToUser( netuser , "Pending Friend Invites:" )
    for i = 1 , #pending , 1 do 
      print(pending)
      if(pending[i].Invitee == userID) then
        rust.SendChatToUser( netuser , pending[i].InvitorName)      
    end
    end
    return
  end

--**********************************************
--Following commands requires a Player as 2nd argument.
--**********************************************
  if(args[2] ~= nil ) then      
    local otherPlayer = PlayerUtil:FindPlayerNetuser(args[2])
    if(otherPlayer == nil) then
      print("Error Netuser Not found")
      return
    end
    local otherUserID = rust.GetUserID(otherPlayer)
    local otherPerson = PlayerUtil:GetPlayer(otherUserID)
--**********************************************
--/add [player] --Adds a friend 
--**********************************************
  if(args[1] == "add" ) then
    local index = #pending
    if(index == 0) then
      index = 1
    end
    pending[index] = {}
    pending[index].Name = otherPlayer.displayName
    pending[index].Invitee = otherUserID
    pending[index].Invitor = userID
    pending[index].InvitorName = netuser.displayName
    rust.SendChatToUser ( netuser , "You have invited ["..otherPlayer.displayName.."] to be your friend.")
    rust.Notice( otherPlayer , netuser.displayName.." has invited you to be their friend." )
    rust.SendChatToUser( otherPlayer , "/friend accept \""..netuser.displayName.."\"")
    return
    end
--**********************************************
--/remove [player] --Removes a friend or cancels an invite
--**********************************************
  if(args[1] == "remove") then
    
    if(player:RemoveFriend(otherUserID)) then
      rust.SendChatToUser ( netuser , "You have removed ["..otherPlayer.displayName.."] from your friend's list.")
      rust.SendChatToUser ( otherPlayer , netuser.displayName.." has removed you from their friend's list.")
      otherPerson:RemoveFriend(userID)
      return
    else   
    --Check pending
        for i = 1 , #pending , 1 do
          local invitee = pending[i].Invitee  
         if(invitor == userID) then 
           local invitee = pending[i].Invitee
           if(invitee == otherUserID) then 
             table.remove(pending , i) --Remove from pending list
             rust.SendChatToUser( netuser , "You have rescinded your friend invite from "..otherPlayer.displayName )
             return
           end
          end 
        end
    rust.SendChatToUser( netuser , "You are not friends with that person.")
  end
  return
end
   
--**********************************************
--/accept [player] --Accepts a friend
--**********************************************
 if(args[1] == "accept") then
   for i = 1 , #pending , 1 do
     local invitee = pending[i].Invitee  
     if(invitee == userID) then --This person has a friends request
       local invitor = pending[i].Invitor
       if(invitor == otherUserID) then --This person has accepted the others friend request
         player:AddFriend(otherUserID) --Add other person to friends list
         otherPerson:AddFriend(userID) --Add the person who accepted to friends list
         table.remove(pending , i)
         return
       end
     end
     rust.SendChatToUser( netuser , "That person has not sent you a friend's request.")   
   end  
   return
   end
--**********************************************
--/tele [player] --Teleports to friend
--**********************************************
  if(args[1] == "tele" ) then
   local list = player.Friends
   if(list[otherUserID] ~= nil ) then
    local lastTeleport = player.Teleport
    local time = util.GetTime()
    lastTeleport = time - lastTeleport
      if( TELEPORTCD - lastTeleport <= 0 ) then --okay to teleport 6 hour cooldown
         rust.Notice ( netuser , "Teleporting in 30 seconds.")
         rust.Notice ( otherPlayer , netuser.displayName.." is teleporting in 30 seconds.")
         timer.Once( 30 , function () self:Teleport(otherPlayer , netuser) end )
         player.Teleport = time

      else
        rust.SendChatToUser( netuser , "Your teleportation is still on cool down for "..(TELEPORTCD - lastTeleport).." seconds.")
      end
    else
      rust.SendChatToUser( netuser , otherPlayer.displayName.." is not a friend of yours. Cannot teleport to them.")
    return
  end
end


  else
   rust.SendChatToUser( netuser ,"Syntax: /friend [command] \"[player name]\"" )
   rust.SendChatToUser( netuser, "Commands: add, remove , accept , tele" )
  end
else
 rust.SendChatToUser( netuser , "Syntax: /friend [command]")
 rust.SendChatToUser( netuser , "Commands: pending, tele, add , remove , accept")
end  
end

function PLUGIN:Teleport( toPlayer , player )
  rust.ServerManagement():TeleportPlayerToPlayer( player.networkPlayer, toPlayer.networkPlayer )
	rust.Notice( player, "You teleported to '" .. util.QuoteSafe( toPlayer.displayName ) .. "'!" )
	rust.Notice( toPlayer, "'" .. util.QuoteSafe( player.displayName ) .. "' teleported to you!" )
end

