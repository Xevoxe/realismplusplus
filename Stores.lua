PLUGIN.Title = "Stores"

local STARTUP = nil       --Start Up cost for a store
local TIERUPGRADE = nil
local UPKEEP = nil
PLUGIN.Description = "Handles the store code"
PLUGIN.Version = "3.0"
PLUGIN.Author = "Xevoxe"

 local itemTable = {       			-- This table holds all the items that can be bought or sold in stores
  "Low Grade Fuel",             	--1
  "Workbench",           			--2
  "Stone Hatchet",         			--3
  "Furnace",  						--4
  "Low Quality Metal",    			--5
  "Spike Wall",           			--6
  "Large Spike Wall",     			--7
  "Wood Gate",            			--8
  "Wood Gateway",          			--9
  "Metal Door",						--10
  "Bed",                 			--11
  "Repair Bench",         			--12
  "Gunpowder",      				--13
  "Wood Planks",           			--14
  "Paper",         					--15
  "Small Medkit",  					--16
  "Large Medkit",    				--17
  "Blood",           				--18
  "9mm Ammo",     					--19
  "556 Ammo",            			--20
  "Shotgun Shells",          		--21
  "Handmade Shell",					--22
  "Revolver",                 		--23
  "Hatchet",         				--24
  "M4",      						--25
  "MP5A4",           				--26
  "Shotgun",         				--27
  "Bolt Action Rifle",  			--28
  "P250",    						--29
  "9mm Pistol",           			--30
  "Leather Helmet",     			--31
  "Leather Vest",            		--32
  "Leather Pants",          		--33
  "Leather Boots",					--34
  "Kevlar Helmet",              	--35
  "Kevlar Vest",        			--36
  "Kevlar Pants",      				--37
  "Kevlar Boots",           		--38
  "Rad Suit Helmet",         		--39
  "Rad Suit Vest",  				--40
  "Rad Suit Pants",    				--41
  "Rad Suit Boots",           		--42
  "Handmade Lockpick",     			--43
  "Research Kit 1",            		--44
  "Flare",          				--45
  "Large Wood Storage",  			--46
  "Wood",      						--47
  "Metal Foundation",  				--48
  "Metal Pillar", 					--49
  "Metal Window", 					--50
  "Metal Ceiling", 					--51
  "Metal Ramp", 					--52
  "Metal Stairs", 					--53
  "Metal Wall", 					--54
  "Metal Doorway", 					--55
  "Holo Sight", 					--56
  "Laser Sight", 					--57
  "Silencer", 						--58
  "Flashlight Mod", 				--59
  "Explosives",                     --60
  "Explosive Charge",               --61
  "F1 Grenade",                     --62
  "Anti-Radiation Pills",           --63
  "Workbench Blueprint",            --100 
  "Repair Bench Blueprint",         --101 
  "Gunpowder Blueprint",      		--102 
  "Large Wood Storage Blueprint",   --103
  "Small Medkit Blueprint",  		--104
  "Large Medkit Blueprint",    		--105
  "9mm Ammo Blueprint",     		--106
  "556 Ammo Blueprint",             --107
  "Shotgun Shells Blueprint",       --108
  "Revolver Blueprint",             --109
  "M4 Blueprint",      				--110
  "MP5A4 Blueprint",           		--111
  "Shotgun Blueprint",         		--112
  "Bolt Action Rifle Blueprint",  	--113
  "P250 Blueprint",    				--114
  "9mm Pistol Blueprint",           --115
  "Leather Helmet BP",     			--116
  "Leather Vest BP",           		--117
  "Leather Pants BP",          		--118
  "Leather Boots BP",				--119
  "Kevlar Helmet BP",               --120
  "Kevlar Vest BP",        			--121
  "Kevlar Pants BP",      			--122
  "Kevlar Boots BP",           		--123
  "Rad Suit Helmet BP",         	--124
  "Rad Suit Vest BP",  				--125
  "Rad Suit Pants BP",    			--126
  "Rad Suit Boots BP",           	--127
  "Metal Foundation BP",  			--128
  "Metal Pillar BP", 				--129
  "Metal Window BP", 				--130
  "Metal Ceiling BP", 				--131
  "Metal Ramp BP", 					--132
  "Metal Stairs BP", 				--133
  "Metal Wall BP", 					--134
  "Metal Doorway BP", 				--135
  "Holo Sight BP", 					--136
  "Laser Sight BP", 				--137
  "Silencer BP", 					--138
  "Flashlight Mod BP", 				--139
  "Explosives Blueprint",           --140
  "Explosive Charge Blueprint",     --141
  "F1 Grenade Blueprint"            --142
  }
 
