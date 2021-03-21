#!/bin/bash
# KDE3/TDE のときは xim、Plasma のときは fcitx か ibus
echo -e "QT_IM_MODULE\t${QT_IM_MODULE}"

# 使われているのかわからない (たぶん使っていない)
echo -e "QT4_IM_MODULE\t${QT4_IM_MODULE}"

# GNOME のときは fcitx か ibus
echo -e "GTK_IM_MODULE\t${GTK_IM_MODULE}"

# xterm は @im=fcitx か @im=ibus
echo -e "XMODIFIERS\t${XMODIFIERS}"
