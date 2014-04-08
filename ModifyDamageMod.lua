PLUGIN.Title = "ModifyDamage"
PLUGIN.Description = "When damage occurs this mod handles it."
PLUGIN.Version = "1.0"
PLUGIN.Author = "Xevoxe"

--Local Globals
local Weapon = nil
function PLUGIN:Init()
  print("Loading Modify Damage Version 1.0") 

    if( not api.Exists( "PlayerUtil" )) then print("ModifyDamageMod needs PlayerUtil")
  end
  local PlayerUtil = plugins.Find("PlayerUtil")

end

local RemovableItem = {}
RemovableItem["Wood_Shelter(Clone)"] = { name = "Wood Shelter", give = "Wood", giveAmount = 50 }
--RemovableItem["Campfire(Clone)"] = {name="Camp Fire", give="Wood",giveAmount=50 }
RemovableItem["Furnace(Clone)"] = { name = "Furnace", give = "Stones", giveAmount = 30 }
RemovableItem["Workbench(Clone)"] = { name = "Workbench", give = "Wood", giveAmount = 50 }
RemovableItem["SingleBed(Clone)"] = { name = "Bed", give = "Metal Fragments", giveAmount = 50 }
--RemovableItem["SleepingBagA(Clone)"] = {name="Sleeping Bag", give="Cloth",giveAmount=10 }
-- Attack and protect
--RemovableItem["LargeWoodSpikeWall(Clone)"] = {name="Large Spike Wall", give="Wood",giveAmount=100 }
--RemovableItem["WoodSpikeWall(Clone)"] = {name="Spike Wall", give="Wood",giveAmount=50 }
RemovableItem["Barricade_Fence_Deployable(Clone)"] = { name = "Wood Barricade", give = "Wood", giveAmount = 30 }
RemovableItem["WoodGateway(Clone)"] = { name = "Wood Gateway", give = "Wood", giveAmount = 400 }
RemovableItem["WoodGate(Clone)"] = { name = "Wood Gate", give = "Wood", giveAmount = 120 }
-- Storage
RemovableItem["WoodBoxLarge(Clone)"] = { name = "Large Wood Storage", give = "Wood", giveAmount = 60 }
RemovableItem["WoodBox(Clone)"] = { name = "Wood Storage Box", give = "Wood", giveAmount = 30 }
RemovableItem["SmallStash(Clone)"] = { name = "Small Stash", give = "Cloth", giveAmount = 5 }
-- Structure Wood
RemovableItem["WoodFoundation(Clone)"] = { name = "Wood Foundation", give = "Wood", giveAmount = 80 }
RemovableItem["WoodWindowFrame(Clone)"] = { name = "Wood Window", give = "Wood", giveAmount = 40 }
RemovableItem["WoodDoorFrame(Clone)"] = { name = "Wood Doorway", give = "Wood", giveAmount = 40 }
RemovableItem["WoodWall(Clone)"] = { name = "Wood Wall", give = "Wood", giveAmount = 40 }
RemovableItem["WoodenDoor(Clone)"] = { name = "Wooden Door", give = "Wood", giveAmount = 40 }
RemovableItem["WoodCeiling(Clone)"] = { name = "Wood Ceiling", give = "Wood", giveAmount = 60 }
RemovableItem["WoodRamp(Clone)"] = { name = "Wood Ramp", give = "Wood", giveAmount = 50 }
RemovableItem["WoodStairs(Clone)"] = { name = "Wood Stairs", give = "Wood", giveAmount = 30 }
RemovableItem["WoodPillar(Clone)"] = { name = "Wood Pillar", give = "Wood", giveAmount = 20 }
-- Structure Metal
RemovableItem["MetalFoundation(Clone)"] = { name = "Metal Foundation", give = "Metal Fragments", giveAmount = 30 }
RemovableItem["MetalWall(Clone)"] = { name = "Metal Wall", give = "Metal Fragments", giveAmount = 20 }
RemovableItem["MetalDoorFrame(Clone)"] = { name = "Metal Doorway", give = "Metal Fragments", giveAmount = 20 }
RemovableItem["MetalDoor(Clone)"] = { name = "Metal Door", give = "Metal Fragments", giveAmount = 40 }
RemovableItem["MetalCeiling(Clone)"] = { name = "Metal Ceiling", give = "Metal Fragments", giveAmount = 40 }
RemovableItem["MetalStairs(Clone)"] = { name = "Metal Stairs", give = "Metal Fragments", giveAmount = 30 }
RemovableItem["MetalRamp(Clone)"] = { name = "Metal Ramp", give = "Metal Fragments", giveAmount = 30 }
RemovableItem["MetalBarsWindow(Clone)"] = {name="Metal Window Bars", give="Metal Fragments",giveAmount=50, needRemove = true }
RemovableItem["MetalWindowFrame(Clone)"] = { name = "Metal Window", give = "Metal Fragments", giveAmount = 20 }
RemovableItem["MetalPillar(Clone)"] = { name = "Metal Pillar", give = "Metal Fragments", giveAmount = 10 }