local storeList = {} --List of Stores
function PLUGIN:Init()
  STARTUP = 500
  TIERUPGRADE = 500
  UPKEEP = .10
  print("Stores Loading")
  
  PlayerUtil = plugins.Find("PlayerUtil")
  
  if( not api.Exists( "StoreMeta" )) then print("Stores needs StoreMeta")
        end
        Store = plugins.Find("StoreMeta")
  
   local b , res = config.Read("storeData")
   self.Config = res or {}
   if( not b ) then 
   self:LoadDefaultConfig()  --Server Store
   if ( res ) then config.Save("storeData") end  --Contains all player made stores   
 end
    self:LoadStores()
    self:AddChatCommand( "store" , self.cmdStore )
    self:AddChatCommand( "buy" , self.cmdBuy )
    self:AddChatCommand( "edit" , self.cmdSet )
    
    self:StoreUpkeep() --On startup with take out the store upkeep of a store since last startup
    
end


--***********************************************
--Calculates all the stores upkeeps and removes bankrupt stores
--***********************************************
function PLUGIN:StoreUpkeep()
  local PlayerUtil = plugins.Find("PlayerUtil")
  local time = util.GetTime()
  --First do upkeep for all stores
  local fees = 0
  for i = 1 , #self.Config , 1 do 
    local passedTime = time - self.Config[i].Last
    local cost = ((math.ceil(passedTime/60))*  UPKEEP)
    local userID = self.Config[i].Owner
    local player = PlayerUtil:GetPlayer(userID)
    self.Config[i].Last = time
    if(player) then
        if(player.Vault > 0 ) then --First Pull from player vault
          cost = cost - player.Vault
          if(cost < 0 ) then 
            player.Vault = math.abs(cost) 
          else
          player.Vault = 0
          self.Config[i].Vault = self.Config[i].Vault - cost
        end
    else
    end
      end
    fees = fees + cost
  end
  
  local counter = 0 
  --Remove bankrupt stores
  for i = 1 , #self.Config , 1 do
    if(self.Config[i].Vault < 0 ) then --Remove the store
      table.remove(self.Config , i )
      counter = counter + 1
    end
    
  end
  
  print("Total Store Fees Collected:  "..fees)
  print("Bankrupted stores:  "..counter)
  
 -- config.Save("storeData")
end






function PLUGIN:cmdSet( netuser, cmd , args )
    local userID = rust.GetUserID(netuser)
    local player = PlayerUtil:GetPlayer(userID)
    local store = self.Config[player.VisitStore]

if(store.Owner == userID) then --Only allow the store owner to edit this store

if(args[1] ~= nil ) then
  args[1] = string.lower(args[1])
  
 
 --********************************************
 --/supporter Upgrades store to supporter teir
 --********************************************
 if(args[1] == "supporter" ) then
   if(netuser:CanAdmin()) then
     if(store.Tier < 4 ) then
       store.Tier = store.Tier + 1
       config.Save("storeData")
   else
     rust.SendChatToUser( netuser , "This store is already a supporter store.")
     end
   else
     rust.SendChatToUser( netuser , "You must be an admin to use this command.")
   end  
 return
end

 
--********************************************
--/upgrade Upgrades a personal store
--********************************************
if(args[1] == "upgrade") then
   local inv = netuser.playerClient.rootControllable.idMain:GetComponent( "Inventory" )
  if(store.Tier < 3) then --Store can be upgraded
  local currency = self:GetWallet(inv ,"Sulfur")
  local cost = (store.Tier + 1) * TIERUPGRADE
  local change = currency - cost
      if(change >= 0 ) then --Had enough money
        store.Tier = store.Tier + 1
        self:GiveChange ( change , inv , "Sulfur")
        config.Save("storeData")
        rust.SendChatToUser( netuser , "Your store has been upgraded to tier "..store.Tier)
      else
      rust.SendChatToUser ( netuser , "You do not have enough to upgrade your store.")
      rust.SendChatToUser ( netuser , "You must have "..cost.." sulfur to upgrade to tier "..(store.Tier + 1))
      self:GiveChange( currency , inv , "Sulfur" )
    end
  end
  return 
