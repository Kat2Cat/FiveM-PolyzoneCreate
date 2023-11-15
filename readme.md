# PolyzoneCreator

## Description

This script can create polyzone points and store it into sql.

Showcase: coming soon!
## Dependency
[ox_lib](https://github.com/overextended/ox_lib)

## Installation
Just put into server-data and ensure in the server.cfg

## Client-side Exports 
```
GetPolyzonePoints(name, pointsFormat, z_coords)
```
## Usage
#### Command
`/CreateZone create` enable creating mode
`/CreateZone cancel` end creating mode
`/CreateZone save` end creating mode and save the points

####Example
```lua
-- ox_target
local points = exports['PolyzoneCreator']:GetPolyzonePoints('test', 'ox', 30.0)
exports.ox_target:addBoxZone({   
    points = points,
    thickness = 20.0,
    debug = false,
    options = {
        {   
            name = "TestCase",
            label = "TestCase",
            onSelect = function(data)
                print("Hello World")
            end
        }
    }
})
```

```lua
-- ox_lib
function onEnter(self)
    print('entered zone', self.id)
end
 
function onExit(self)
    print('exited zone', self.id)
end
 
function inside(self)
    print('you are inside zone ' .. self.id)
end
 
local points = exports['PolyzoneCreator']:GetPolyzonePoints('test', 'ox', 30.0)
local poly = lib.zones.poly({
    points = points,
    thickness = 2,
    debug = true,
    inside = inside,
    onEnter = onEnter,
    onExit = onExit
})
```

```lua
-- qb-target
local points = exports['PolyzoneCreator']:GetPolyzonePoints('test', 'qb', 30.0)
["index"] = { -- This can be a string or a number
    name = "name", -- This is the name of the zone recognized by PolyZone, this has to be unique so it doesn't mess up with other zones
    points = points,
    debugPoly = false, -- This is for enabling/disabling the drawing of the box, it accepts only a boolean value (true or false), when true it will draw the polyzone in green
    minZ = 36.7, -- This is the bottom of the boxzone, this can be different from the Z value in the coords, this has to be a float value
    maxZ = 38.9, -- This is the top of the boxzone, this can be different from the Z value in the coords, this has to be a float value
    options = { -- This is your options table, in this table all the options will be specified for the target to accept
      { -- This is the first table with options, you can make as many options inside the options table as you want
        num = 1, -- This is the position number of your option in the list of options in the qb-target context menu (OPTIONAL)
        type = "client", -- This specifies the type of event the target has to trigger on click, this can be "client", "server", "command" or "qbcommand", this is OPTIONAL and will only work if the event is also specified
        event = "Test:Event", -- This is the event it will trigger on click, this can be a client event, server event, command or qbcore registered command, NOTICE: Normal command can't have arguments passed through, QBCore registered ones can have arguments passed through
        icon = 'fas fa-example', -- This is the icon that will display next to this trigger option
        label = 'Test', -- This is the label of this option which you would be able to click on to trigger everything, this has to be a string
        targeticon = 'fas fa-example', -- This is the icon of the target itself, the icon changes to this when it turns blue on this specific option, this is OPTIONAL
        item = 'handcuffs', -- This is the item it has to check for, this option will only show up if the player has this item, this is OPTIONAL
        action = function(entity) -- This is the action it has to perform, this REPLACES the event and this is OPTIONAL
          if IsPedAPlayer(entity) then return false end -- This will return false if the entity interacted with is a player and otherwise returns true
          TriggerEvent('testing:event', 'test') -- Triggers a client event called testing:event and sends the argument 'test' with it
        end,
        canInteract = function(entity, distance, data) -- This will check if you can interact with it, this won't show up if it returns false, this is OPTIONAL
          if IsPedAPlayer(entity) then return false end -- This will return false if the entity interacted with is a player and otherwise returns true
          return true
        end,
        job = 'police', -- This is the job, this option won't show up if the player doesn't have this job, this can also be done with multiple jobs and grades, if you want multiple jobs you always need a grade with it: job = {["police"] = 0, ["ambulance"] = 2},
        gang = 'ballas', -- This is the gang, this option won't show up if the player doesn't have this gang, this can also be done with multiple gangs and grades, if you want multiple gangs you always need a grade with it: gang = {["ballas"] = 0, ["thelostmc"] = 2},
        citizenid = 'JFD98238', -- This is the citizenid, this option won't show up if the player doesn't have this citizenid, this can also be done with multiple citizenid's, if you want multiple citizenid's there is a specific format to follow: citizenid = {["JFD98238"] = true, ["HJS29340"] = true},
        drawDistance = 10.0, -- This is the distance for the sprite to draw if Config.DrawSprite is enabled, this is in GTA Units (OPTIONAL)
        drawColor = {255, 255, 255, 255}, -- This is the color of the sprite if Config.DrawSprite is enabled, this will change the color for this PolyZone only, if this is not present, it will fallback to Config.DrawColor, for more information, check the comment above Config.DrawColor (OPTIONAL)
        successDrawColor = {30, 144, 255, 255}, -- This is the color of the sprite if Config.DrawSprite is enabled, this will change the color for this PolyZone only, if this is not present, it will fallback to Config.DrawColor, for more information, check the comment above Config.DrawColor (OPTIONAL)
      }
    },
    distance = 2.5, -- This is the distance for you to be at for the target to turn blue, this is in GTA units and has to be a float value
},
```