local getStructureMasterOwnerId = util.GetFieldGetter(Rust.StructureMaster, "ownerID", true)
local getDeployableObjectId = util.GetFieldGetter(Rust.DeployableObject, "ownerID" , true)
local NetCullRemove = util.FindOverloadedMethod(Rust.NetCull._type, "Destroy", bf.public_static, {UnityEngine.GameObject})

function PLUGIN:ModifyDamage(takedamage , damage )
  
  
  local deployableObject = takedamage:GetComponent("DeployableObject")
  local structureComponent = takedamage:GetComponent("StructureComponent")
  local player , netUser = self:GetPlayer( damage )
   --print(player.SteamID)
    if ( player ) then      --A Player is Attacking Something.
      
      if( deployableObject ) then  --Player Attacked a Deployable Object
        
        local deployableOwnerID = getDeployableObjectId(deployableObject)
        
        if(player:GetSupporterAttrib("finger" , "State")) then  --Player is not attacking but fingering
                   local ownerID = tonumber(deployableOwnerID)
                   local fingeredperson = PlayerUtil:GetPlayer(tostring(ownerID))
                   rust.Notice( netUser, fingeredperson.Name.." owns this.")
                   player:SetSupporterAttrib("finger" , "State" , false )
                   local mod_damage = damage.amount
                   damage.amount = 0 --Damage is not calculated for finger 
        return damage
      end
    --[[
      if(player:GetSupporterAttrib("nodecay" , "Activated")) then
       --Block Damage
     
       local dmg = damage.amount
       damage.amount = 0
       local test = damage.amount
       print("Block Decay Damage "..damage.amount.." to "..deployableOwnerID.." "..tostring(deployableObject))
       return damage
end--]]
      end

      if(structureComponent) then --A player is attacking a Structure
         
         local structureOwner = structureComponent._master
         local structureOwnerID = getStructureMasterOwnerId(structureOwner)
         
         if(player:GetSupporterAttrib("finger" , "State")) then  --Player is not attacking but fingering
                     
                         local ownerID = tonumber(structureOwnerID)
                         local fingeredperson = PlayerUtil:GetPlayer(tostring(ownerID))
                         if( fingeredperson == nil ) then
                           rust.Notice( netUser, "This is temporarily abandoned." )
                           else
                         rust.Notice( netUser, fingeredperson.Name.." owns this.")
                         end
                         player:SetSupporterAttrib("finger" , "State" , false )
                         local mod_damage = damage.amount
                         damage.amount = 0 --Damage is not calculated for finger 
              return damage
            end
            
          if(tonumber(structureOwnerID) == tonumber(player.SteamID) or netUser:CanAdmin()) then --Player owns this structure
            if(player:GetSupporterAttrib("remover" , "Activated")) then --Player is a supportor
            
                local name = takedamage.gameObject.Name
                if(player:GetSupporterAttrib( "remover" , "State")) then
                  if(player:GetSupporterAttrib("remover" , "Resource" )) then
                  if(RemovableItem[name]) then  --Give back 80% resources
                  local amount = RemovableItem[name].giveAmount * .80
                  amount = math.floor(amount)
                  local resource = RemovableItem[name].give
                  rust.RunServerCommand("inv.giveplayer \"".. util.QuoteSafe( netUser.displayName) .."\" \"".. util.QuoteSafe(resource) .."\" ".. amount)
                  rust.InventoryNotice( netUser, tostring( amount ) .. " x " .. resource )         
                end
              end                          RemoveObject(takedamage.gameObject) --Remove object from game
                
                    if(not player:GetSupporterAttrib("remover" , "On")) then
                      player:SetSupporterAttrib( "remover" , "State" , false )
                      rust.Notice( netUser , "Remover Deactivated" )
                    end    
               return damage
            end  
            end
                 return damage
              
      
          end
    --Would Modify damage before returning it based on skills

    
  end
  return damage
  --Alls thats left here is damage from animals and decay
 end

     
 
 if(structureComponent) then  --A structure takes damage
   local structureOwner = structureComponent._master
   local structureOwnerID = getStructureMasterOwnerId(structureOwner)
      if(PlayerUtil:GetfromDecayList(tonumber(structureOwnerID))) then
       --Block Damage
       local dmg = damage.amount
       damage.amount = 0
       return damage
     end
   return damage
 end
 

 if(deployableObject) then --A deployable takes damage
   local deployableOwnerID = getDeployableObjectId(deployableObject)
   
   local test = damage.amount
   local name = takedamage.gameObject.Name   


   
   return damage
   end
 
   local test = damage.amount
   local name = takedamage.gameObject.Name

   return damage
 end


