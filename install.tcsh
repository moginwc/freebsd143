#!/bin/tcsh

# シェルスクリプト初期設定
set ver="freebsd143"

# システム起動時に ntpdが起動するよう設定する (3.初期設定 ntpd)
sudo service ntpd enable
sudo cp ./etc_ntp.conf /etc/ntp.conf

# 省エネ動作の設定を行う (3.初期設定 powerd)
sudo service powerd enable

# グラフィックドライバーのインストール (3.初期設定 グラフィックドライバー)
sudo pkg install -y -q drm-515-kmod
sudo sysrc kld_list+=i915kms
sudo pw groupmod video -m pcuser

# ファイヤーウォールの設定 (3.初期設定 ファイヤーウォール)
sudo service pf enable
sudo sysrc pf_rules+=/etc/pf.conf
sudo cp etc_pf.conf /etc/pf.conf

# vimエディターをインストールする (3.初期設定 vimエディタ)
sudo pkg install -y -q vim
cp ./.vimrc ~

# シェルスクリプト初期設定 (3.初期設定 シェルスクリプト)
cp ./.cshrc ~
cp ./.login ~

# X-Window System をインストールする (3.初期設定 ウインドウ関係1)
sudo pkg install -y -q xorg

# ウィンドウシステムをインストールする
sudo pkg install -y -q fvwm
mkdir ~/icons
cp /usr/local/share/fvwm/pixmaps/programs.xpm ~/icons
cp /usr/local/share/fvwm/pixmaps/xterm-sol.xpm ~/icons
sudo pkg install -y -q ImageMagick7
magick ~/icons/programs.xpm -trim +repage -scale 200% ~/icons/programs.png
magick ~/icons/xterm-sol.xpm -crop 44x34+5+2 ~/icons/xterm-sol.png
sudo pkg install -y -q fvwm3
sudo pkg install -y -q ja-font-ipa noto-sans-jp

# ウィンドウシステムの初期設定 (3.初期設定 ウインドウ関係2,3)
cp ./.xinitrc ~
cp ./.fvwm2rc ~

# 初期設定ファイルのコメント外し
sed -i '' 's/^##//g' ~/.fvwm2rc
sed -i '' 's/^##//g' ~/.xinitrc
sed -i '' 's/^##//g' ~/.login
sed -i '' 's/^"//g'  ~/.vimrc

# 端末エミュレータのインストールと設定 (8-25. mltermを使いたい)
sudo pkg install -y -q mlterm
cp -r ./.mlterm ~

# 端末エミュレータのインストールと設定 (3.初期設定 端末エミュレータ)
sudo pkg install -y -q xfce4-terminal

# 入力メソッド・日本語入力システムのインストールと設定 (3.初期設定 日本語入力1,2)
sudo pkg install -y -q ja-uim-anthy uim-gtk2 uim-gtk3 uim-qt5 uim-qt6
cp -r ./.xkb ~

# 入力メソッド・日本語入力システムの初期設定 (3.初期設定 日本語入力3相当)
cp -r ./.uim.d-anthy ~
mv ~/.uim.d-anthy ~/.uim.d

# ユーザー辞書ファイルの作成
mkdir ~/.anthy
## touch ~/.anthy/private_words_default
cp -r ./.anthy ~

# アプリのインストール (3.初期設定 Firefox、その他)
sudo pkg install -y -q firefox-esr
sudo pkg install -y -q scrot
sudo pkg install -y -q xlockmore
sudo pkg install -y -q lupe
sudo pkg install -y -q xpad3

# xpadの初期設定、他config設定、3.初期設定 端末エミュレータ
# 8-23.ファイル管理ソフトThunarを使いたい(.config/Thunar/uca.xml)
# 8-23.ファイル管理ソフトThunarを使いたい(.config/gtk-3.0/bookmarks)
# 8-23.ファイル管理ソフトThunarを使いたい(.config/xfce4/xfconf/xfce-perchannel-xml/thunar.xml)
cp -r ./.config ~

# パッケージのアップデート (3.初期設定 パッケージのアップデート)
sudo pkg update -f
sudo pkg upgrade

