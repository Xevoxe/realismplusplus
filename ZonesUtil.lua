PLUGIN.Title = "Zones Utility"
PLUGIN.Description = "Zone Utility"
PLUGIN.Version = "1.0"
PLUGIN.Author = "Xevoxe"

local MAXLINELENGTH = 250
local Zone = nil
local newZone = {} 
local zoneList = {}
function PLUGIN:Init()
  print("Loading Zone Utility Version 1.0") 
 local b , res = config.Read("zones")
  self.Config = res or {}
  if( not b ) then 
   -- self:LoadDefaultConfig()
   if ( res ) then config.Save("zones") end
 end

if not Zones then
        Zones = cs.findplugin("Zones")
        if not Zones then
          return false
        end
      end

   self:AddChatCommand("createzone" , self.cmdCreateZone )
   self:AddChatCommand("setpoint" , self.cmdSetPoint )
   self:AddChatCommand("savezone" , self.cmdSaveZone )
   self:AddChatCommand("addbuilder" , self.cmdAddBuilder)
   self:AddChatCommand("zones" , self.cmdZones)
   self:AddChatCommand("togglebuild" , self.cmdToggleBuild)
   self:LoadZones()
end


function PLUGIN:cmdZones(netuser, cmd , args)
  if(args[1] == nil ) then
  for key , value in pairs(zoneList) do
    rust.SendChatToUser(netuser, key)   
  end
else
  local zone = string.lower(args[1])
  if(zoneList[zone] ~= nil) then
    rust.SendChatToUser( netuser, "Name: "..zoneList[zone].Name)
    rust.SendChatToUser( netuser, "CanBuild: "..tostring(zoneList[zone].Status))
    rust.SendChatToUser( netuser, "A  Corner X="..zoneList[zone].A["X"].."] Z=["..zoneList[zone].A["Y"].."]")
    rust.SendChatToUser( netuser, "B  Corner X="..zoneList[zone].B["X"].."] Z=["..zoneList[zone].B["Y"].."]")
    rust.SendChatToUser( netuser, "C  Corner X="..zoneList[zone].C["X"].."] Z=["..zoneList[zone].C["Y"].."]")
    rust.SendChatToUser( netuser, "D  Corner X="..zoneList[zone].D["X"].."] Z=["..zoneList[zone].D["Y"].."]")
  end
end
end

function PLUGIN:cmdToggleBuild(netuser, cmd, args)
  
  local userID = rust.GetUserID(netuser)
  
  if(args[1] ~= nil ) then
    local zone = string.lower(args[1])
    if(zoneList[zone] ~= nil) then
      if(zoneList[zone].Owner == userID or zoneList[zone]:CanBuild( userID)) then
        zoneList[zone]:ToggleBuild(netuser)
      else
        rust.Notice( netuser, "You do not have access to that zone." ) end
    else
      rust.Notice( netuser, "That zone does not exist!") end
  else
    rust.Notice( netuser, "You must specify a zone to edit.") end
  
end


--This function creates a zone class from the data loaded in self.Config
function PLUGIN:LoadZones()
  
  for key , value in pairs(self.Config) do
    --newZone = Zones:CreateZone(self.Config[key].Name)
    newZone.A = value.A
    newZone.B = value.B
    newZone.C = value.C
    newZone.D = value.D
    newZone.CanBuild = value.CanBuild
    newZone.Owner = value.Owner
    newZone.Name = value.Name
    local zone = Zones:CreateZone(newZone)

    zoneList[key] = zone
    newZone = {}
  end 
end

--Returns all currently loaded zones
function PLUGIN:GetZones()
  print("Return zoneList")
   for key , value in pairs(zoneList) do
    print(key)
  end
  return zoneList
