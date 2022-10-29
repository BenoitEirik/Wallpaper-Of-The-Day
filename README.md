# Wallpaper Of The Day
This script automates changing the desktop wallpaper & the lockscreen wallpaper each day at login.
The wallpapers are from Microsoft's [Bing](https://www.bing.com/) search engine.

~The script is now unnecessary on Windows 11 as the functionality is natively included.~

## Installation
1. Download, extract the contents and navigate to the extracted folder.
2. Open a terminal with administrator rights in the extracted foler and run:  
`>  powershell -ExecutionPolicy bypass -File ".\wotd.ps1" -Setup install`  
Other parameters:  
`   -Dest "C:\Program Files\WOTD"` To set the installation folder. Make sure destination path is without spaces  
`   -Locale fr-FR` To set the language. See *Language selection* for more  
3. Delete the extracted foler.
4. Reboot your computer and the wallpaper gets automatically applied!

> NB: the script will search for the internet connection every 30 seconds for 5 minutes if it does not find it the first time. Beyond that it will stop.

## Uninstallation
1. Open a terminal with administrator rights and run with the right path file:  
`>  powershell -ExecutionPolicy bypass -File "C:\Program Files\WOTD\wotd.ps1" -Setup install` 
> NB: make sure not being in the folder where is wotd.ps1 

## Language selection
The wallpaper may be different depending on your country. You can choose the code corresponding to your language.
| Language | Code |
| - | - |
| auto | auto |
| ar-XA | (شبه الجزيرة العربية‎) العربية |
| da-DK | dansk (Danmark) |
| de-AT | Deutsch (Österreich) |
| de-CH | Deutsch (Schweiz) |
| de-DE | Deutsch (Deutschland) |
| en-AU | English (Australia) |
| en-CA | English (Canada) |
| en-GB | English (United Kingdom) |
| en-ID | English (Indonesia) |
| en-IE | English (Ireland) |
| en-IN | English (India) |
| en-MY | English (Malaysia) |
| en-NZ | English (New Zealand) |
| en-PH | English (Philippines) |
| en-SG | English (Singapore) |
| en-US | English (United States) |
| en-WW | English (International) |
| en-XA | English (Arabia) |
| en-ZA | English (South Africa) |
| es-AR | español (Argentina) |
| es-CL | español (Chile) |
| es-ES | español (España) |
| es-MX | español (México) |
| es-US | español (Estados Unidos) |
| es-XL | español (Latinoamérica) |
| et-EE | eesti (Eesti) |
| fi-FI | suomi (Suomi) |
| fr-BE | français (Belgique) |
| fr-CA | français (Canada) |
| fr-CH | français (Suisse) |
| fr-FR | français (France) |
| he-IL | (עברית (ישראל |
| hr-HR | hrvatski (Hrvatska) |
| hu-HU | magyar (Magyarország) |
| it-IT | italiano (Italia) |
| ja-JP | 日本語 (日本) |
| ko-KR | 한국어(대한민국) |
| lt-LT | lietuvių (Lietuva) |
| lv-LV | latviešu (Latvija) |
| nb-NO | norsk bokmål (Norge) |
| nl-BE | Nederlands (België) |
| nl-NL | Nederlands (Nederland) |
| pl-PL | polski (Polska) |
| pt-BR | português (Brasil) |
| pt-PT | português (Portugal) |
| ro-RO | română (România) |
| ru-RU | русский (Россия) |
| sk-SK | slovenčina (Slovensko) |
| sl-SL | slovenščina (Slovenija) |
| sv-SE | svenska (Sverige) |
| th-TH | ไทย (ไทย) |
| tr-TR | Türkçe (Türkiye) |
| uk-UA | українська (Україна) |
| zh-CN | 中文（中国） |
| zh-HK | 中文（中國香港特別行政區） |
| zh-TW | 中文（台灣） |