# 8-7.Macのユーザー辞書をインポートしたい
# 11-2.Macのユーザー辞書をMozcへインポートしたい
# 8-17.QGIS(地理空間情報の閲覧、編集、分析)を使いたい→GPSロガーのデータ(NMEA0183形式)を読み込みたい
# 8-5.Firefoxを起動し、radikoでラジオNIKKEI第1を自動的に再生したい→NHKラジオ第一放送（首都圏）に切り替えたい
# 13-5.デジカメなどの画像データを、撮影日(年/月/日)別に整理したい
# 14-2.仮想環境を構築し、FreeBSD内にLinuxをインストールしたい
# 8-20.外付けカメラを利用したい
# 15-2.駅発車標表示専用パソコンにしたい
# 15-4.ドット絵を描いて動かしたい
# 9-19.音量調整時に、画面上に音量・ミュート状態を表示したい
cp -r ./bin ~
chmod +x ~/bin/*.tcsh

# 5-4.ログインした際のメッセージを、Last login以外、表示させない
sudo mv /etc/motd.template /etc/motd.template.old
sudo touch /etc/motd.template

# 8-6.chromium（ウェブブラウザ）を使用したい
sudo pkg install -y -q chromium webfonts
mkdir ~/Downloads

# 8-23.ファイル管理ソフトThunarを使いたい、のインストールと設定ファイルのコピー
sudo pkg install -y -q thunar thunar-archive-plugin xarchiver
xdg-mime default userapp-vim-readonly.desktop text/plain
xdg-mime default userapp-feh.desktop image/png
xdg-mime default userapp-feh.desktop image/jpeg
mkdir -p ~/.local/share/applications
cp ./.local/share/applications/* ~/.local/share/applications
chmod +x ~/bin/conv_img_480s.tcsh
mkdir -p ~/.local/share/Thunar/sendto
cp ./.local/share/Thunar/sendto/* ~/.local/share/Thunar/sendto

# 9-1. 9-2.
cp /usr/local/lib/firefox/browser/chrome/icons/default/default32.png ~/icons/firefox.png
magick /usr/local/share/icons/hicolor/64x64/apps/chrome.png -resize 32x32 ~/icons/chrome.png
sudo pkg install -y -q xload
sudo pkg install -y -q xbatt

# 8-15.システム情報を表示したい(conky設定)
sudo pkg install -y -q conky
cp ./.conkyrc ~

# 文字コード表
cp -r ./html ~

# 9-10.クリップボードの不具合を解決したい
sudo pkg install -y -q autocutsel

# 5-5.起動時のブートメニューやメッセージをできるだけ表示させない
sudo cp ./root_boot.config /boot.config
grep '^autoboot_delay=' /boot/loader.conf > /dev/null
if ( $status == 0 ) then
    sudo sed -i '' 's/^autoboot_delay=.*/autoboot_delay="-1"/' /boot/loader.conf
else
    echo 'autoboot_delay="-1"' | sudo tee -a /boot/loader.conf
endif

# 5-3.特定のコマンドは、パスワードなしでsudoを実行したい(visudoの設定)
set addstr = "pcuser ALL=NOPASSWD: /sbin/shutdown"
grep -F -- "$addstr" /usr/local/etc/sudoers > /dev/null
if ( $status != 0 ) then
    echo "$addstr" | sudo tee -a /usr/local/etc/sudoers
endif

# 5-6.IPアドレスを固定化したい(IPv4) *コメントアウト状態にて
set addstr = '#ifconfig_em0="inet 192.168.1.8/24"'
grep -F -- "$addstr" /etc/rc.conf > /dev/null
if ( $status != 0 ) then
    echo "$addstr" | sudo tee -a /etc/rc.conf
endif

set addstr = '#defaultrouter="192.168.1.1"'
grep -F -- "$addstr" /etc/rc.conf > /dev/null
if ( $status != 0 ) then
    echo "$addstr" | sudo tee -a /etc/rc.conf
endif

# 5-11.IPv6で接続したい *コメントアウト状態にて
set addstr = '#ifconfig_em0_ipv6="inet6 accept_rtadv"'
grep -F -- "$addstr" /etc/rc.conf > /dev/null
if ( $status != 0 ) then
    echo "$addstr" | sudo tee -a /etc/rc.conf
