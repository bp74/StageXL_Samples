FOR %%G IN (*.png) DO C:\Tools\libwebp\bin\cwebp.exe "%%G" -m 6 -q 100 -lossless -o "%%~nG.webp"
FOR %%G IN (*.jpg) DO C:\Tools\libwebp\bin\cwebp.exe "%%G" -m 6 -q 80 -o "%%~nG.webp"
