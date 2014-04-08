PLUGIN.Title = "StructureMod"
PLUGIN.Description = "When strutures are placed."
PLUGIN.Version = "1.00"
PLUGIN.Author = "Xevoxe"

function PLUGIN:Init()
end

function PLUGIN:OnPlaceStructure(structure , pos)
  

local ground = self:GetRayCast(pos.x , pos.z)
local difference = pos.y - ground

if(difference > 25 ) then
  return false 
end


end

local Raycast = util.FindOverloadedMethod( UnityEngine.Physics, "RaycastAll", bf.public_static, { UnityEngine.Ray } )
cs.registerstaticmethod( "tmp", Raycast )
local RaycastAll = tmp
tmp = nil

function PLUGIN:GetRayCast( posX , posZ)
  local ray = new(UnityEngine.Ray)

local origin = new(UnityEngine.Vector3)

   origin.x = tonumber(posX)
   origin.z = tonumber(posZ)
   origin.y = 5000
   local direction = new(UnityEngine.Vector3)
   direction.x = 0
   direction.z = 0
   direction.y = -1
   ray.origin = origin
   ray.direction = direction
   local hits = RaycastAll( ray )
   local tbl = cs.createtablefromarray( hits )

   if (#tbl == 0) then
  
     return nil
   end
   local closest = tbl[1]
   local closestdist = closest.distance
   for i=2, #tbl do
    if (tbl[i].distance > closestdist) then
      closest = tbl[i]
      closestdist = closest.distance
    end
  end

  return closest.point.y
end




--returns the zone that the position is in
function PLUGIN:PositioninZone( pos , zonelist )
  local position = {}
  position.X = pos.x
  position.Y = pos.z
  
  for key , value in pairs(zonelist) do
   
  
    local zone = zonelist[key]
    if(zone:PointInsideZone(position)) then
  
      return zonelist[key]
      end
  end
  return nil  
end
