PLUGIN.Title = "StoreClass"
PLUGIN.Description = "A class to contain store data "
PLUGIN.Version = "3.0"
PLUGIN.Author = "Xevoxe"

local Store = {}
Store.__index = Store

function PLUGIN:Init()
  print("Store Metatable Loading")
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
  newStore.MaxItems = store.MaxItems or 50
  newStore.CurItems = store.CurItems or 0
  newStore.Desc = store.Desc or "Generic Store"
  return newStore
end

 Store.__newindex = function ( tab, key , value )
    if(  key == "Name" )      then rawset( tab, key, value ) return end
    if(  key == "Owner" )     then rawset( tab, key , value) return end 
    if(  key == "Sell" )      then rawset( tab, key , value) return end 
    if(  key == "MaxItems")   then rawset( tab, key , value) return end
    if(  key == "CurItems")   then rawset( tab, key , value) return end
    if(  key == "Desc")       then rawset( tab, key , value) return end
    print(key.." is not a property of Store") 
 end
 
 --***************************************************
 -- Adds a Item into the store Item Contains : Name Amount and Price
 --***************************************************
 
 function Store:AddItem ( item )
   --Adjust the amount to fit into store
   local difference = 0
   local amount = 0
   print(item.Name)
   if(item.Amount + self.CurItems > self.MaxItems) then
   difference = math.abs(self.MaxItems - (item.Amount + self.CurItems))
   amount = item.Amount - difference
   end
   --If the adjusted amount is still too much then do nothing  
   if(amount <= self.MaxItems) then
     --Check to see if the item is already in the store.
     for i = 1 , #self.Sell , 1 do 
      if(self.Sell[i].Name == item.Name) then --Item is in store already
        self.Sell[i].Amount = self.Sell[i].Amount + amount
        self.CurItems = self.CurItems + amount
        return difference --Item added 
     end
    end   
     --Item is does not exist in store
     local index = #self.Sell + 1
     self.Sell[index] = {}
     self.Sell[index].Name = item.Name
     self.Sell[index].Amount = item.Amount
     self.Sell[index].Price = item.Price
     self.CurItems = self.CurItems + item.Amount
     return 0 --Item Added 
     else
   return difference --Item cannot be added
 end
 end
 
 --****************************************************
 --Remove a Item from the store Item Contains : Name and Amount
 --****************************************************
 function Store:RemoveItem( item )
   
   --Find the Item
   for i = 1 , #self.Sell , 1 do
     if( self.Sell[i].Name == item.Name ) then --Item found in list
       --Compare and Adjust Remove Amount
       if(item.Amount > self.Sell[i].Amount) then --There are not that many items in this store 
       local difference = math.abs(self.Sell[i].Amount - item.Amount)
       local amount = item.Amount - difference
       --Remove Items from store
       self.Sell[i] = self.Sell[i].Amount - amount
       self.CurItems = self.CurItems - amount
       return difference --Number of Items not Removed
      
      else
       --There are enough items in the store
       self.Sell[i] = self.Sell[i].Amount - item.Amount 
       self.CurItems = self.CurItems - item.Amount
       if(self.Sell[i].Amount == 0 ) then --No more items are for sell
         table.remove(self.Sell , i ) --Remove Item from store
       end
      return 0 --All Items removed
      end     
    end
  end
  return nil --Item not found in list
 end
 
 --******************************************************
 --Set Price of a Item Item Contains Name and Price
 --*****************************************************
 function Store:SetPrice( item )
   for i = 1 , #self.Sell , 1 do
     if(item.Name == self.Sell[i].Name) then --Item is in store
       self.Sell[i].Price = item.Price
       return true
      end
      end
   return false --Item not found in list
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

 api.Bind(PLUGIN, "StoreMeta")
 