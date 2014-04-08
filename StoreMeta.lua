PLUGIN.Title = "StoreClass"
PLUGIN.Description = "A class to contain store data "
PLUGIN.Version = "3.0"
PLUGIN.Author = "Xevoxe"

local Store = {}
Store.__index = Store

local VAULTSIZE = nil
local ITEMSIZE =  nil
local SLOTSIZE =  nil
local TAX = nil

function PLUGIN:Init()
  print("Store Metatable Loading")
  
  VAULTSIZE = 1000
  ITEMSIZE  = 50
  SLOTSIZE  = 3
  TAX = .08
end

function Store.New()    --send in a new player Table
    
    local object = {}  --Class Object

    return setmetatable( object , Store )
  end

function PLUGIN:CreateStore( store )
  local newStore = Store.New()
  newStore.Name = store.Name or "Generic Store"
  newStore.Owner = store.Owner or 0
  newStore.Sell = store.Sell or {} -- Holds the items to sell
  newStore.CurItems = store.CurItems or 0
  newStore.Desc = store.Desc or "Generic Store"
  newStore.Vault = store.Vault or 0
  newStore.Tier = store.Tier or 1
  newStore.Last = store.Last or util.GetTime()
  return newStore
end

 Store.__newindex = function ( tab, key , value )
    if(  key == "Name" )      then rawset( tab, key, value ) return end
    if(  key == "Owner" )     then rawset( tab, key , value) return end 
    if(  key == "Sell" )      then rawset( tab, key , value) return end 
    if(  key == "CurItems")   then rawset( tab, key , value) return end
    if(  key == "Desc")       then rawset( tab, key , value) return end
    if(  key == "Vault")      then rawset( tab, key , value) return end
    if(  key == "Tier")       then rawset( tab, key , value) return end
    if(  key == "Last")       then rawset( tab, key , value) return end
    print(key.." is not a property of Store") 
 end
 
 
 --***************************************************
 --Adds currency to vault returns what cannot fit
 --***************************************************
 function Store:AddVault( currency )
   --Adjust currency so it will fit in vault
   local change = (self.Tier*VAULTSIZE)-(self.Vault + currency)
   
   if(change >= 0 ) then --Everything fit into the vault
     self.Vault = self.Vault + currency
     return 0
 else
   currency = currency - math.abs(change)
   self.Vault = self.Vault + currency
   change = math.abs(change)
   return change --Return what did not fit into the vault
   end
 end
 
 
 
 
 --***************************************************
 -- Adds a Item into the store Item Contains : Name Amount and Price
 --***************************************************
 
 function Store:AddItem ( item )
   local maxItems = self.Tier * ITEMSIZE
   local maxSlot  = self.Tier * SLOTSIZE
   --Check if store has room based on tier
 
   --Adjust the amount to fit into store
   local difference = 0
   local amount = item.Amount
   if(amount + self.CurItems > maxItems) then
   difference = math.abs(maxItems - (item.Amount + self.CurItems))
   amount = amount - difference
   end
   --If the adjusted amount is still too much then do nothing  
   if((amount+self.CurItems) <= maxItems) then
     --Check to see if the item is already in the store.
     for i = 1 , #self.Sell , 1 do 
      if(self.Sell[i].Name == item.Name) then --Item is in store already
        self.Sell[i].Amount = self.Sell[i].Amount + amount
        self.Sell[i].Price = item.Price
        self.CurItems = self.CurItems + amount
        self.Vault = self.Vault - (amount * item.Price * TAX)
        return difference --Item added 
     end
    end   
     --Item is does not exist in store
     --check if slots are available
     if(#self.Sell+1 <= maxSlot) then --You can add another slot
     local index = #self.Sell + 1
     self.Sell[index] = {}
     self.Sell[index].Name = item.Name
     self.Sell[index].Amount = amount
     self.Sell[index].Price = item.Price
     self.CurItems = self.CurItems + amount
     self.Vault = self.Vault - (amount * item.Price*TAX)
     return difference --Item Added 
   else
     return nil
   end
   
     else
   return nil --Item cannot be added
 end
 end
 
 --****************************************************
 --Remove a Item from the store Item Contains : Name and Amount
 --****************************************************
 function Store:RemoveItem( item , amount )
   
   --Find the Item
   
     if(self.Sell[item]) then --Item found in list
       --Compare and Adjust Remove Amount
       if(amount > self.Sell[item].Amount) then --There are not that many items in this store 
       local difference = math.abs(self.Sell[item].Amount - amount)
       local newAmount = amount - difference
       --Remove Items from store
       self.Sell[item].Amount = self.Sell[item].Amount - newAmount
       self.CurItems = self.CurItems - newAmount
       if(self.Sell[item].Amount == 0 ) then --No more items are for sell
         table.remove(self.Sell , item ) --Remove Item from store
       end
       return difference --Number of Items not Removed
      
      else
       --There are enough items in the store
       self.Sell[item].Amount = self.Sell[item].Amount - amount 
       self.CurItems = self.CurItems - amount
       if(self.Sell[item].Amount == 0 ) then --No more items are for sell
         table.remove(self.Sell , item ) --Remove Item from store
       end
      return 0 --All Items removed
    end  
  end
  return nil --Item not found in list
 end
 
 --******************************************************
 --Set Price of a Item Item Contains Name and Price
 --*****************************************************
 function Store:SetPrice( item , price)
     if(self.Sell[item]~= nil) then --Item is in store
       self.Sell[item].Price = price
       return true
      end
   return false --Item not found in list
 end
 
 --*******************************************************
 --Set Name of store
 --*******************************************************
 function Store:SetName( name )
   if(string.len(name) <= 30 ) then --Name is valid
     self.Name = name
     return true
   else
     return false 
   end
 end
 
 
 --*******************************************************
 --Set Description of store
 --*******************************************************
 function Store:SetDesc( desc )
   if(string.len(desc) <= 60 ) then --Desc is valid
     self.Desc = desc
     return true
   else
     return false --Description is too long
 end
end

--********************************************************
--Get Price of Item
--********************************************************
function Store:Price(item)
  if(self.Sell[item] ~= nil) then
  return self.Sell[item].Price
else 
  return false --Item does not exist
end
end



--********************************************************
--Print For Sell Contents Takes a netuser
--********************************************************
function Store:ForSale(netuser)
    local string = string.format("%10s     %10s     %20s     %-s", "[NUM]","[PRICE]", "[AMOUNT]", "[ITEM]"  )
    rust.SendChatToUser( netuser , "Welcome to "..self.Name.."!")
    rust.SendChatToUser( netuser , string)  
  for i = 1 , #self.Sell , 1 do
    string = string.format("%-10s     %10s     %20s     %-s", tostring(i) ,tostring(self.Sell[i].Price), tostring(self.Sell[i].Amount), self.Sell[i].Name)
    rust.SendChatToUser( netuser , string )
  end
end

--*******************************************************
--Get Name of the Item
--*******************************************************
function Store:GetItemName( itemNum )
  return self.Sell[itemNum].Name
end

--*******************************************************
--Check Max Vault
--*******************************************************
function Store:CheckVault(amount)
  local amount = self.Vault + amount
  if(amount > (self.Tier * VAULTSIZE) ) then --Amount wont fit
    return false
  else
    return true
  end
end


 api.Bind(PLUGIN, "StoreMeta")
 