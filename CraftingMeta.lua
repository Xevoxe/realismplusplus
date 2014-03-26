PLUGIN.Title = "Crafting Meta"
PLUGIN.Description = " This Metatable contains everything that is crafting related."
PLUGIN.Version = "1.0"
PLUGIN.Author = "Xevoxe"

local Crafting = {}
Crafting.__index = Crafting

function PLUGIN:Init()
  print("Loading Crafting Realism++ Version 1.0")
   
  local b , res = config.Read("blueprintData")
  self.Config = res or {}
  if( not b ) then 
    self:LoadDefaultConfig()
  if ( res ) then config.Save("blueprintData") end
 end
end

function PLUGIN:LoadDefaultConfig()
  local blueprint = {}
  blueprint.Name = "Large Wood Storage"
  blueprint.Blueprint = "Large Wood Storage Blueprint"
  blueprint.Difficulty = 5
  self.Config[blueprint.Name] = blueprint
  config.Save("blueprintData")
  
end



function PLUGIN:New(data)
  return Crafting
end

local bluePrintList = {}  --This holds the players blueprints

 Crafting.__newindex = function ( tab, key , value )
    print(key.." is not a property of Crafting") 
 end

function PLUGIN:CraftBlueprint( blueprint )
  local level = bluePrintList[blueprint]
  local difficulty = self.Config[blueprint].Difficulty
  
  --Get Random Number 0 - 25
  local num = math.random(0 , 25)
  
  if( level - difficulty > num  ) then --Player is successful
    if(self:LevelBlueprint(level , difficulty , failed )) then --Player Levels up
      bluePrintList[blueprint] = bluePrintList[blueprint] + 1
    end
    return true
  else
    --Player fails to craft
    return false
  end
end

function PLUGIN:CheckBlueprint( blueprint )
  if(self.Config[blueprint] ~= nil ) then
    return true --Blueprint is required to craft
  else
    return false
    end
end

function Crafting.LevelBlueprint(level , difficulty , failed )
  
  local num = math.random( 0 , 25 )
  if(failed) then 
    level = level + difficulty -- Being successful does not garuntee learning
   end
  
  if( level < num ) then --Player Levels Up
    return true
  else
    return false
  end
end

function PLUGIN:GetBlueprint(item)
  return self.Config[item].Blueprint
end

api.Bind(PLUGIN, "CraftingMeta")
