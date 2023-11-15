Config = {}
Config.Locale = 'en'
Config.Command = 'CreateZone'

Locales = {
    ['en'] = {
        ['invalid_command'] = 'Invalid command',
        ['zone_creator'] = 'Zone Creator',
        ['is_creating'] = 'Already in creating mode',
        ['save_polyzone'] = 'Save Polyzone',
        ['zone_name'] = 'Name of the Zone',
        ['at_least_three'] = 'At least three points are required',
        ['name_already_exist'] = 'Name already exist',
        ['not_in_create_mode'] = 'Not in create mode',
        ['canceled'] = 'Canceled',
        ['created'] = ' Created',
        ['create_fail'] = 'Failed to create zone',
    },
    ['zh-hk'] = {
        ['invalid_command'] = '無效的指令',
        ['zone_creator'] = '創建區域',
        ['is_creating'] = '已經在創建模式'.
        ['save_polyzone'] = '儲存區域',
        ['zone_name'] = '區域名稱',
        ['at_least_three'] = '至少需要三個點',
        ['name_already_exist'] = '有重複名稱的區域',
        ['not_in_create_mode'] = '未啟用創建模式',
        ['canceled'] = '已取消',
        ['created'] = ' 已創建',
        ['create_fail'] = '創建區域失敗',
    }
}

controlHelp = {
['en'] = [[
    ENTER key to add a point
    BACKSPACE key to delete the last point
]],
['zh-hk'] = [[
    ENTER 鍵添加一個點
    BACKSPACE 鍵刪除最後一個點
]]}

function Translate(key)
    return Locales[Config.Locale][key]
end

function ShowNotification(title, msg, type)
    lib.notify({
        title = title,
        description = msg,
        duration = 5000,
        position = 'center-right',
        type = type,
    })
end