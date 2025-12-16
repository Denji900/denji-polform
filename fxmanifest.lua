fx_version 'cerulean'
game 'gta5'

author 'Denji'
description 'Police Job Application'
version '1.1'

ui_page 'web/index.html'

files {
    'web/index.html',
    'web/assets/css/style.css',
    'web/assets/js/script.js',
    'web/media/success.gif',
    'web/media/logo.png'
}

client_scripts {
    'client/main.lua'
}

server_scripts {
    'server/main.lua'
}

shared_script 'config.lua'
