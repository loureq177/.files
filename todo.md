# Todo .files

- [ ] hypr: dodać jakieś window overview?
- [ ] hypr: czy przesiąść się z czystego TTY na coś bardziej hyprlandowego
- [ ] hypr: ogarnąć sobie jakieś wellbeing (usage statistics dziennie/ tygodniowo) coś jak to co dodali w gnome settings
- [ ] hypr: chcę żeby wciśnięcie skrótu super + B nie powodowało otwarcia nowego
okna przeglądarki, tylko przerzucenia do istniejącego (jak nie ma, to
tworzy nowe). koniecznie korzystając z nowego API hyprlanda w LUA (masz dostęp do LSP? odpowiedz)
- [ ] pytanie: czy powinienem móc wyjść ze special workspace (super + SHIFT + S)? bo nie mogę aktualnie (duży problem)
- [ ] skonfigurować satty pod zrzuty ekranu?
- [ ] ~/Dev/repos/FreshArchLinux/fresh_archlinux.sh: zmienić wszystkie log messages na angielskie
- [ ] FreshArch: przerobić pod kompatybilność z hyprland (teraz jest pod gnome)
- [ ] dodać jakiś fajny dźwięk powiadomień do mako
- [ ] nvim: mój skrypt z macierzą nakłada się np na fzf-lua albo otwarty plik
      jak zdążę szybko wejść. nie powinno tak być, a jak dam szybko ":" to się
      pauzuje póki nie wyjdę przez esc
- [ ] swayosd: ma laga gdy pierwszy raz od jakiegoś czasu klikam
- [ ] swayosd: pokazuje niepotrzebnie info o caps locku wciśniętym, a ja mam go
      przecież przemapowanego na escape
- [ ] mako: dodać przycisk do zamykania powiadomień
- [ ] zen-browser: essential tabs powinny się otwierać on startup (jest na to jakaś zmienna w user.js)
- [ ] wifi: jest błąd przy pierwszym otwieraniu impali po restarcie: Can not access the iwd service: No adapter found. wtedy też rozłącza mi wifi na chwilę i przywraca.
przesunąłem dbus-update na sam szczyt autostartu
- [ ] hyprlock: nie blokuje systemu po suspendzie. ma po
      restart, suspend i poweroff - dodano hypridle z configiem, który
      triggeruje hyprlock
- [ ] hyprlock: dodać widoczność waybar na zablokowanym
- [ ] hyprlock: usunąć wyświetlanie języka (en)
- [ ] zapisywać screenshoty w ~/Pictures/Screenshots/
- [ ] waybar: ikonka głośnika niech włącza pwvucontrol --tab 4
- [ ] waybar: ikonka mikrofonu niech włącza pwvucontrol --tab 3

## Not now - ultra low prio: Migracja na AGS (Budowa krok po kroku)

Jak uda mi się doprowadzić workflow na obecnym configu do perfekcji,
to chcę zacząć przenosić się na AGS kopiując zachowanie dotychczasowej konfiguracji.
Te same skróty (chyba, że mogą być lepsze :D)

- [ ] **1: Środowisko AGS**
  - Stworzyć strukturę paczki w dotfiles (stow `ags`).
  - Zainicjować projekt (TypeScript, konfiguracja, Hello World widget).
- [ ] **2: Top Bar (Pasek informacyjny)**
  - Wyśrodkowany zegar (z formatowaniem daty).
  - Moduł Workspaces z Hyprland (wskazujący aktywny pulpit).
  - System Tray (ikonki działających aplikacji w tle).
  - Moduł baterii i podstawowych wskaźników (tylko odczyt, jako przygotowanie
    pod Quick Settings).
- [ ] **3: OSD (On-Screen Display)**
  - Eleganckie pop-upy (suwaki) pojawiające się na środku/dole ekranu przy
    zmianie głośności i jasności z klawiatury.
- [ ] **4: Omnibar (Zastępstwo Rofi)**
  - Centralne okno (z blurem), pozwalające na szukanie aplikacji.
  - Opcjonalnie w przyszłości: kalkulator, obsługa emoji, sterowanie systemem.
- [ ] **5: Control Center (Quick Settings)**
  - Rozwijany panel (wywoływany kliknięciem w ikonę sieci/baterii na pasku lub
    skrótem klawiszowym).
  - Przyciski i listy do zarządzania Wi-Fi i Bluetooth.

- [ ] **6: Dashboard (Powiadomienia i Kalendarz)**
  - Wywoływany kliknięciem w zegar lub skrótem klawiszowym (np. `Super + D`).
  - Podpięcie daemona powiadomień pod AGS (z poprawnym znikaniem po czasie).
  - Widok historii powiadomień i estetyczny kalendarz.

