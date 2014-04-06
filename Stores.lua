PLUGIN.Title = "Stores"
PLUGIN.Description = "Handles the store code"
PLUGIN.Version = "3.0"
PLUGIN.Author = "Xevoxe"

local itemTable = {        -- This table holds all the items that can be bought or sold in stores
  "Workbench",             --1
  "RepairBench",           --2
  "Stone Hatchet",         --3
  "9mm Pistol Blueprint",  --4
  "9mm Ammo Blueprint",    --5
  "Wood Planks",           --6
  "Low Quality Metal",     --7
  "Metal Door",            --8
  "Small Medkit",          --9
  "Large Medkit Blueprint",--10
  "Paper",                 --11
  "Research Kit 1"         --12
  }  
local storeList = {} --List of Stores
function PLUGIN:Init()
  
  print("Stores Loading")
  
   if( not api.Exists( "StoreMeta" )) then print("Stores needs StoreMeta")
        end
        Store = plugins.Find("StoreMeta")
  
   local b , res = config.Read("storeData")
   self.Config = res or {}
   if( not b ) then 
   self:LoadDefaultConfig()  --Server Store
   if ( res ) then config.Save("storeData") end  --Contains all player made stores     
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
  store.MaxItems = 1000
  
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
  --check = store:AddItem(item)
  
  self.Config[1] = store
end


