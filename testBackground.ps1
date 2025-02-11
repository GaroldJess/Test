$imagePath = "C:\Wallpaper\come_follow_me.jpeg"
reg add "HKEY_CURRENT_USER\Control Panel\Desktop" /v Wallpaper /t REG_SZ /d $imagePath /f
rundll32.exe user32.dll, UpdatePerUserSystemParameters