end

--********************************************
--/name Sets the name of the store
--********************************************
if(args[1] == "name") then
  if(args[2] ~= nil) then
    if(not store:SetName(args[2])) then
      rust.SendChatToUser( netuser , "Your store name is too long.")
    end
    rust.SendChatToUser( netuser , "Store name changed to: "..args[2])
    config.Save("storeData")
else
  rust.SendChatToUser( netuser , "Syntax: /name \"Chuck's Mule Barn!\"")
  end
return
end
--********************************************
--/desc Sets Personal Store Description
--********************************************
if(args[1] == "desc") then
  if(args[2] ~= nil) then
    if(not store:SetDesc(args[2])) then
      rust.SendChatToUser( netuser , "Your description is too long.")
      config.Save("storeData")
    end
    rust.SendChatToUser( netuser , "You have succesfully changed your store description.")
else
  rust.SendChatTouser( netuser , "Syntax: /edit desc \"My Awesome Store!\"")
  end
return
end
--********************************************
--/add [item] [amount] [price] Adds an Item to the store
--********************************************
if(args[1] == "add") then
    local inv = netuser.playerClient.rootControllable.idMain:GetComponent( "Inventory" ) 
  if(args[2] ~= nil ) then
    args[2] = tonumber(args[2])
    if(args[2]) then
      if(itemTable[args[2]]) then --Item exist in itemTable
        args[3] = tonumber(args[3])
        if(args[3]) then 
         args[4] = tonumber(args[4])
          if(args[4]) then            
            --Get Item in question
            local itemToAdd = self:GetWallet(inv , itemTable[args[2]] )
            if(itemToAdd ~= nil) then
              
              if(args[3] > itemToAdd) then --Check to see if the player has enough
                args[3] = itemToAdd
              else
                self:GiveChange((itemToAdd - args[3]) , inv , itemTable[args[2]])
              end

            local item = {}
            item.Amount = args[3]
            item.Name = itemTable[args[2]]
            item.Price = args[4]
            local change = store:AddItem(item)
            if(change ~= nil) then
             if( change == args[3] ) then
               rust.SendChatToUser ( netuser , "Store is full unable to add item.")
           else
             
            rust.SendChatToUser( netuser , "Added: "..item.Name.." Amount = "..(args[3]-change).." Price = "..item.Price.." to your store.")
            rust.SendChatToUser( netuser , "Sales Tax Applied 8% Store Vault Balance "..store.Vault)
            if(store.Vault < 0 ) then
              rust.Notice( netuser , "Warning! Your store vault is negative.")
            end
            end
            self:GiveChange( change , inv , itemTable[args[2]])
            config.Save("storeData")
          else
            rust.SendChatToUser( netuser , "Store has reached Max Capacity." )
          end
          
          else
          rust.SendChatToUser( netuser , "You do not have that item on you.")
          end       
        else
          rust.SendChatToUser( netuser , "You must supply a numeric price.")
          end
      else
        rust.SendChatToUser( netuser , "You must supply a numeric amount." )
        end
    else
      rust.SendChatToUser( netuser , "Must supply a number from the Item List.")
      end
  else
    rust.SendChatToUser( netuser , "Item Number must be a number." )
    end
  
  else
  
  rust.SendChatToUser( netuser , "Visit www.evolved-gaming.com to get a list of available items.")
  rust.SendChatToUser( netuser , "Syntax: /edit add [itemnum] [amount] [price]")
  rust.SendChatToUser( netuser , "ItemNum must come from the above list.")
  end
return
end

