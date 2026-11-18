fx_version 'cerulean'
game 'gta5'
lua54 'yes'

name 'katana_notify'
author 'katanadesk'
description 'Simple notifications with positions'
repository 'https://github.com/katanadesk/katana_notify'
version '1.0.0'

shared_scripts {
    '@ox_lib/init.lua',
}

client_scripts {
  'shared/config.lua',
  'client/main.lua',
}

ui_page 'web/index.html'

files {
  'web/index.html',
  'web/style.css',
  'web/app.js',
  'web/sounds/*.ogg',
}
