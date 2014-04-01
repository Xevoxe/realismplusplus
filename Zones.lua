PLUGIN.Title = "Zones"
PLUGIN.Description = "Zone class"
PLUGIN.Version = "1.0"
PLUGIN.Author = "Xevoxe"

local Zone = {}
Zone.__index = Zone

function Zone.New()
  local object = {}
  return setmetatable( object, Zone )
end

function PLUGIN:CreateZone(newZone)    --Requires a set of 4 vectors to create a Zone
  local zone = Zone.New()
  zone.Name = newZone.Name or "none"
  zone.A =  newZone.A or 0
  zone.B =  newZone.B or 0 
  zone.C =  newZone.C or 0 
  zone.D =  newZone.D or 0
  zone.Owner = newZone.Owner or nil
  local canBuild = newZone.CanBuild or {}
  zone.CanBuild = canBuild
  zone.Status = false
  return zone
end

--Will toggle the ability to build in an area.
function Zone:ToggleBuild(netuser)
  if(self.Status == true ) then
    self.Status = false
    rust.Notice( netuser, "Zone ["..self.Name.."] Building is OFF.")
else
    self.Status = true
    rust.Notice( netuser, "Zone ["..self.Name.."] Building is ON.")
end

  
  
end


 function Zone:PointInsideZone( vector ) --Takes a 2D Vector
 
  local testLineA = self.CheckLines(self.A , self.B, self.C)
  local testPoint = self.CheckLines(self.A,  self.B, vector)
     
  if(self.Sign(testLineA) == self.Sign(testPoint)) then  
      local testLineB = self.CheckLines(self.B , self.C, self.D)
      testPoint = self.CheckLines(self.B , self.C, vector)
     
        if(self.Sign(testLineB) == self.Sign(testPoint)) then
          local testLineC = self.CheckLines(self.C , self.D, self.A)
          testPoint = self.CheckLines(self.C, self.D , vector ) 
         
          if(self.Sign(testLineC) == self.Sign(testPoint)) then
              local testLineD = self.CheckLines(self.D , self.A, self.B)
              testPoint = self.CheckLines(self.D, self.A, vector)
              
              if(self.Sign(testLineD) == self.Sign(testPoint)) then
                return true --Point is inside rectangle
              end
          end
        end
  end
return false --Point Does not fall inside zone
end

function PLUGIN:AddBuilder( steamID )
  for i = 1 , 1 , zone[#CanBuild] do
    if(steamID == zone.CanBuild[i] ) then
      return false
      end
  end
  zone.CanBuild[#CanBuild+1] = steamID
  return true   
end

function PLUGIN:CheckBuildList ( steamID )
  for i = 1 , 1 , zone[#CanBuild] do
     if(steamID == zone.CanBuild[i] ) then
      return true
    end
    end
    return false   
    
end


function Zone.CheckLines( vectorOne , vectorTwo, vector)
  
  local test = vector.Y - vectorOne.Y - ((vectorTwo.Y - vectorOne.Y) / (vectorTwo.X - vectorOne.X)) * (vector.X - vectorOne.X)
  return test
end

function Zone.Sign( number )
--If Sign is negative then false
if( number < 0 ) then
  return false
else
  return true
end
end



--Determins the distance between 2 Vectors
function Zone:DistanceBetweenPoints( vectorA , vectorB)
  
  local distance = math.sqrt( math.exp(vectorB.X - vectorA.X,2)+ math.exp(vectorB.Y - vectorA.Y , 2 ))
  
  return distance
end

Zone.__newindex = function ( tab, key , value )
    if(  key == "A" )        then rawset( tab, key, value ) return end
    if(  key == "B" )        then rawset( tab, key, value ) return end
    if(  key == "C" )        then rawset( tab, key, value ) return end
    if(  key == "D" )        then rawset( tab, key, value ) return end
    if(  key == "Name")      then rawset( tab, key, value ) return end
    if(  key == "CanBuild")  then rawset( tab, key, value ) return end
    if(  key == "Owner")     then rawset( tab, key, value ) return end
     if( key == "Status")    then rawset( tab, key, value ) return end
    
end
api.Bind(PLUGIN, "ZonesClass")