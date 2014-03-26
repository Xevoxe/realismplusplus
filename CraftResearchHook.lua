PLUGIN.Title = "Crafting Hook"
PLUGIN.Description = " This is the OnCraft and On Research Hooks."
PLUGIN.Version = "1.0"
PLUGIN.Author = "Xevoxe"

local Player = {}

function PLUGIN:Init()
  
  print("Loading Crafting and Research Hooks Version 1.0")
 if( not api.Exists( "PlayerUtil" )) then print("Crafting needs PlayerUtil")
  end
  Player = plugins.Find("PlayerUtil")
end

function PLUGIN:OnStartCrafting(inv , blueprint, amount, starttime)
    local itemToBeCrafted = blueprint.resultItem.name
    local netuser = rust.NetUserFromNetPlayer( inv.networkViewOwner )
    local inventory = rust.GetInventory(netuser)
    
    if( netuser == nil ) then
      print( "netuser not found - CraftMod" )
      print(tostring(inv))
      return 
    end
    local userID = rust.GetUserID(netuser)
    local player = Player:GetPlayer( userID )
    
    --Check to see if the item requires a blueprint
    print(player.Name)
    print(tostring(player.Crafting))
    if( player.Crafting:CheckBlueprint(itemToBeCrafted)) then
       --Try to Find the blueprint in player's inventory
       local bp = player.Crafting:GetBlueprint(itemToBeCrafted)
       item = inventory:FindItem(bp)
       if( item ~= nil ) then
       --Craft Item
       if(not player.Crafting:CraftBlueprint(itemToBeCrafted) ) then  --If false then failure
         --Crafting Failed Check for destruction of blueprint
         return true
       else
       --Crafting Successful check for destruction of blueprint
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

