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
    self:AddChatCommand( "store" , self.cmdStore )
end






--********************************************
--/Store Commands dealing with stores
--********************************************
function PLUGIN:cmdStore( netuser, cmd, args )
  local userID = rust.GetUserID(netuser)
  local player = PlayerUtil:GetPlayer(userID)
if( args[1] ~= nil ) then
args[1] = string.lower(args[1])  
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
            player.VisitStore = args[2]
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
rust.SendChatToUser( netuser , "Commands: list , set")
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


