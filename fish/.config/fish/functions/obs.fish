function obs --wraps='flatpak run --nosocket=wayland --socket=x11 --env=DISPLAY=:0 com.obsproject.Studio' --description 'alias obs=flatpak run --nosocket=wayland --socket=x11 --env=DISPLAY=:0 com.obsproject.Studio'
    flatpak run --nosocket=wayland --socket=x11 --env=DISPLAY=:0 com.obsproject.Studio $argv
end