--********************************************
--/remove [itemnum] [amount] Removes items from store.
--********************************************
if(args[1] == "remove") then 
  args[2] = tonumber(args[2])
  if(args[2]) then
    args[3] = tonumber(args[3])
    if(args[3]) then
      --Remove Items
      local item = store:GetItemName(args[2])
      local excess = store:RemoveItem( args[2] , args[3] )
      if( excess ~= nil) then
        if(excess > 0 ) then
      else
        local inv = netuser.playerClient.rootControllable.idMain:GetComponent( "Inventory" ) 
        self:GiveChange(args[3] , inv , item )
        rust.InventoryNotice( netuser , tostring(args[3]).." x "..item )
        config.Save("storeData")
        end
    else
      rust.SendChatToUser( netuser, "That item was not found in the store.")
      end
      
  else
    rust.SendChatToUser( netuser , "/Syntax : /edit remove [itemnum] [amount]")
    rust.SendChatToUser( netuser , "Amount must be a numeric value.")
    end
else
  rust.SendChatToUser( netuser , "/Syntax : /edit remove [itemnum] [amount]")
  rust.SendChatToUser( netuser , "ItemNum must be a numeric value.")
  end
else
rust.SendChatToUser( netuser , "Syntax : /edit remove [itemnum] [amount] " )
rust.SendChatToUser( netuser , "Removing more then in store will remove the item.")
end

--[[
--********************************************
--/setprice [itemnum] Changes the price of the item.
--********************************************
if(args[1] == "setprice" ) then
  if(args[2] ~= nil ) then
    if(tonumber(args[2])) then --Item is a number
      if(args[3] ~= nil ) then 
        if(tonumber(args[3])) then
          store:SetPrice(tonumber(args[2]) , tonumber(args[3]) )
          rust.SendChatToUser( netuser , "Priced changed.")
      else
        rust.SendChatToUser( netuser , "Price must be a number.")
        end
        
      else
        rust.SendChatToUser( netuser , "Must supply a new price.")
      end
    else
    rust.SendChatToUser( netuser , "Itemnum must be a number.")
    end
else
  rust.SendChatToUser(netuser , "Syntax: /edit setprice [itemnum] [price]")
  end
return 
end
]]
else
  rust.SendChatToUser( netuser , "Syntax: /edit [command]" )
  rust.SendChatToUser( netuser , "Commands: desc , name , add , remove , setprice , upgrade")
end
else
rust.SendChatToUser ( netuser, "You do not own this store.")
end

end

--********************************************
--/Store Commands dealing with stores
--********************************************
function PLUGIN:cmdStore( netuser, cmd, args )
  local userID = rust.GetUserID(netuser)
  local player = PlayerUtil:GetPlayer(userID)
  local inv = netuser.playerClient.rootControllable.idMain:GetComponent( "Inventory" )
  
  
if( args[1] ~= nil ) then
args[1] = string.lower(args[1])  

--********************************************
--/balance  List Vault Balance
--********************************************
if(args[1] == "balance" ) then --Person is checking store vault
  local store = self.Config[player.VisitStore]
  if(store.Owner == userID) then --Person owns store
    local time = util.GetTime()
    local timepassed = time - store.Last
    rust.SendChatToUser ( netuser , "Vault Balance : "..store.Vault)
    rust.SendChatToUser ( netuser , "Vault in Excess: "..player.Vault)
    rust.SendChatToUser ( netuser , "Vault Minus Upkeep : "..math.ceil(store.Vault - (timepassed/60 * UPKEEP)))
else
  rust.SendChatToUser( netuser , "You do not own this store.")
  end
 
 return 
end



--********************************************
--/withdraw [amount] Takes sulfur out of vault
--********************************************
if(args[1] == "withdraw" ) then --Peron is withdrawing sulfur from store
 local store = self.Config[player.VisitStore]
 if(tonumber(args[2]) ~= nil ) then -- Amount is attached
   args[2] = tonumber(args[2])
    if(store.Owner == userID) then -- Person owns this store
      if(store.Vault >= args[2] ) then --Enough Sulfur in store to withdraw
        store.Vault = store.Vault - args[2]
        self:GiveChange(args[2] , inv , "Sulfur" )
        rust.SendChatToUser( netuser , "You have withdrawn "..args[2])
        rust.SendChatToUser( netuser , "Your store vault now contains "..store.Vault)
        config.Save("storeData")
    else
      rust.SendChatToUser(netuser , "Your store vault only contains "..store.Vault)
      end
    
    end
  else
    rust.SendChatToUser(netuser , "Syntax: /store withdraw [amount]")
    rust.SendChatToUser(netuser , "Must supply a numberic number for amount.")
  end
