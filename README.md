# DPI Bypass (macOS)

macOS icin tek tiklamayla acilip kapanan DPI (Deep Packet Inspection) engel asma kurulumu.
Arka planda [SpoofDPI](https://github.com/xvzc/SpoofDPI) calisir, sistem proxy'si otomatik ayarlanir,
durumu bir menu/uygulama penceresinden gorursun.

> Amac: ISP seviyesindeki sansuru asip engellenen sitelere (ornegin Discord) erisim.
> Trafigi baska bir sunucuya yollamaz, VPN degildir — sadece TLS ClientHello paketini
> bolerek DPI'in domain'i okumasini engeller.

## Ne yapiyor

- `spoofdpi` 127.0.0.1:8080'de HTTP/HTTPS proxy olarak calisir (LaunchAgent, `KeepAlive`)
- HTTPS ClientHello rastgele noktadan parcalanir (`--https-split-mode random --https-chunk-size 2`)
- DNS, DoH uzerinden cozulur (`https://1.1.1.1/dns-query`) — DNS bazli engeller de asilir
- Wi-Fi servisinin web/secure-web proxy'si ve `HTTPS_PROXY`/`HTTP_PROXY` env degiskenleri set edilir
- `DPI Bypass.app`: durum gosterir, canli test yapar (discord.com -> HTTP 200), tek tikla ac/kapa

## Kurulum

```bash
brew install spoofdpi          # veya https://github.com/xvzc/SpoofDPI
git clone https://github.com/Lng999/dpi-bypass-macos.git
cd dpi-bypass-macos
./install.sh
```

`~/.local/bin` PATH'te degilse:

```bash
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.zshrc
```

## Kullanim

```bash
dpi-bypass on        # ac
dpi-bypass off       # kapat
dpi-bypass status    # durum + canli test
dpi-bypass-toggle    # ac/kapa (Raycast, Shortcuts, Stream Deck icin)
dpi-bypass-check     # "ACIK|200" seklinde makine-okur cikti
```

Ya da `/Applications/DPI Bypass.app` — simgeye tikla, durumu gor, butondan ac/kapa.

## Dosyalar

| Yol | Ne |
|---|---|
| `bin/dpi-bypass` | ana ac/kapa/durum scripti |
| `bin/dpi-bypass-toggle` | tek komutla ac/kapa |
| `bin/dpi-bypass-check` | durum + test ciktisi (`ACIK\|200`) |
| `launchagents/com.lng999.spoofdpi.plist` | spoofdpi'yi arka planda tutar |
| `launchagents/com.lng999.proxyenv.plist` | proxy env degiskenlerini set eder |
| `app/DPI Bypass.applescript` | GUI applet kaynagi |

## Notlar

- Ag servisi olarak `Wi-Fi` varsayilir. Ethernet kullaniyorsan scriptlerdeki `SVC="Wi-Fi"` satirini degistir.
- Canli test hedefi `discord.com`. Baska site test etmek istersen scriptlerde degistir.
- Proxy'yi kapatmadan Wi-Fi degistirirsen internet gitmis gibi gorunebilir — `dpi-bypass off` cozer.
- Bazi siteler parcalanmis ClientHello'ya cevap vermez (ornegin Istanbul Universitesi AKSIS).
  Bunlar proxy'yi atlar: `bin/dpi-bypass` icindeki `BYPASS` listesi (sistem proxy istisnalari)
  ve `com.lng999.proxyenv.plist` icindeki `NO_PROXY`. Yeni site eklemek icin ikisine de ekle.
- Loglar: `~/Library/Logs/spoofdpi.log`

## Kaldirma

```bash
./uninstall.sh
```

## Lisans

MIT
