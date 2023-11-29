fx_version 'cerulean'
game 'gta5'
lua54 'yes'

description 'create polyzone with commands'
version '1.0'
author 'Kat2Cat -- Discord: kat2cat'

shared_scripts { 
    '@ox_lib/init.lua',
    'config.lua', 
}

client_scripts {
	'client.lua',
}

server_scripts { 
    'server.lua', 
    '@oxmysql/lib/MySQL.lua'
}