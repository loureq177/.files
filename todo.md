# Todo hyprland + AGS + nvim

Całościowy zamysł tej listy to:

- Stworzenie "Perfect Developer Experience": zorientowane na klawiaturę, ale
  piękne i w pełni używalne myszką (hybryda Omnibara i elementów z macOS/GNOME).
- Dostosowanie Hyprland pod świetny UI/UX, blazingly-fast, z wykorzystaniem AGS
  do zbudowania spójnego środowiska.

## High prio - Hyprland, Terminal i Reszta

- [ ] skonfigurować satty pod zrzuty ekranu
- [ ] ~/Dev/repos/FreshArchLinux/fresh_archlinux.sh: zmienić log messages na
      angielskie
- [ ] FreshArch: przerobić pod kompatybilność z hyprland (teraz jest pod gnome)
- [ ] otierają mi się 2 nautilusy zamiast jeden
- [ ] czy nie brakuje mi w configu jakichś podstawowych rzeczy z których
      korzysta społeczność hyprland?
- [ ] dodać brakujące config files (na pewno coś jeszcze, pewnie w ~/.config)
- [ ] dodać jakiś fajny dźwięk powiadomień do mako
- [ ] okno discorda nie chce się otworzyć w poprawnym rozmiarze (miało być 90%
      wielkości)
- [ ] nvim: mój skrypt z macierzą nakłada się np na fzf-lua albo otwarty plik
      jak zdążę szybko wejść. nie powinno tak być, a jak dam szybko ":" to się
      pauzuje póki nie wyjdę przez esc
- [ ] dodać jakiś sensowny skrót na spotify?
- [ ] nie tak chciałem żeby działał special workspace chyba. co prawda spotify i
      discord otwierają się w special workspace, ale myślałem że mogę drugi raz
      kliknąć skrót na discord albo spotify i że mnie przerzuci do niego, albo
      że skoro wrzuca mnie w special workspace, to żeby je chować jakimś jednym
      skrótem (nie wiem co lepsze)
- [ ] swayosd: dalej ma laga gdy pierwszy raz od jakiegoś czasu klikam, ale
      teraz też pokazuje niepotrzebnie info o caps locku wciśniętym, a ja mam go
      przecież przemapowanego na escape (ostatnie rozwiązanie nie pomogło)
- [ ] przycisk do zamykania powiadomień
- [ ] czy waybar oferuje integrację z mako coś ala notification center jak w
      gnome? gdzie podejrzeć powiadomienia?
- [ ] calculator musi być floating XD
- [ ] dalej wiesza mi się kursor myszy i widzę go cały czas martwego zaraz po
      otwarciu (prawy dolny róg)
- [ ] hyprlock: waybar też na zablokowanym?
- [ ] hyprlock: pozbyć się "en" napisu

## Low prio - Hyprland, Terminal i Reszta

