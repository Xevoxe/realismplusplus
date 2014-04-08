PLUGIN.Title = "Commands"
PLUGIN.Description = "This File Contains all the Chat Commands"
PLUGIN.Version = "1.0"
PLUGIN.Author = "Xevoxe"

function PLUGIN:Init()
   
  print("Loading Commands Version 1.0")
  if( not api.Exists( "PlayerUtil" )) then print("Commands needs PlayerUtil")
  end
  local PlayerUtil = plugins.Find("PlayerUtil")
  self:AddChatCommand("finger" , self.cmdFinger )
  self:AddChatCommand("support" , self.cmdSupporter )
  self:AddChatCommand("remover" , self.cmdRemover )
  self:AddChatCommand("location" , self.cmdLocation)
  
  
end


function PLUGIN:cmdLocation( netuser , cmd, args)
  local pos = netuser.playerclient.lastKnownPosition
  rust.SendChatToUser( netuser, "Current Position is X = "..math.ceil(pos.x).." Y = "..math.ceil(pos.y).." Z = "..math.ceil(pos.z))
end


--*************************************************
--              Supporter Commands                 
--*************************************************
function PLUGIN:cmdSupporter( netuser , cmd , args)
  
  if ( args[1] ~= nil and args[3] ~= nil) then
    local t , member = rust.FindNetUsersByName( util.QuoteSafe(args[3]))
    if (not t) then
        if (targetuser == 0) then
          rust.Notice( netuser, "No players found with that name!" )
				return
			  else
				rust.Notice( netuser, "Multiple players found with that name!" )
				return
			  end
		end 
      if (args[1] == "add" and netuser:CanAdmin()) then
        local userID = rust.GetUserID(member)
        local player = PlayerUtil:GetPlayer(userID)
           if( args[2] == "finger" ) then
             local support = {}
             support.Name = args[2]
             support.State = false
             support.Activated = true
             player:SetSupporterFlag(support)
             rust.Notice( netuser , "Finger Support added: "..member.displayName)
             return
           end
           
           if( args[2] == "nodecay" ) then
             local support = {}
             support.Name = args[2]
             support.Activated = true
             player:SetSupporterFlag(support)
             rust.Notice( netuser , "NoDecay Support added: "..member.displayName)
             return
           end
           
           if( args[2] == "remover" ) then
             local support = {}
             support.Name = args[2]
             support.State = false
             support.Activated = true
             support.Resource = false 
             support.On = false
             player:SetSupporterFlag(support)
             rust.Notice( netuser , "Remover Support added: "..member.displayName)
             return
           end
           
           if( args[2] == "resource" ) then
             player:SetSupporterAttrib( "remover" ,"Resource" , true )
             rust.Notice( netuser , "Resource Support added: "..member.displayName)
             return
           end  
      else
        if( args[1] == "remove" and netuser:CanAdmin()) then
           local userID = rust.GetUserID(member)
           local player = PlayerUtil:GetPlayer(tostring(userID))
          if( args[2] == "all" ) then
             player:SetSupporterAttrib( "finger" ,"Activated" , false )
             player:SetSupporterAttrib( "nodecay" ,"Activated" , false )
             player:SetSupporterAttrib( "remover" ,"Activated" , false )
             rust.Notice( netuser , "All Support remove: "..member.displayName)
            return
          end
          
          if( args[2] == "finger" ) then
            player:SetSupporterAttrib( "finger" ,"Activated" , false )
            rust.Notice( netuser , "Finger Support removed: "..member.displayName)
            return
          end
          if( args[2] == "nodecay" ) then
            player:SetSupporterAttrib( "nodecay" ,"Activated" , false )
            rust.Notice( netuser , "NoDecay Support removed: "..member.displayName)
            return
          end
          if( args[2] == "remover" ) then
            player:SetSupporterAttrib( "remover" ,"Activated" , false )
            rust.Notice( netuser , "Remover Support removed: "..member.displayName)
            return
          end
          if( args[2] == "resource" ) then
            player:SetSupporterAttrib( "remover" ,"Resource" , false )
            rust.Notice( netuser , "Resource Support removed: "..member.displayName)
            return
          end
        else
          rust.SendChatToUser(netuser , "Type \"add\" or \"remove\".")
        end
      end
      
else
  --Run Help PLUGIN Stuff
return  
end
end

function PLUGIN:cmdFinger( netuser, cmd , args)
  local player = self:GetPlayer ( netuser )
  if(player:GetSupporterAttrib("finger","Activated") ~= nil ) then
  player:SetSupporterAttrib( "finger" , "State" , true )
  rust.Notice( netuser, "Finger Activated" )
  return
end
rust.Notice( netuser, "Please purchase a Supportor Package" )
end

function PLUGIN:cmdRemover( netuser , cmd , args)
  local player = self:GetPlayer( netuser)
  if( args[1] == "on" ) then
  player:SetSupporterAttrib( "remover" , "On" , true )
  rust.Notice( netuser , "Remover has been turned ON." )
  return
end
if( args[1] == "off" ) then
  player:SetSupporterAttrib( "remover" , "On" , false)
  rust.Notice( netuser , "Remover has been turned OFF.")
  return
end

  if(player:GetSupporterAttrib("remover","Activated") ~= nil ) then
    player:SetSupporterAttrib( "remover" , "State" , true )
    rust.Notice( netuser, "Remover Activated") 
    return
 
 end
 rust.Notice( netuser, "Please purchase a Supportor Package" )
end


function PLUGIN:GetPlayer( netuser )
  local userID = rust.GetUserID ( netuser)
  local player = PlayerUtil:GetPlayer(userID)
  return player
end


