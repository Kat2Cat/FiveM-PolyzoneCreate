local isCreatingPolyzone = false
local polyzonePoints = {}

RegisterNetEvent('PolyCreator:createpolyzone')
AddEventHandler('PolyCreator:createpolyzone', function()
    isCreatingPolyzone = not isCreatingPolyzone
    polyzonePoints = {}
    if isCreatingPolyzone then
        lib.showTextUI(controlHelp[Config.Locale])
    else
        ShowNotification(Translate('zone_creator'), Translate('is_creating'), 'error')
    end
end)

RegisterNetEvent('PolyCreator:savepolyzone')
AddEventHandler('PolyCreator:savepolyzone', function()
    local input = lib.inputDialog(Translate('save_polyzone'), {
        {type = 'input', label = Translate('zone_name'), required = true},
    })
    if isCreatingPolyzone then
        local exists = lib.callback('PolyCreator:checkExists', false, input[1])
        if #polyzonePoints < 3 then
            ShowNotification(Translate('zone_creator'), Translate('at_least_three'), 'error')
            return
        end
        if exists then
            ShowNotification(Translate('zone_creator'), Translate('name_already_exist'), 'error')
            return
        end
        lib.hideTextUI()
        TriggerServerEvent('PolyCreator:savepolyzone', input[1], polyzonePoints)
        TriggerServerEvent('PolyCreator:requestpolyzone')
        isCreatingPolyzone = false
        polyzonePoints = {}
    else
        ShowNotification(Translate('zone_creator'), Translate('not_in_create_mode'), 'error')
    end
end)

RegisterNetEvent('PolyCreator:cancelpolyzone')
AddEventHandler('PolyCreator:cancelpolyzone', function()
    if isCreatingPolyzone then
        lib.hideTextUI()
        isCreatingPolyzone = false
        polyzonePoints = {}
        ShowNotification(Translate('zone_creator'), Translate('canceled'), 'error')
    else
        ShowNotification(Translate('zone_creator'), Translate('not_in_create_mode'), 'error')
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if isCreatingPolyzone then
            drawZone(polyzonePoints)
            if IsControlJustPressed(0, 176) then -- ENTER key
                local playerCoords = GetEntityCoords(PlayerPedId())
                table.insert(polyzonePoints, { x = playerCoords.x, y = playerCoords.y })
            elseif IsControlJustPressed(0, 177) then -- BACKSPACE key
                table.remove(polyzonePoints)
            end
        end
    end
end)

function drawZone(p1, p2, minZ, maxZ, r, g, b, a)
    local bottomLeft = vector3(p1.x, p1.y, minZ)
    local topLeft = vector3(p1.x, p1.y, maxZ)
    local bottomRight = vector3(p2.x, p2.y, minZ)
    local topRight = vector3(p2.x, p2.y, maxZ)
    
    DrawPoly(bottomLeft,topLeft,bottomRight,r,g,b,a)
    DrawPoly(topLeft,topRight,bottomRight,r,g,b,a)
    DrawPoly(bottomRight,topRight,topLeft,r,g,b,a)
    DrawPoly(bottomRight,topLeft,bottomLeft,r,g,b,a)
end
  
function drawZone(points)
    local zDrawDist = 45.0
    local oColor = {255, 0, 0}
    local oR, oG, oB = oColor[1], oColor[2], oColor[3]
    local wColor = {0, 255, 0}
    local wR, wG, wB = wColor[1], wColor[2], wColor[3]
    local plyPed = PlayerPedId()
    local plyPos = GetEntityCoords(plyPed)
    local minZ = plyPos.z - zDrawDist
    local maxZ = plyPos.z + zDrawDist
    
    for i=1, #points do
      local point = points[i]
      DrawLine(point.x, point.y, minZ, point.x, point.y, maxZ, oR, oG, oB, 164)
  
      if i < #points then
        local p2 = points[i+1]
        DrawLine(point.x, point.y, maxZ, p2.x, p2.y, maxZ, oR, oG, oB, 184)
        drawZone(point, p2, minZ, maxZ, wR, wG, wB, 48)
      end
    end
  
    if #points > 2 then
      local firstPoint = points[1]
      local lastPoint = points[#points]
      DrawLine(firstPoint.x, firstPoint.y, maxZ, lastPoint.x, lastPoint.y, maxZ, oR, oG, oB, 184)
      drawZone(firstPoint, lastPoint, minZ, maxZ, wR, wG, wB, 48)
    end
end

RegisterNetEvent('PolyCreator:notify')
AddEventHandler('PolyCreator:notify', function(title, msg, type)
    ShowNotification(title, msg, type)
end)

function GetPolyzonePoints(name, pointsFormat, z_coords)
    local points = lib.callback('PolyCreator:requestpolyzone', false, name)
    local result = {}
    if pointsFormat == 'ox' then
        for j=1, #points do
            local point = points[j]
            table.insert(result, vector3(point.x, point.y, z_coords))
        end
    elseif pointsFormat == 'qb' then
        for j=1, #points do
            local point = points[j]
            table.insert(result, vector2(point.x, point.y))
        end
    end
    
    return result
end
exports('GetPolyzonePoints', GetPolyzonePoints)