- [ ] odinstalować gnome po przesiadce :D
- [ ] znaleźć i wywalić backupy (z poziomu root dir)
- [ ] hypr: czy przesiąść się z GDM na coś bardziej hyprlandowego
- [ ] hypr: dodać jakieś settings z wellbeing (usage codziennie + tygodniowo jak
- [ ] czy potrzebny mi kdialog na hyprland?

## Not now - ultra low prio: Migracja na AGS (Budowa krok po kroku)

- [ ] **Faza 1: Środowisko AGS**
  - Stworzyć strukturę paczki w dotfiles (stow `ags`).
  - Zainicjować projekt (TypeScript, konfiguracja, Hello World widget).
- [ ] **Faza 2: Top Bar (Pasek informacyjny)**
  - Wyśrodkowany zegar (z formatowaniem daty).
  - Moduł Workspaces z Hyprland (wskazujący aktywny pulpit).
  - System Tray (ikonki działających aplikacji w tle).
  - Moduł baterii i podstawowych wskaźników (tylko odczyt, jako przygotowanie
    pod Quick Settings).
- [ ] **Faza 3: OSD (On-Screen Display)**
  - Eleganckie pop-upy (suwaki) pojawiające się na środku/dole ekranu przy
    zmianie głośności i jasności z klawiatury.
- [ ] **Faza 4: Omnibar (Zastępstwo Rofi)**
  - Wywoływany skrótem (np. `Super + Space`).
  - Centralne okno (z blurem), pozwalające na szukanie aplikacji.
  - Opcjonalnie w przyszłości: kalkulator, obsługa emoji, sterowanie systemem.
- [ ] **Faza 5: Control Center (Quick Settings)**
  - Rozwijany panel (wywoływany kliknięciem w ikonę sieci/baterii na pasku lub
    skrótem klawiszowym).
  - Przyciski i listy do zarządzania Wi-Fi i Bluetooth.

- [ ] **Faza 6: Dashboard (Powiadomienia i Kalendarz)**
  - Wywoływany kliknięciem w zegar lub skrótem klawiszowym (np. `Super + D`).
  - Podpięcie daemona powiadomień pod AGS (z poprawnym znikaniem po czasie).
  - Widok historii powiadomień i estetyczny kalendarz.

### Done

- [x] zen-browser: essential tabs powinny się otwierać on startup (nie wiem czy
- [x] waybar: nazwę okna i wrzucić date and time na środek
- [x] waybar: ikonka wifi. Jak najedziesz to pokazuje pełną nazwę połączonej
      sieci, a jak klikniesz to otwiera ghostty -e impala
- [x] nvim: robi mi newline w plikach markdown bez powodu, chyba mam coś źle
- [x] nvim: dorzucić skrót do wychodzenia (ctrl + S zapisuje, to może ctrl+q
      wychodzi? nie wiem czy nie będzie kolizji)
- [x] hypr: zrobić ten special workspace z default lua config (ma być na
      super+S, jest konflikt z obecnym swapem horizontal/vertical, które powinno
      być też z default skrótu, ale nie wiem jaki to) w GNOME)
- [x] hypr: chcę żeby wciśnięcie skrótu super + B nie powodowało otwarcia nowego
      okna przeglądarki, tylko przerzucenia do istniejącego (jak nie ma, to
      tworzy nowe)
- [x] hypr: dodać skrót na otwarcie spotify i discord (do ustalenia, ale na
      pewno super + coś)
- [x] zastąpić w ghostty skróty alt+h/l na skakanie po splitach, bo to mi
      koliduje z fzf-lua w lazyvim i też nie jest spójne z poruszaniem się po
      hyprland
- [x] zamienić w conifigu alt i super
- [x] dodać hyprlock + hypridle? (czy może to można zrobić przez )
- [x] rozbić config na mniejsze pliki (z głową)
- [x] mako default timeout z 5000 na 5? (autostart)
- [x] wifi: rozwiązać błędy przy otwieraniu impali (jakiś błąd z D-Bus) -
      przesunąłem dbus-update na sam szczyt autostartu
- [x] opencode: dodać config i pozwolić na bezpieczne komendy (czytanie plików,
      git status, git diff, no ogólnie te bezpieczne)
- [x] nvim: markdown files długo się otwierają, miesza się newline z word wrap i
      wygląda to okropnie, oraz chcę wyłączyć całkowicie w .md oraz .txt
      spellchecker
- [x] hyprlock nie blokuje systemu po suspendzie? a po czym blokuje? ma po
      restart, suspend i poweroff - dodano hypridle z configiem, który
      triggeruje hyprlock
- [x] zapisywać screenshoty w ~/Pictures/Screenshots/
- [x] wyłączyć spellchecker w plikach markdown i txt (miało już działać i dalej
      jest jak było)
- [x] nvim: word wrap nie działa dobrze z auto newline na 80 znakach (nakładają
      się te funkcje i tekst przeskakuje w głupi sposób)
- [x] discord i spotify ma się otwierać domyślnie w floating special workspace
- [x] czemu jak wpisuję `hyprctl systeminfo` to ekran na chwilę staje się
      ciemniejszy?
- [x] topbar: po lewej od workspaces nazwa okna na który jest focus (max 40
      znaków i potem 3 kropki, a po najechaniu pełna nazwa okna i po kliknięciu
      skopiowanie tego do schowka)
- [x] clipboard: ogarnąć sobie jakiś clipboard manager (na wzór clipboard
      indicator z gnome lub ten z maca. ma móc trzymać też zrzuty ekranu
      oczywiście i mieć ich preview)
- [x] special workspace miał być floating. poza tym ja chyba nie wiem jak on
      działa. myślałem, że special workspace przenosi okno na które aktualnie
      jest focus do special workspace
- [x] ghostty: alt+H koliduje z nvim fzf-lua (alt+H to toggle hidden files,
      który potrzebuję używać)
- [x] topbar: dodać ikonkę głośnika (poziom procentowy) i mikrofonu (muted czy
      nie ikonka skreślona lub nie, jak się da to niech jeszcze będzie na
      czerwono jak jest w użyciu!)
- [x] poprawić wygląd rofi (jakiś popularny theme z githuba może?)
- [x] schować opcję minimize i tą drugą (zostawić tylko exit) w ustawieniach
      okien GTK/QT (bo i tak w hyprland one nic nie robią?) (prawy górny róg)
- [x] hyprlock: suspend nie powoduje blokady.
- [x] hyprlock: poprawić wygląd (godzina mniejsza, na środku, grubszy font)
- [x] nvim: zmienić defaults w fzf-lua żeby szukał też ignorowanych przez gita
      plikóœ i pokazywał ukryte by default
- [x] hypr: discord i spotify w special workspace chciałem żeby otwierał się na
      środku i żeby jego wielkość okna stanowiła 90% wielkości normalnego
      maximized okna (nie full screen, maximized)
- [x] ogarnąć żeby działała historia schowka (też niech trzyma je persistent,
      żeby nie znikały po restarcie) cliphist hyprland - nie wiem czemu
- [x] hypr: autostart.lua pozwala na silent errors, co mi się bardzo nie podoba
- [x] waybar: dodać indicator który włącza się tak jak na macu gdy kamera jest w
      użyciu (kolor nie wiem czy zielony czy żółty. tak jak na nowym macos bym
      chciał)
