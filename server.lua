lib.addCommand('CreateZone', {
    help = 'Create a polyzone',
    params = {
        {name = 'func', help = 'create|save|cancel'},
    },
    restricted = Config.GangZoneCommandPermissions,
}, function(source, args)
    local func = args.func
    if func == 'create' then
        TriggerClientEvent('PolyCreator:createpolyzone', source)
    elseif func == 'save' then
        TriggerClientEvent('PolyCreator:savepolyzone', source)
    elseif func == 'cancel' then
        TriggerClientEvent('PolyCreator:cancelpolyzone', source)
    else
        TriggerClientEvent('PolyCreator:notify', source, "", Translate('invalid_command'), 'error')
    end
end)

--Register server events for saving poly zones to sql
RegisterNetEvent('PolyCreator:savepolyzone')
AddEventHandler('PolyCreator:savepolyzone', function(name, points)
    local src = source
    local rowsChanged = MySQL.Sync.execute('INSERT INTO `polyzones` (name, points) VALUES (?, ?)', {name, json.encode(points)})
    
    if rowsChanged > 0 then
        TriggerClientEvent('PolyCreator:notify', src, "", name..Translate('created'), 'success')
    else
        TriggerClientEvent('PolyCreator:notify', src, "", Translate('create_fail'), 'error')
    end
end)

lib.callback.register('PolyCreator:checkExists', function(source, name)
    local result = MySQL.Sync.fetchAll('SELECT * FROM `polyzones` WHERE name = ?', {name})
    if result[1] ~= nil then
        return true
    end
    return false
end)

lib.callback.register('PolyCreator:requestpolyzone', function(source, name)
    local src = source
    local result = MySQL.Sync.fetchAll('SELECT * FROM `polyzones` WHERE name = ?', {name})
    if result[1] ~= nil then
        return json.decode(result[1].points)
    end
    return false
end)