return
end


--********************************************
--/deposit Deposits sulfur into vault
--********************************************
if(args[1] == "deposit" ) then --Peron is depositing sulfur from store
 local store = self.Config[player.VisitStore]
 if(tonumber(args[2]) ~= nil ) then -- Amount is attached
   args[2] = tonumber(args[2])
    if(store.Owner == userID) then -- Person owns this store
      local currency = self:GetWallet(inv , "Sulfur" )
      if(currency >= args[2] ) then --Has Enough Sulfur to deposit
        --Check to see if amount with fill up their vault
        if(store:CheckVault(args[2])) then
        self:GiveChange((currency - args[2]) , inv , "Sulfur" )
        store.Vault = store.Vault + args[2]
        rust.SendChatToUser( netuser , "Your store now has "..store.Vault)
        config.Save("storeData")
      else
        rust.SendChatToUser( netuser , "Your vault cannot hold that much.")
        self:GiveChange(args[2] , inv , "Sulfur")
        end
    else
      rust.SendChatToUser( netuser , "You only have "..currency.." sulfur on your person.")
      end
      
    
    end
  else
    rust.SendChatToUser(netuser , "Syntax: /store deposit [amount]")
    rust.SendChatToUser(netuser , "Must supply a numberic number for amount.")
  end
return
end






