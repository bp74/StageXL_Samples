FOR /R %1 %%G IN (*.wav) DO c:\tools\audio\lame.exe -q 0 --tt "StageXL Escape" "%%G"
FOR /R %1 %%G IN (*.wav) DO c:\tools\audio\oggenc2.exe -q 6 "%%G"
