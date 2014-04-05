PLUGIN.Title = "Research Hook"
PLUGIN.Description = " This is the OnResearch Hook."
PLUGIN.Version = "1.0"
PLUGIN.Author = "Xevoxe"

local cost = { true }

function PLUGIN:Init()
  print("Loading ResearchHook")
  cost["M4"] = 5
  
  self:AddChatCommand("blueprint", self.cmdBlueprint )
  
end


function PLUGIN:OnResearchItem( researchtoolitem, item )
  print("Test")
  if( item.datablock.name ~= "Research Kit 1" ) then
    local playerinv = researchtoolitem.inventory
		if (playerinv and item.inventory == playerinv) then
			local netuser = rust.NetUserFromNetPlayer( playerinv.networkViewOwner )
			if (netuser) then
				rust.Notice( netuser, "You can only research Research Kits with this.")
			end
		end
		--print( "BLOCKED" )
		return MergeResult.Failed
  end
end

function PLUGIN:cmdBlueprint( netuser , cmd, args)
  
  
  local inventory = rust.GetInventory(netuser)
  
  if(args[1]) then
    args[1] = string.lower(args[1])
  end
  
  --Check for research kit
  if(args[1] == "create") then
    if(args[2]) then
     if(cost[args[2]]) then
          local item = inventory:FindItem( "Research Kit 1" )
          if(item) then
           local paper = inventory:FindItem( "Paper" )
            if(paper) then
              if(paper.uses >= cost[args[2]]) then
                  paper:SetUses(paper.uses - cost[args[2]])
                if( paper.uses == 0 ) then --Remover Item
                  inventory:RemoveItem(paper) 
                end   
                  inventory:RemoveItem(item)
                  rust.RunServerCommand("inv.giveplayer \"".. util.QuoteSafe( netuser.displayName) .."\" \"".. util.QuoteSafe(args[2]) .."\" ".."1")
                  rust.InventoryNotice( netuser, args[2].."X 1" )
            else
                rust.SendChatToUser( netuser , "You do not have enough paper or its not in a big enough stack.")
                end
          else
            rust.Notice( netuser, "You must have paper.")
            end
         else
           rust.Notice( netuser, "You must have a research kit.")
         end
      else
        rust.Notice( netuser, "That is not a valid blueprint.")
      end
    else
      rust.Notice( netuser, "You must supply a item name.")
    end
  end
  
  
end
