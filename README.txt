# FreeBSD 14.3 の設定ファイル

※デフォルトの端末エミュレータを mlterm から xfce4-terminal に変更します。

FreeBSD 14.3 インストール＆活用ガイド 2026-02-04 第11版 に対応
https://moginwc.sakura.ne.jp/FreeBSD143InstallGuide.pdf

インストールをお急ぎの方は、下記を実行してください。

【注意】
以下のシェルスクリプトは、
　①インテル内蔵GPU、
　②英語キーボード、
　③ネットワークインターフェース名em0
が前提となります。

ステップ１．FreeBSD 14.3 インストール＆活用ガイド 2026-02-04 第11版 の
　　　　　　36〜86ページ（sudoを設定するまで）を実行する。
ステップ２．# pkg install -y git を実行する。
ステップ３，# exit でログアウトする。
ステップ４．pcuser でログインする。
ステップ５．% git clone https://github.com/moginwc/freebsd143 を実行する。
ステップ６．% cd freebsd143
ステップ７．% tcsh -x ./install.tcsh
　　　　　　(sudoのパスワード入力、および最後にファイル共有smbのパスワード入力があります)
ステップ８．% sudo shutdown -r now
ステップ９．171ページ以降を参照。

--------

Wineのインストールをお急ぎの方は、引き続き下記を実行してください。

ステップ１．pcuser でログインする。（以下、ウインドウ環境下での操作を前提とします）
ステップ２．% cd freebsd143
ステップ３．% tcsh -x ./install_wine.tcsh
　　　　　　（秀丸エディタ、WinMerge、Binary Editor BZもインストールされます。
　　　　　　　途中、何かフォルダーのようなものが表示されますが、閉じてください）
ステップ４．いったんログアウトし、再度ログインする

[EOF]