endif

# 11-1.mozcのインストールと初期設定 (*ここでは初期設定のみでインストールはしない)
cp -r ./.uim.d-mozc/customs/custom-mozc.scm ~/.uim.d/customs/
mkdir ~/.mozc
/usr/local/bin/xxd -r -p ./.mozc/config1.db.hex > ~/.mozc/config1.db

# 8-14.サムネイル一覧から画像を選択して表示したい (nsxiv)
sudo pkg install -y -q nsxiv
chmod +x ~/.config/nsxiv/exec/image-info
chmod +x ~/.config/nsxiv/exec/key-handler
sudo pkg install -y -q p5-Image-ExifTool

# 8-26. 軽量画像ビュアnsxivをカスタマイズして使いたい (nsxivバージョン33であることが前提)
sudo pkg install -y -q gmake git
rehash # gmakeを認識させる
mkdir ~/work
pushd ~/work
git clone https://codeberg.org/nsxiv/nsxiv.git
pushd ./nsxiv
cp ~/${ver}/nsxiv/config.h .
cp ~/${ver}/nsxiv/config.mk .
gmake CC=cc
sudo gmake install
popd
popd

# サンプル画像のコピー
mkdir ~/Pictures
magick ./colorbar1.svg ~/Pictures/colorbar1.png
magick ./colorbar2.svg ~/Pictures/colorbar2.png
magick ./colorbar3.svg ~/Pictures/colorbar3.png
magick ./colorbar4.svg ~/Pictures/colorbar4.png

# 12-6.外付けHDDに、ファイル・ディレクトリを指定してバックアップを取りたい
cp ./.backup_config ~
cp ./.backup_exclude_config ~
sudo pkg install -y -q rsync

# 9-13.GTK系アプリのデフォルトフォントを変更したい
cp ./.gtkrc-2.0 ~

# 9-14.フォントのアンチエイリアスをグレースケール方式にしたい(GTK2系)
cp ./.Xresources ~

# 8-18.閲覧専用でメーラーを使いたい、メッセージ本文以外のフォントを変更したい
sudo pkg install -y -q sylpheed
cp -r ./.sylpheed-2.0 ~

# 8-11.GIMPを使いたい
sudo pkg install -y -q gimp

# 8-17.QGIS(地理空間情報の閲覧、編集、分析)を使いたい
sudo pkg install -y -q qgis open-sans
cp line.csv point.csv ~

# 8-13.OpenSCADで通信鉄塔をモデリングしたい
sudo pkg install -y -q openscad
cp ant_tower.scad ~

# 7-5.FreeBSDから、Windowsにリモートデスクトップ経由で接続したい
sudo pkg install -y -q freerdp

# 7-7.FreeBSDから、MacにVNC接続したい
sudo pkg install -y -q tigervnc-viewer

# 5-8.再起動時に/tmpフォルダーをクリアーしたい
sudo sysrc clear_tmp_enable="YES"

# 8-9.画面スライドショーしたい
sudo pkg install -y -q feh

# 7-12.端末を閉じても、作業を続けられるようにしたい
sudo pkg install -y -q tmux
cp ./.tmux.conf ~

# 13-12.自作のmanページを作成したい
cp -r ./man ~

# 8-23.(ファイルタイプ表示名の変更)
mkdir -p ~/.local/share/mime/packages
cp /usr/local/share/mime/packages/freedesktop.org.xml ~/.local/share/mime/packages
sed -i '' 's/平文テキストドキュメント/テキストファイル/g' ~/.local/share/mime/packages/freedesktop.org.xml
sed -i '' 's/平文文書/テキストファイル/g' ~/.local/share/mime/packages/freedesktop.org.xml
update-mime-database ~/.local/share/mime

# 8-10. Firefoxの初期設定を、起動せずに行いたい
sudo mkdir -p /usr/local/lib/firefox/distribution
sudo cp ./policies.json /usr/local/lib/firefox/distribution

# 7-3.Windowsやmacとファイル共有したい(SMB)
sudo pkg install -y -q samba416
sudo service samba_server enable
mkdir ~/share
sudo cp etc_smb4.conf /usr/local/etc/smb4.conf
sudo pdbedit -a -u pcuser
