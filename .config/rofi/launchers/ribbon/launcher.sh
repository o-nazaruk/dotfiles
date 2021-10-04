theme="ribbon_top"

dir="$HOME/.config/rofi/launchers/ribbon"
styles=($(ls -p --hide="colors.rasi" $dir/styles))
color="theme.rasi"

# comment this line to disable random colors
sed -i -e "s/@import .*/@import \"$color\"/g" $dir/styles/colors.rasi


rofi -no-lazy-grab -show drun -modi drun -theme $dir/"$theme"