--********************************************
--/buy Buys a personal store
--********************************************
if(args[1] == "buy" ) then --Person is attempting to buy store
 
 if(player.Stores == 0 ) then --Player owns no stores currently only set to one
 
 local currency = self:GetWallet(inv ,"Sulfur")
 if(currency) then
 if(currency >= STARTUP ) then --Player is able to open a new store.
   self:GiveChange( (currency - STARTUP ) , inv  , "Sulfur" )
   local setupStore = {}
   local store = Store:CreateStore(setupStore)
   store.Owner = userID
   store:SetName(netuser.displayName)
   self.Config[#self.Config + 1 ] = store
   self.Config[#self.Config].Vault = STARTUP
   rust.SendChatToUser( netuser , "You have started a new business.")
   rust.SendChatToUser( netuser , "Enter your store and type /set to get a list of customization options")
   player.Stores = player.Stores + 1
   config.Save("storeData")
 else
   rust.SendChatToUser(netuser , "Sorry you cannot afford to open a new store.")
   self:GiveChange( currency , inv , "Sulfur" )
 return
end
else
rust.SendChatToUser( netuser , "You cannot afford to open a new store." )
end
else
rust.SendChatToUser( netuser , "You already own a store.")
end
end

--********************************************
--/list Lists all the available stores
--********************************************
    if(args[1] == "list") then
      if(args[2] ~= nil) then --List pages in case alot of stores
        if(tonumber(args[2])) then 
          --Output args[2] Page of stores
          --Check if page exists
          if(math.ceil(#self.Config / 10 ) < args[2]) then --Page Exists
            for i = 1+(10*args[2]-10) , 10*args[2] , 1 do
                if(self.Config ~= nil) then
                  rust.SendChatToUser ( netuser , "["..i.."]".." "..self.Config[i].Name..": "..self.Config[i].Desc )
                else
                  break --No More Stores to list
                end
            end
              rust.SendChatToUser ( netuser , "Page: "..args[2].." of "..math.ceil(#self.Config / 10))
              rust.SendChatToUser ( netuser , "/store list [pagenum] -To see more stores if available.")
        else
          rust.SendChatToUser ( netuser, "That page does not exist.")
          end
        end
      else
      --Output first page of stores
      for i = 1 , 10 , 1 do
        if(self.Config[i] ~= nil) then
          rust.SendChatToUser ( netuser , "[  "..i.."  ]".." "..self.Config[i].Name..":      \""..self.Config[i].Desc.."\"" )
        else
          break --No More Stores to list
        end
      end
        rust.SendChatToUser ( netuser , "Page: 1 of "..math.ceil(#self.Config / 10))
        rust.SendChatToUser ( netuser , "/store list [pagenum] -To see more stores if available.")
    end  
      
    return
  end
--********************************************
--/set Sets a active store
--********************************************
    if(args[1] == "set" ) then
      if(args[2] ~= nil) then
        if(tonumber(args[2])) then --Is a number
          if(self.Config[tonumber(args[2])] ~= nil) then --Store Exists
            rust.SendChatToUser( netuser , "You are now shopping at "..self.Config[tonumber(args[2])].Name)
            player.VisitStore = tonumber(args[2])
          else
            rust.SendChatToUser( netuser , "That number is not associated with a store.")
          end
        else
        rust.SendChatToUser( netuser , "Syntax:/store set [storenum]")
        rust.SendChatToUser( netuser , "Second argument must be a number.")
        end
      else
        rust.SendChatToUser( netuser , "Syntax: /store set [storenum]")
        rust.SendChatToUser( netuser , "Set active store by picking a store number.")
      end
    return
    end
  
else
rust.SendChatToUser( netuser , "Syntax /Store [command]")
rust.SendChatToUser( netuser , "General Commands: list , set , buy")
rust.SendChatToUser( netuser , "Store Customization Commands: desc")
end
end

--********************************************
--/buy [itemnum] [amount] Will buy specific item from current selected store.
--********************************************
function PLUGIN:cmdBuy( netuser , cmd , args)
  local userID = rust.GetUserID(netuser)
  local player = PlayerUtil:GetPlayer(userID)
  local store = self.Config[player.VisitStore]
  if(args[1] ~= nil) then --Item has been chosen
    args[1] = tonumber(args[1])
    if(args[1]) then --Item is a number
     if(tonumber(args[2])) then
       --Buy Item
       local cost = store:Price(args[1])
       if(cost) then --Item Exists
         self:BuyItem(args[1], cost , tonumber(args[2]) , netuser , store )
       else
         rust.SendChatToUser ( netuser , "That item cannot be found in this store.")
       end
       
     else
     rust.SendChatToUser( netuser , "Must enter in a amount that is a valid number." )
     end
     
    else
      rust.SendChatToUser( netuser , "ItemNum must be a number.")
    end
  else
    --List Items for sell here 
    store:ForSale(netuser)
    rust.SendChatToUser( netuser , "Syntax: /buy [itemnum] [amount]")
    rust.SendChatToUser( netuser , "ItemNum cooresponds to the item number in store.")
  end
  return
end

--********************************************
--Buy Item from store
--********************************************
function PLUGIN:BuyItem( itemNum, price , amount , netuser , store)
  local inv = netuser.playerClient.rootControllable.idMain:GetComponent( "Inventory" )
  if(not inv) then -- Inventory not found
    print("ERROR Inventory not found Store Line 156")
  end
  
  local currency = self:GetWallet(inv , "Sulfur")
  local name = store:GetItemName(itemNum)
  if(currency) then 
    local cost = 0

    if(currency >= price) then --You have enough sulfur to buy at least 1 item.
      --Remove items from the store
       if(amount > (currency/price)) then --Adjust amount to number the player can afford
       amount = math.floor(currency/price)
       end
      
      
      local leftover = store:RemoveItem(itemNum , amount) 
      if(leftover > 0) then --Could not purchase all items
      amount = amount - leftover
      cost = price * amount
      else
      cost = price * amount
      end
    
    --Add sulfur to store's vault
    local excess = store:AddVault(cost)
    print(excess)
    if(excess > 0 ) then --Store remaining amount on person for next login
      local storeOwner = PlayerUtil:GetPlayer(store.Owner)
      storeOwner.Vault = storeOwner.Vault + excess
    end
    
    currency = currency - cost
     --Put Items into inventory
                    local datablock = rust.GetDatablockByName( name )
                    local pref = rust.InventorySlotPreference( InventorySlotKind.Default , false , InventorySlotKindFlags.Belt )
                    local arr = util.ArrayFromTable( System.Object, { datablock , amount, pref } )
                    inv:AddItemAmount( datablock , amount , pref )
                    --Put Change back into inventory
                     self:GiveChange(currency , inv , "Sulfur" )
                  
                    rust.InventoryNotice( netuser , tostring(amount).." x "..name )
                    config.Save("storeData")
      
    else
      self:GiveChange(currency , inv )
    end
    
    
  else
    rust.SendChatToUser( netuser , "You have no sulfur to buy with.")
  end
  
  
  
end

--********************************************
--Returns all the currency a player has
--********************************************
function PLUGIN:GetWallet(inv , item)
  local currency = inv:FindItem(item)  --Sulfur is the current currency
  if(currency) then 
    local wallet = 0 
    while(currency) do --collect all currency
      wallet = currency.Uses + wallet
      inv:RemoveItem(currency)
      currency = inv:FindItem(item)
    end
    return wallet --Return all currency on player   
  else
    return nil --No Currency Found 
  end
end

--********************************************
--Gives currency back to the player
--********************************************
function PLUGIN:GiveChange( amount , inv , item )
  if(amount ~= 0 ) then
  local datablock = rust.GetDatablockByName( item )
  local pref = rust.InventorySlotPreference( InventorySlotKind.Default, false, InventorySlotKindFlags.Belt )
  local arr = util.ArrayFromTable( System.Object, { datablock, amount, pref } )
  inv:AddItemAmount( datablock, amount, pref )
  end
end



--********************************************
--Load All Stores 
--********************************************
function PLUGIN:LoadStores()
  
  for key , value in pairs(self.Config) do
    self.Config[key] = Store:CreateStore(self.Config[key])
  end 
end


--********************************************
--Creates Server Store  If not already setup
--********************************************
--*********************************************
--Initialize Server Store
--*********************************************
function PLUGIN:LoadDefaultConfig()
  local setup = {}
  local store = Store:CreateStore(setup)
  local desc = "We help you survive! Great Prices! Daily Specials!"
  if(not store:SetDesc( desc )) then --Desc failed
  end
  
  store.Name = "Outland Air Aid"
  store.Owner = 0
  store.Tier = 25
  store.Vault = 25000
  store.Last = util.GetTime()
  
  local item = {}
  local name = itemTable[1]
  item.Name = itemTable[1] --Workbench 
  item.Amount = 50 --50 Workbenches for sell
  item.Price = 25  --Sell for 25 Sulfur
  
  local check = store:AddItem(item) 
  item.Name = itemTable[2] --Workbench 
  item.Amount = 50 --50 Workbenches for sell
  item.Price = 25  --Sell for 25 Sulfur
  check = store:AddItem(item)

  item.Name = itemTable[3] --Workbench 
  item.Amount = 50 --50 Workbenches for sell
  item.Price = 10  --Sell for 25 Sulfur
  check = store:AddItem(item)
  item.Name = itemTable[4] --Workbench 
  item.Amount = 50 --50 Workbenches for sell
  item.Price = 50  --Sell for 25 Sulfur
  check = store:AddItem(item)
  item.Name = itemTable[5] --Workbench 
  item.Amount = 50 --50 Workbenches for sell
  item.Price = 50  --Sell for 25 Sulfur
  check = store:AddItem(item)
  item.Name = itemTable[6] --Workbench 
  item.Amount = 50 --50 Workbenches for sell
  item.Price = 30  --Sell for 25 Sulfur
  check = store:AddItem(item)
  item.Name = itemTable[7] --Workbench 
  item.Amount = 50 --50 Workbenches for sell
  item.Price = 40  --Sell for 25 Sulfur
  check = store:AddItem(item)
  item.Name = itemTable[8] --Workbench 
  item.Amount = 50 --50 Workbenches for sell
  item.Price = 35  --Sell for 25 Sulfur
  check = store:AddItem(item)
  item.Name = itemTable[9] --Workbench 
  item.Amount = 50 --50 Workbenches for sell
  item.Price = 20  --Sell for 25 Sulfur
  check = store:AddItem(item)
  item.Name = itemTable[10] --Workbench 
  item.Amount = 50 --50 Workbenches for sell
  item.Price = 60  --Sell for 25 Sulfur
  check = store:AddItem(item)
  item.Name = itemTable[11] --Workbench 
  item.Amount = 50 --50 Workbenches for sell
  item.Price = 8  --Sell for 25 Sulfur
  check = store:AddItem(item)
  item.Name = itemTable[12] --Workbench 
  item.Amount = 50 --50 Workbenches for sell
  item.Price = 75  --Sell for 25 Sulfur
  check = store:AddItem(item)
  self.Config[1] = store
end


