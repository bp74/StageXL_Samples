FOR %%G IN (*.png) DO cwebp.exe "%%G" -m 6 -q 100 -lossless -o "%%~nG.webp"
FOR %%G IN (*.jpg) DO cwebp.exe "%%G" -m 6 -q 80 -o "%%~nG.webp"

cwebp.exe walk.png -m 6 -q 80 -alpha_q 100 -o walk.webp
