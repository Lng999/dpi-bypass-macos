set statusLine to do shell script "$HOME/.local/bin/dpi-bypass-check"
set sepPos to offset of "|" in statusLine
set stateName to text 1 thru (sepPos - 1) of statusLine
set codeText to text (sepPos + 1) thru -1 of statusLine

if stateName is "ACIK" and codeText is "200" then
	set answer to button returned of (display dialog "DURUM: ÇALIŞIYOR" & return & return & "Engel aşma aktif." & return & "Canlı test: discord.com → HTTP 200" & return & return & "Discord'u açabilirsin." buttons {"Kapat", "Tamam"} default button "Tamam" with title "DPI Bypass" with icon note)
	if answer is "Kapat" then
		do shell script "$HOME/.local/bin/dpi-bypass off"
		display dialog "DPI Bypass kapatıldı." & return & return & "Yeniden açmak için simgeye tekrar tıkla." buttons {"Tamam"} default button 1 with title "DPI Bypass" with icon stop
	end if
	
else if stateName is "ACIK" then
	set answer to button returned of (display dialog "DURUM: SORUNLU" & return & return & "Servis çalışıyor ama test başarısız." & return & "discord.com → HTTP " & codeText & return & return & "Engelleme yöntemi değişmiş olabilir." buttons {"Yeniden Başlat", "Tamam"} default button "Yeniden Başlat" with title "DPI Bypass" with icon caution)
	if answer is "Yeniden Başlat" then
		do shell script "$HOME/.local/bin/dpi-bypass off; sleep 1; $HOME/.local/bin/dpi-bypass on"
		delay 3
		set afterRestart to do shell script "$HOME/.local/bin/dpi-bypass-check"
		display dialog "Yeniden başlatıldı." & return & return & "Yeni durum: " & afterRestart buttons {"Tamam"} default button 1 with title "DPI Bypass" with icon note
	end if
	
else
	set answer to button returned of (display dialog "DURUM: KAPALI" & return & return & "Engel aşma çalışmıyor." & return & "Discord ve engelli siteler açılmaz." buttons {"Aç", "Tamam"} default button "Aç" with title "DPI Bypass" with icon stop)
	if answer is "Aç" then
		do shell script "$HOME/.local/bin/dpi-bypass on"
		delay 3
		set afterOpen to do shell script "$HOME/.local/bin/dpi-bypass-check"
		if afterOpen ends with "|200" then
			display dialog "AÇILDI" & return & return & "Canlı test: discord.com → HTTP 200" & return & "Discord'u açabilirsin." buttons {"Tamam"} default button 1 with title "DPI Bypass" with icon note
		else
			display dialog "Açıldı ama test başarısız." & return & return & "Sonuç: " & afterOpen buttons {"Tamam"} default button 1 with title "DPI Bypass" with icon caution
		end if
	end if
end if

