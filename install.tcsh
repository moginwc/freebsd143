#!/bin/tcsh

# システム起動時に ntpdが起動するよう設定する (3.初期設定 ntpd)
sudo service ntpd enable
sudo cp ./etc_ntp.conf /etc/ntp.conf

# 省エネ動作の設定を行う (3.初期設定 powerd)
sudo service powerd enable

# グラフィックドライバーのインストール (3.初期設定 グラフィックドライバー)
sudo pkg install -y -q drm-510-kmod
sudo sysrc kld_list+=i915kms
sudo pw groupmod video -m pcuser

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
magick ~/icons/xterm-sol.xpm ~/icons/xterm-sol.png
sudo pkg install -y -q fvwm3
sudo pkg install -y -q ja-font-ipa noto-sans-jp

# ウィンドウシステムの初期設定 (3.初期設定 ウインドウ関係2,3)
cp ./.xinitrc ~
cp ./.fvwm2rc ~

# 初期設定ファイルのコメント外し
sed -i '' 's/^##//g' ~/.fvwm2rc
sed -i '' 's/^##//g' ~/.xinitrc
sed -i '' 's/^##//g' ~/.login

# 端末エミュレータのインストールと設定 (3.初期設定 端末エミュレータ)
sudo pkg install -y -q mlterm
cp -r ./.mlterm ~

# 入力メソッド・日本語入力システムのインストールと設定 (3.初期設定 日本語入力1,2)
sudo pkg install -y -q ja-uim-anthy uim-gtk uim-gtk3 uim-qt5
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

# xpadの初期設定、他config設定
cp -r ./.config ~

# パッケージのアップデート (3.初期設定 パッケージのアップデート)
sudo pkg update -f
sudo pkg upgrade

# 5-4.ログインした際のメッセージを、Last login以外、表示させない
sudo mv /etc/motd.template /etc/motd.template.old
sudo touch /etc/motd.template

# 8-6.chromium（ウェブブラウザ）を使用したい
sudo pkg install -y -q chromium webfonts

# 9-1. 9-2.
cp /usr/local/lib/firefox/browser/chrome/icons/default/default48.png ~/icons/firefox.png
cp /usr/local/share/icons/hicolor/48x48/apps/chrome.png ~/icons/chrome.png
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

# 11-1.mozcのインストールと初期設定 *初期設定のみ
cp -r ./.uim.d-mozc/customs/custom-mozc.scm ~/.uim.d/customs/
mkdir ~/.mozc
/usr/local/bin/xxd -r -p ./.mozc/config1.bin > ~/.mozc/config1.db

# 8-14.サムネイル一覧から画像を選択して表示したい (nsxiv)
pkg install -y -q xsxiv
chmod +x ~/.config/nsxiv/exec/image-info
chmod +x ~/.config/nsxiv/exec/key-handler

# 12-6.外付けHDDに、ファイル・ディレクトリを指定してバックアップを取りたい
cp ./.backup_config ~
cp ./.backup_exclude_config ~

# 9-13.GTK系アプリのデフォルトフォントを変更したい
cp ./.gtkrc-2.0 ~

# 9-14.フォントのアンチエイリアスをグレースケール方式にしたい(GTK2系)
cp ./.Xresources ~

# 8-18.閲覧専用でメーラーを使いたい
sudo pkg install -y -q sylpheed

# メッセージ本文以外のフォントを変更したい
cp -r ./.sylpheed-2.0 ~

# bin
cp -r ./bin ~

# 各アプリインストール
sudo pkg install -y -q gimp
sudo pkg install -y -q qgis open-sans
sudo pkg install -y -q openscad
sudo pkg install -y -q freerdp
sudo pkg install -y -q tigervnc-viewer

# サンプルファイル
cp line.csv point.csv ant_tower.scad ~

# 5-8.再起動時に/tmpフォルダーをクリアーしたい
sudo sysrc clear_tmp_enable="YES"

# 7-3.Windowsやmacとファイル共有したい(SMB)
sudo pkg install -y -q samba419
sudo service samba_server enable
mkdir ~/share
sudo cp etc_smb4.conf /usr/local/etc/smb4.conf
sudo pdbedit -a -u pcuser
