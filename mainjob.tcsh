#!/bin/tcsh -f

set dt = `date '+%Y-%m-%d %H:%M:%S'`
echo "main job start. ${dt}"

# 実処理
sleep 10

if ($status != 0) then
    # 異常終了
    touch /home/pcuser/job/mainjob.abn
    set dt = `date '+%Y-%m-%d %H:%M:%S'`
    echo "main job abnormal end. ${dt}"
else
    # 前処理終了ファイルを消す
    rm -f /home/pcuser/job/frontjob.end

    # 正常終了
    touch /home/pcuser/job/mainjob.end
    set dt = `date '+%Y-%m-%d %H:%M:%S'`
    echo "main job end. ${dt}"
endif
