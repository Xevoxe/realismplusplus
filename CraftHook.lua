PLUGIN.Title = "Crafting Hook"
PLUGIN.Description = " This is the OnCraft and On Research Hooks."
PLUGIN.Version = "1.0"
PLUGIN.Author = "Xevoxe"

local Player = {}

function PLUGIN:Init()
  
  print("Loading Crafting Hooks Version 1.0")
 if( not api.Exists( "PlayerUtil" )) then print("Crafting needs PlayerUtil")
  end
  Player = plugins.Find("PlayerUtil")
  
   local b , res = config.Read("blueprintData")
  self.Config = res or {}
  if( not b ) then 
    self:LoadDefaultConfig()
  if ( res ) then config.Save("blueprintData") end
  blueprints = self.Config
 end
end
  
function PLUGIN:LoadDefaultConfig()
  local blueprint = {}
  blueprint.Name = "Large Wood Storage Blueprint"
  blueprint.Blueprint = "Large Wood Storage Blueprint"
  blueprint.Difficulty = 5
  self.Config[blueprint.Name] = blueprint
  config.Save("blueprintData")
end

function PLUGIN:OnBlueprintUse(blueprint , item)
print(blueprint.name)
if(self.Config[blueprint.name]) then --Only do this if using blueprints in the list
  local inventory = item.inventory
  if(inventory) then
    local netuser = rust.NetUserFromNetPlayer( inventory.networkViewOwner )
        if(netuser) then
         local userID = rust.GetUserID(netuser)
              if(userID) then  
                    local player = Player:GetPlayer(userID)
                    print(player.Name)
                    if(player) then
                    if(player:LearnBlueprint(blueprint.name)) then
                    rust.SendChatToUser( netuser, "You can now use "..blueprint.name.."s." )
                    end
                    else
                    print("Player not present")
                    end
              else
              print("UserID not present")
              end
        else
        print("Netuser not present")
        end
  else 
  print("Inventory not present")
  end
end
end




function PLUGIN:OnStartCrafting(inv , blueprint, amount, starttime)
    
    local itemToBeCrafted = blueprint.resultItem.name
    local netuser = rust.NetUserFromNetPlayer( inv.networkViewOwner )
    local inventory = rust.GetInventory(netuser)
    print("Inside Crafting")
    if( netuser == nil ) then
      print( "netuser not found - CraftMod" )
      print(tostring(inv))
      return 
    end
   
    local userID = rust.GetUserID(netuser)
    local player = Player:GetPlayer( userID )
    print(blueprint.name)
    if(self.Config[blueprint.name] ~= nil) then
       --Try to Find the blueprint in player's inventory
       item = inventory:FindItem(blueprint.name)
       
       if( item ~= nil ) then
       --Craft Item
        local check = self:CraftBlueprint(blueprint.name , player , netuser )
        local destroy = nil
        for x = 1 , amount , 1 do
        destroy = self:BlueprintDestroy(self.Config[blueprint.name].Difficulty , player.BluePrints[blueprint.name])
        if(destroy) then
          break
        end        
        end
        print(destroy)
        if(destroy) then --Destroy Blueprint
          rust.Notice(netuser , "Your blueprint becomes unreadable!")
          inv:RemoveItem(item)
        end
               
       if(not check) then
           return true
         end
 
       else
          rust.Notice( netuser, itemToBeCrafted.." Blueprint not found on person." )
          return true
       end
       
    else
       --Place Non blueprinted items crafting stuff here.
       --Nothing happens item is crafted.
    end
 
end

function PLUGIN:CraftBlueprint(blueprint , player , netuser)
  --Get Random Number 0 - 25
  local num = math.random(0 , 25)
  if( player.BluePrints[blueprint] - self.Config[blueprint].Difficulty > num  ) then --Player is successful
       
    if(self:LevelBlueprint(player.BluePrints[blueprint], self.Config[blueprint].Difficulty , true )) then --Player Levels up
      rust.SendChatToUser( netuser , "You manage to learn something new from crafting this item.")
      player.BluePrints[blueprint] = player.BluePrints[blueprint] + 1
      rust.SendChatToUser( netuser , blueprint.."["..player.BluePrints[blueprint].."]")
    end
    return true
  else
    --Player fails to craft
    rust.Notice( netuser, "Your attempt to craft ["..blueprint.."] fails!")
      if(self:LevelBlueprint(player.BluePrints[blueprint], self.Config[blueprint].Difficulty, false )) then
        rust.SendChatToUser( netuser, "You gain a better understanding of crafting this item.")
        player.BluePrints[blueprint] = player.BluePrints[blueprint] + 1
        rust.SendChatToUser( netuser , blueprint.."["..player.BluePrints[blueprint].."]") 
        return false
      else
      rust.SendChatToUser( netuser, "You are unable to learn anything new from your try.")
      return false
      end
  end
end

function PLUGIN:LevelBlueprint(level , difficulty , failed )
  
  if(failed) then
    local num = math.random( 0 , 100)
     if(num >= 90) then -- Always 10% chance to learn something
     return true
   end
 else
   --Failed to craft
   local num = math.random( 0 , 25 )
   if( level < num ) then
     return true
     end
  end
  
  return false --Fails to level   
end

function PLUGIN:BlueprintDestroy(difficulty , level )
  
  local chance = difficulty * 10
  local levelMod = math.ceil(level * 3.8)
  local num = math.random( 0 , chance )
  local autoDestroy = math.random( 0 , 100 )
  print(num)
  if(num > levelMod) then 
    print("Blueprint Destroyed")
  end
  
  if( num > levelMod or autoDestroy < math.ceil((chance * .10))) then
    return true
  end
  return false
end

  
