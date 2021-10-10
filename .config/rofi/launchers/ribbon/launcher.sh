theme="ribbon_top"

dir="$HOME/.config/rofi/launchers/ribbon"
styles=($(ls -p --hide="colors.rasi" $dir/styles))
color="theme.rasi"

sed -i -e "s/@import .*/@import \"$color\"/g" $dir/styles/colors.rasi

rofi -no-lazy-grab -show drun -modi drun -terminal gnome-terminal -theme $dir/"$theme"
