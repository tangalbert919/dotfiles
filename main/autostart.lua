-- Autostart module.

-- Standard awesome library
local awful = require("awful")

awful.spawn.with_shell(
    'if (xrdb -query | grep -q "^awesome\\.started:\\s*true$"); then exit; fi;' ..
    'xrdb -merge <<< "awesome.started:true";' ..
    -- list each of your autostart commands, followed by ; inside single quotes, followed by ..
    --'dex --environment Awesome --autostart --search-paths "$XDG_CONFIG_DIRS/autostart:$XDG_CONFIG_HOME/autostart"' -- https://github.com/jceb/dex
    'picom -b;' ..
    'conky --pause=5;' ..
    'discord --ignore-gpu-blacklist --disable-features=UseOzonePlatform --enable-features=VaapiVideoDecoder --use-gl=desktop --enable-gpu-rasterization --enable-zero-copy'
)