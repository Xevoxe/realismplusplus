PLUGIN.Title = "Research Hook"
PLUGIN.Description = " This is the OnResearch Hook."
PLUGIN.Version = "1.0"
PLUGIN.Author = "Xevoxe"

local cost = { true }

function PLUGIN:Init()
  print("Loading ResearchHook")
  cost["Workbench Blueprint"] = 3           
  cost["Repair Bench Blueprint"] = 3          
  cost["Gunpowder Blueprint"] = 10       		 
  cost["Large Wood Storage Blueprint"] = 3    
  cost["Small Medkit Blueprint"] = 5   		
  cost["Large Medkit Blueprint"] = 10     		
  cost["9mm Ammo Blueprint"] = 3      		
  cost["556 Ammo Blueprint"] = 20              
  cost["Shotgun Shells Blueprint"] = 10        
  cost["Revolver Blueprint"] = 3              
  cost["M4 Blueprint"] = 30       				
  cost["MP5A4 Blueprint"] = 20           		
  cost["Shotgun Blueprint"] = 20          		
  cost["Bolt Action Rifle Blueprint"] = 20   	
  cost["P250 Blueprint"] = 10     				
  cost["9mm Pistol Blueprint"] = 3            
  cost["Leather Helmet BP"] = 5      			
  cost["Leather Vest BP"] = 10            		
  cost["Leather Pants BP"] = 5           		
  cost["Leather Boots BP"] = 5 				
  cost["Kevlar Helmet BP"] = 10               
  cost["Kevlar Vest BP"] = 30         			
  cost["Kevlar Pants BP"] = 10       			
  cost["Kevlar Boots BP"] = 10           		
  cost["Rad Suit Helmet BP"] = 3          	
  cost["Rad Suit Vest BP"] = 10   				
  cost["Rad Suit Pants BP"] = 3     			
  cost["Rad Suit Boots BP"] = 3            	
  cost["Metal Foundation BP"] = 20   			
  cost["Metal Pillar BP"] = 20  				
  cost["Metal Window BP"] = 20  				
  cost["Metal Ceiling BP"] = 20  				
  cost["Metal Ramp BP"] = 20  					
  cost["Metal Stairs BP"] = 20  				
  cost["Metal Wall BP"] = 20  					
  cost["Metal Doorway BP"] = 20  				
  cost["Holo Sight BP"] = 5  					
  cost["Laser Sight BP"] = 5  				
  cost["Silencer BP"] = 5  					
  cost["Flashlight Mod BP"] = 5 
  cost["Explosives Blueprint"] = 20
  cost["Explosive Charge Blueprint"] = 50
  cost["F1 Grenade Blueprint"] = 10
  
  self:AddChatCommand("blueprint", self.cmdBlueprint )
  
end


function PLUGIN:OnResearchItem( researchtoolitem, item )
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
  
  --**********************************************************
  --/skills List Learned Blueprints and Skills
  --**********************************************************
  if(args[1] == "skills") then
    local PlayerUtil = plugins.Find("PlayerUtil")
    local player = PlayerUtil:GetPlayer(rust.GetUserID(netuser))
    local list = player.BluePrints
    if(list ~= nil) then
    for key , value in pairs(list) do
      rust.SendChatToUser( netuser , "Blueprints Skill Level")
      rust.SendChatToUser( netuser , key.." [  "..value.."  ]")
    end
  else
    rust.SendChatToUser(netuser , "You have not learned any blueprints.")
  end
  
   return
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