end
--Allows an admin to add a person that is not an admin to edit a zone
function PLUGIN:cmdAddBuilder( netuser, cmd , args)
  if(args[1]) then
  local t , member = rust.FindNetUsersByName( util.QuoteSafe(args[1]))
            if (not t) then
                  if (targetuser == 0) then
                    rust.Notice( netuser, "No players found with that name!" )
                  return
                  else
                  rust.Notice( netuser, "Multiple players found with that name!" )
                  return
                  end
            end 
            local memberID = rust.GetUserID(member)
            local zonename = string.lower(args[2])
            if(memberID and zoneList[zonename] ) then
              if(zoneLIst[zonename]:AddBuilder(memberID)) then
                rust.SendChatToUser( netuser , member.displayName.." was added to the build list of zone ["..zonename.."]")
                rust.SendChatToUser( member , netuser.displayName.. " added you to the build list of zone ["..zonename.."]")
              else
                rust.SendChatToUser( netuser , "Unable to add "..member.displayName.." to zone ["..zonename.."]")
                end
          else
            rust.Notice( netuser, "That Zone does not exist.")
            end
            
  else
    rust.Notice( netuser, "You must supply a person.")
  end
  
end


function PLUGIN:cmdSetPoint( netuser, cmd , args )
  if( args[2] ~= nil ) then
    if(args[1] ~= nil) then
    local zone = string.lower(args[1])
    local corner = string.upper(args[2])
     if(newZone) then   
       local pos = netuser.playerClient.lastKnownPosition
       local position = {}
       position.X = math.floor(pos.x)
       position.Y = math.floor(pos.z)   
       rust.SendChatToUser(netuser , "X = "..position.X.." Y = "..position.Y)
       if(args[2] == "A") then
         newZone.A = position
         rust.SendChatToUser( netuser , "Set Corner A." )
       else
         if(args[2] == "B" ) then
           newZone.B = position
           rust.SendChatToUser( netuser , "Set Corner B." )
         else
           if(args[2] == "C" ) then
             newZone.C = position
             rust.SendChatToUser( netuser , "Set Corner C." )
           else
             if(args[2] == "D" ) then
               newZone.D = position
               rust.SendChatToUser( netuser , "Set Corner D." )
             else
               rust.SendChatToUser( netuser , "That is not a valid corner must be: A B C D")
             end
            end
          end
        end       
     else
       rust.SendChatToUser( netuser, "That is not a valid zone.  Must Create Zones first.") end
       
  else
    rust.SendChatToUser( netuser, "You must supply a corner to edit A B C D.") end
else
  rust.SendChatToUser( netuser, "You must supply a zone to edit." ) end
end

function PLUGIN:cmdCreateZone(netuser , cmd, args)
  if(netuser:CanAdmin()) then
    
    if(args[1] ~= nil ) then
      local name = string.lower(args[1])
      if(not self.Config[args[1]]) then
      newZone.Name = name
      newZone.Owner = rust.GetUserID(netuser)
      rust.Notice ( netuser , newZone.Name.." zone created.")
      else
      rust.SendChatToUser( netuser, "That Zone is already created.") end
    else
    rust.SendChatToUser( netuser, "You must supply a zone name.") 
    end
    
  else
  rust.SendChatToUser( netuser, "You must be an admin to use this comand.")
  end
end

function PLUGIN:cmdSaveZone( netuser, cmd , args)
  if(newZone.A ~= nil ) then
    if(newZone.B ~= nil) then
      if(newZone.C ~= nil) then
        if(newZone.D ~= nil) then
          zone = Zones:CreateZone(newZone)
          self.Config[newZone.Name] = zone
          zoneList[newZone.Name] = zone
          config.Save("zones")
          newZone = {}
          rust.Notice(netuser , zone.Name.." has been saved.")
        else
          rust.SendChatToUser(netuser, "Corner D not entered.")
        end
      else
        rust.SendChatToUser(netuser, "Corner C not entered.")
      end
    else
      rust.SendChatToUser(netuser, "Corner B not entered.")
    end
  else
    rust.SendChatToUser(netuser, "Corner A not entered.")
  end
end
api.Bind(PLUGIN, "ZonesUtil")