function RemoveObject(object)
    local arr = util.ArrayFromTable(cs.gettype("System.Object"), {object})
    cs.convertandsetonarray( arr, 0, object , UnityEngine.GameObject._type )
    NetCullRemove:Invoke(nil, arr) 
    return
end

function PLUGIN:GetStructureOwnerID(structure)
    return GetStructureMasterOwnerIDField(structure)
end
 
 local AllStructures = util.GetStaticPropertyGetter( Rust.StructureMaster, "AllStructures")
 local StructureType = cs.gettype( "StructureComponent, Assembly-CSharp" )

function PLUGIN:AntiDecay(netUser)
    -- Get the array that holds all StructureMaster objects in the world.
    -- Loop all the strucutres
    for i=0, AllStructures().Count-1
    do
      -- Print the ID attached to this structure
        local table = self:GetConnectedComponents( AllStructures()[i])
        local structureOwnerID = self:GetStructureOwnerID(AllStructures()[i]) 
        local list = PlayerUtil:GetDecayList()
           for key , value in pairs(list) do
             if(tonumber(structureOwnerID) == tonumber(key) ) then  --If supportor owns this master structure then 
                for key , value in pairs(table) do                
                      if(value) then
                          local takedamage = value:GetComponent("TakeDamage")
                          local health = takedamage.health
                          takedamage.health = 1500  --Sets all health to 1500 Later Add specific health per structure Item?    
                      end
                end
              end
            

        end
        
        
    end

end
-- Get the ID for this structure
function PLUGIN:GetStructureOwnerID(structure)
    return getStructureMasterOwnerId(structure)
end

local GetComponents, SetComponents = typesystem.GetField( Rust.StructureMaster, "_structureComponents", bf.private_instance )
 function PLUGIN:GetConnectedComponents( master )
    local hashset = GetComponents( master )
    local tbl = {}
    local it = hashset:GetEnumerator()
    while (it:MoveNext()) do
        tbl[ #tbl + 1 ] = it.Current
    end
    return tbl
end

function PLUGIN:GetPlayer( damage )
   
   if(damage.attacker) then
      local attackClient = damage.attacker.client
      if(attackClient) then
         local attackerNetUser = attackClient.netUser
         if(attackClient.netUser) then
         local userID = rust.GetUserID(attackerNetUser)
         --Add in if userID is not determined then modify damage to 0
         local player = PlayerUtil:GetPlayer(userID)
         return player , attackerNetUser
         else return false end
      end
    end
end

function PLUGIN:GetWeapon( damage)
  if(damage.extraData) then
         local weapon = damage.extraData.dataBlock.Name  --Gives the name of the weapon being used   
         return weapon
        else return false end
      end
      
 function PLUGIN:GetAttackerPosition(damage)
        local attackerPosition = damage.attacker.networkView.gameObject:GetComponent("Transform").Position
        return attackerPosition
 end
 
