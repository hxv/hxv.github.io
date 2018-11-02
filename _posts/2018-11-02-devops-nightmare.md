---
layout: post
title: "DevOps Nightmare writeup"
author: "Michał Włodarczyk"
---

# Intro
Unknow opublikował niedawno grę w postaci [obrazu dockera](https://hub.docker.com/r/unknow/devops_nightmare/). W poniższym poście prezentuję możliwe rozwiązania dla wszystkich zadań, więc w pierwszej kolejności polecam samodzielnie spróbować swoich sił :)

Po uruchomieniu dostajemy instrukcję co mamy zrobić:
```
 hxv@laptoppp  ~ 
$ docker run --rm -ti unknow/devops_nightmare

===============================================================
DevOps Nightmare v0.1
Author: Jakub 'unknow' Mrugalski

LET'S PLAY A LITTLE GAME...

You just woke up in strange place.
You are inside some kind of well designed container.
But everything is really strange here...

Somebody who put you here, left few task for you.
They are written in /tasks.txt

But... how to read them?

Rules:
1) you have to do EVERY task from INSIDE of this container
2) do NOT install/upload any external tools
3) every task is doable - try google for solutions
4) have fun!

===============================================================
```
Zaczynamy od czegoś prostego, czyli odczytania pliku. Ale niestety, w naszej krótkiej przygodzie nic nie jest proste:
```
[NIGHTMARE] / # cat tasks.txt 
bash: cat: command not found
```
Brakuje polecenia `cat`, czyli musimy zacząć nasze kombinowanie. Używamy pętli w bashu:
```
[NIGHTMARE] / # while read line; do echo "$line"; done < tasks.txt 

//////////////////////////////////
Hello my friend...

I have to ask you for a favor. This container is haunted.
I need to find the ghost of this container before it's too late!

Our ghost did some strange modifications to this system.
Lot of tools are missing. And some tools are not working as expected.

I have prepared few tasks for you that should help you with
this ghost hunting. Please follow them really carefully and
always execute them in right order!

If you change the order, then whole ritual of evoking the spirit
will be useless!

>>> TASKS <<<

1) First, please open a special gate for the ghost. To do this,
just create empty directory called /gate/. After that,
just take a look what is inside.
2) I have prepared something cool, just for you, but... it is sliced.
You have to put it together. This tool is here: /var/box/
3) What to do next? http://mrugalski.pl/nightmare.txt [read note from container!]
4) Another gift for you: /usr/share/secret/
5) Find file called HAKUNAMATATA.txt - there is task inside!
6) Just find the ghost...

When you catch the ghost, the game is over.

Good luck!

// Mad DevOp

//////////////////////////////////
```
Mamy listę zadań, więc możemy zabrać się za ich rozwiązywanie.

# Zadanie pierwsze
Pierwszym zadaniem jest stworzenie pustego katalogu `/gate`. Polecenia `mkdir` oczywiście nie ma. Możemy spróbować skopiować pusty katalog (np. `/tmp`):
```
[NIGHTMARE] / # cp -r /tmp /gate
are you afraid of ghosts? -r /tmp /gate
```
Hmm, co się stało? `cp` nie działa tak, jakbyśmy chcieli. Przy wywołaniu `/bin/cp` niby wszystko jest OK:
```
[NIGHTMARE] / # /bin/cp
cp: missing file operand
Try '/bin/cp --help' for more information.
```
Czyli albo gdzieś 'wyżej' w `$PATH` znajduje się inny program który nazywa się `cp`, albo stworzony jest alias:
```
[NIGHTMARE] / # alias
alias cp='echo '\''are you afraid of ghosts?'\'''
alias ls='/bin/ls --color'
```
Aby zamiast aliasu uruchomić polecenie możemy użyć albo bezpośredniej ścieżki, albo dodać `\` na początek:
```
[NIGHTMARE] / # \cp -r /tmp/ /gate
[NIGHTMARE] / # ls /gate/
message.ghost
```
Teraz przydało by się sprawdzić, co jest w pliku. Możemy drugi raz użyć pętli - albo od razu stworzyć dla niej alias:
```
[NIGHTMARE] / # alias cat='while read line; do echo "$line"; done < '
[NIGHTMARE] / # cat /gate/message.ghost 
You are inside haunted container.
You are not alone!
Try to find me, or... I will find YOU
```

# Zadanie drugie
Drugie zadanie jest pocięte - musimy je poskładać. Fragmenty znajdują się w `/var/box`, sprawdźmy:
```
[NIGHTMARE] / # ls /var/box/
something_aa  something_ab  something_ac  something_ad
[NIGHTMARE] / # cat /var/box/something_aa 
ELF>"@ @@@@@
           v
            v zz z (     || | PPtd$f$f$fQtdRtdzz z HH/lib/ld-musl-x86_64.so.1>` XAH(BE|PvbAqX8,cr
BYlibc.musl-x86_64.so.1vfprintfiswprintstderrcalloc__stack_chk_fail_initmemsetmallocstpcpyfcntlprogram_invocation_name__ctype_get_mb_cur_maxwrite__errno_locationatexitposix_fadvisememmovegetpagesize_exitgetenvreadfdopen__fpendingfputs_unlocked_finiungetclseeknl_langinfofscanfmemcmpputc_unlockedmbrtowcferror_unlockedmemcpystrerror_rstrchrgetc_unlockedfstatioctlprogram_invocation_short_namefflush_unlocked__cxa_finalizefputcfputsstdoutstrncmpreallocstrcmpsetlocalefilenofreestrcpyfclosembsinitstrrchr__libc_start_mainabort__progname__progname_full_edata__bss_start_end__deregister_frame_info_ITM_registerTMCloneTable_ITM_deregisterTMCloneTable_Jv_RegisterClasses__register_frame_infoz^{ 
_ {_@{_`{0_{:_{D_{M_{R_ |_(|_0|_8|_@|_H|`P|     `X|_`|`h|`~  ^(^0S]8!^@7^HA^PP^XA^`Z^hA^pd^xA^  Z_ 0 8  ~~ ~ ~  ~ (~ 0~ 8~@~    H~ 
P~ 
   X~ 
2CX5g %g @%g f%g f%g f%g f%g f%g f%g f%g f%g f%g f%g f%g f%g f%g f%g f%g f%g f%g f%g f%h f%h f%h f%h f%h f%h f%h f%h f%h f%h f%
h f%
h f%
h f%
h f%
h f%
h f%h f%h f%h f%h f%h f%h f%h f%h f%h f%h f%h f%h f%h f%h f%h f%h f%h f%h f%h f%h f%h f%h f%h fAWAVAUATUSHHHt$@|$HdH%(H$81NHD$@H8kH5QIH=A
EELREHDH5.@1(1U1~驃EtTD$딃st$et;n}ut|vtkD$MaD$D$RD$D$D$L>H=gc H
g HFHc@HD$H$HTHL$8HD$XH$HD$`$%$D$HH9ѺHc
                                 D$L9L$HD$N$HIHg ~HD$@HL$8HHg L%g H5ILug D$N11Lug T=ig H$(y,HUg 1#HHHD0L$H=g IH9¸LG11
                                                                                                                     $uiHD$XH;$uZHD$`H;$uK=f 1BH;$}/Hf 1T"HMCH1111`*<$Dl$D
l$D
l$ML9tHD$LCtL`K<&s'IHD$(1LHt$I)ԋ="f LL#HIu2H
                                            f 1!IW0HYCL11)7Ht/HL
I9t!0H =1)AD!RHD$J<0&HLHD$(HD$HJ<&HD$PHD$1D-[e Ƅ$HHHD$PLHL$(LHt$HI)1Ht$HDL$LHD$hD$OH)LyHL$ HL$0$H$HD$pH$HD$xHD$hH9$MHTLοL$      H9DL$t0H<1g(LLH$L)H9LvHLLH$H$LH$L;|$0X$Ǆ$HT$x=d 1*yji8_tX_8tNU8tDK8t:A8&t0H5c I#0H@L11'oƄ$$Ht$ =c L{ HuKHvc 1!I0H@1L1''H$LD-.c 17Hu$LD-c HD$ L|$ HD$0
H|$P!AE~TAt|$MtIOAAtA$t(|$t!H5[a H$H$|$LtH$HPH$$H$HPH$
AIO
I_AxF|$t?$H$(H5` H$$H$H$|$y@t$~H$wHxH$tLHxH$MH$HxH$-H$vDtHx  H$HPH$^H$HPH$?Hx@H$^H$HxH$^        u@tH$HPH$       =
AH$@HxH$^H$HxH$HQ|$t9H$HPH$^H$HPH$IHQ   t
[ E1H=y#0H<1#H$8dH3%(@t'Ht$pLHH[]AA]A^A_H1HH5Y HHH7L6H
H=~^ H~^ UH)HHvH; Ht]]H=R^ H5K^ UH)HHHHHHtHH[ Ht]]À=c^ uzH=![ UHATSt
                                                                    H= 
                                                                       HeW HfW H)IHHH*^ H9vHH/ # 
```
Pierwsze znaki w pliku to `ELF`, więc pewnie mamy do czynienia z plikiem wykonywalnym. Zakładam, że kolejne części znajdują się w plikach `something_aa`, `something_ab`, `something_ac` i `something_ad`. Trzeba je jakoś złożyć do kupy. Sprawdźmy, jakie programy mamy do wyboru:
```
[NIGHTMARE] / # ls /bin/
bash  chmod  cp  dd  ls  rm  sh  sleep
```
`dd` powinno się nadać. Po [chwili wyszukiwania](https://unix.stackexchange.com/a/280526) możemy połączyć pliki:
```
[NIGHTMARE] / # dd if=/var/box/something_aa of=/tmp/box
20+0 records in
20+0 records out
10240 bytes (10 kB, 10 KiB) copied, 0.000558035 s, 18.4 MB/s
[NIGHTMARE] / # dd if=/var/box/something_ab of=/tmp/box oflag=append conv=notrunc
20+0 records in
20+0 records out
10240 bytes (10 kB, 10 KiB) copied, 0.000385591 s, 26.6 MB/s
[NIGHTMARE] / # dd if=/var/box/something_ac of=/tmp/box oflag=append conv=notrunc
20+0 records in
20+0 records out
10240 bytes (10 kB, 10 KiB) copied, 0.000393658 s, 26.0 MB/s
[NIGHTMARE] / # dd if=/var/box/something_ad of=/tmp/box oflag=append conv=notrunc
8+1 records in
8+1 records out
4128 bytes (4.1 kB, 4.0 KiB) copied, 0.000250886 s, 16.5 MB/s
```
Żeby uruchomić polecenie trzeba jeszcze dodać uprawnienia do wykonywania:
```
[NIGHTMARE] / # chmod +x /tmp/box 
bash: /bin/chmod: Permission denied
```
...

Spróbujmy inaczej - skopiujemy plik z uprawnieniami do wykonywania i nadpiszemy jego zawartość:
```
[NIGHTMARE] / # \cp --preserve=mode /bin/cp /tmp/box
[NIGHTMARE] / # dd if=/var/box/something_aa of=/tmp/box
20+0 records in
20+0 records out
10240 bytes (10 kB, 10 KiB) copied, 0.000558035 s, 18.4 MB/s
[NIGHTMARE] / # dd if=/var/box/something_ab of=/tmp/box oflag=append conv=notrunc
20+0 records in
20+0 records out
10240 bytes (10 kB, 10 KiB) copied, 0.000385591 s, 26.6 MB/s
[NIGHTMARE] / # dd if=/var/box/something_ac of=/tmp/box oflag=append conv=notrunc
20+0 records in
20+0 records out
10240 bytes (10 kB, 10 KiB) copied, 0.000393658 s, 26.0 MB/s
[NIGHTMARE] / # dd if=/var/box/something_ad of=/tmp/box oflag=append conv=notrunc
8+1 records in
8+1 records out
4128 bytes (4.1 kB, 4.0 KiB) copied, 0.000250886 s, 16.5 MB/s
```
Sprawdźmy, co robi program:
```
[NIGHTMARE] / # /tmp/box 
^C
[NIGHTMARE] / # /tmp/box --help
Usage: /tmp/box [OPTION]... [FILE]...
Concatenate FILE(s) to standard output.

With no FILE, or when FILE is -, read standard input.

  -A, --show-all           equivalent to -vET
  -b, --number-nonblank    number nonempty output lines, overrides -n
  -e                       equivalent to -vE
  -E, --show-ends          display $ at end of each line
  -n, --number             number all output lines
  -s, --squeeze-blank      suppress repeated empty output lines
  -t                       equivalent to -vT
  -T, --show-tabs          display TAB characters as ^I
  -u                       (ignored)
  -v, --show-nonprinting   use ^ and M- notation, except for LFD and TAB
      --help     display this help and exit
      --version  output version information and exit

Examples:
  /tmp/box f - g  Output f's contents, then standard input, then g's contents.
  /tmp/box        Copy standard input to standard output.

GNU coreutils online help: <http://www.gnu.org/software/coreutils/>
Report cat translation bugs to <http://translationproject.org/team/>
Full documentation at: <http://www.gnu.org/software/coreutils/cat>
or available locally via: info '(coreutils) cat invocation'
```
Dostaliśmy w prezencie `cat`. Przydałby się wcześniej :)

# Zadanie trzecie
W pliku pod adresem `http://mrugalski.pl/nightmare.txt` znajduje się:
```

/usr/bin/whatever SWAB CONVERT

```
Ścieżka do pliku i "SWAB CONVERT". Próbujemy wykonać polecenie:
```
[NIGHTMARE] / # /usr/bin/whatever
bash: /usr/bin/whatever: cannot execute binary file: Exec format error
```
Coś jest nie tak. Jeśli wyświetlimy zawartość pliku możemy zobaczyć:
```
[NIGHTMARE] / # cat /usr/bin/whatever
EFL>=Q@#@@@@ll !!6(   ! !`Pdt
,
V7/ dGA8< {wq+   q&j>+H[" q2N, V~`AvrjM%(l/bil/-dumlsx-686_.4os1.MШ(I@MOTEB|tYqXUgam;+
Cz      O
[...]
```
`EFL` zamiast `ELF`. Czyli coś jest zamienione... Czyżby zamiast "SWAB" chodziło o "swap"? Kolejne [szybkie wyszukiwanie](https://www.mkssoftware.com/docs/man1/dd.1.asp) i dowiadujemy się, że `dd` posiada opcję `conv=swab`:
```
[NIGHTMARE] / # \cp --preserve=mode /usr/bin/whatever /tmp/
[NIGHTMARE] / # dd if=/usr/bin/whatever of=/tmp/whatever conv=swab
276+1 records in
276+1 records out
141728 bytes (142 kB, 138 KiB) copied, 0.00411388 s, 34.5 MB/s
[NIGHTMARE] / # /tmp/whatever 
Missing filename ("less --help" for help)
```
Dostaliśmy `less`!

# Zadanie czwarte
Kolejny prezent znajduje się w `/usr/share/secret`:
```
[NIGHTMARE] / # ls /usr/share/secret/
unpack  wtf.txt
[NIGHTMARE] / # cat /usr/share/secret/wtf.txt
Remove first 777 bytes from file
```
Po raz kolejny przyda się `dd`:
```
[NIGHTMARE] / # \cp --preserve=mode /bin/cp /tmp/unpack
[NIGHTMARE] / # dd if=/usr/share/secret/unpack of=/tmp/unpack bs=1 skip=777
68320+0 records in
68320+0 records out
68320 bytes (68 kB, 67 KiB) copied, 0.182438 s, 374 kB/s
[NIGHTMARE] / # /tmp/unpack
unpack: compressed data not written to a terminal. Use -f to force compression.
For help, type: unpack -h
```

# Zadanie piąte
Musimy zlokalizować i odczytać plik `HAKUNAMATATA.txt`. Nie wykorzystywaliśmy jeszcze polecenia `less` (zapisanego w `/tmp/whatever`), więc spróbujmy to zrobić przy jego pomocy:
```
[NIGHTMARE] / # ls -R / | /tmp/whatever # po uruchomieniu wpisujemy '/HAKUNA' żeby namierzyć plik, a następnie przeskakujemy w górę aż nie trafimy na nazwę katalogu
/lib/apk/db:
HAKUNAMATATA.txt
[...]
```
Sprawdźmy, co znajduje się w pliku:
```
[NIGHTMARE] / # cat /lib/apk/db/HAKUNAMATATA.txt 
[HAKUNAMATATA.txtR%
```
Hmm, `[` wygląda podejrzanie. Czy to na pewno wszystko?
```
[NIGHTMARE] / # /tmp/whatever /lib/apk/db/HAKUNAMATATA.txt
"/lib/apk/db/HAKUNAMATATA.txt" may be a binary file.  See it anyway?
^_<8B>^H^H<B4><E0><D2>[^@^CHAKUNAMATATA.txt^@<E3>R<B0>%
p)(x<95>^V<97>($^W<A5>&<96><A4>*<B8><FA>^F<84>D*<A4>e<E6><A4>*$'<E6>䤦(<E8><A7>g<E4>^W<97>^@<95>y<96>(<94>g<E6><E4>($<A5>*<E4><E5><97>(<A4><E6>^V<94>T*$<E6>U<E6><E6>^W<A5><EA><E9><E9>q^Qk!^W^@v<AE><DD>R<9B>^@^@^@
/lib/apk/db/HAKUNAMATATA.txt (END)
```
W pliku znajduje się coś dziwnego. Spróbujmy jeszcze wyświetlić go w jakiejś względnie normalnej formie:
```
[NIGHTMARE] / # while read -n 1 char; do LC_CTYPE=C printf '%02x ' "'$char"; done <<< "$(cat /lib/apk/db/HAKUNAMATATA.txt)"; echo
1f 8b 08 08 b4 e0 5b 03 48 41 4b 55 4e 41 4d 41 54 41 54 41 2e 74 78 74 e3 b0 25 00 
```
Szczerze mówiąc nic mi to nie mówi, ale po wklepaniu w google "1f8b" jako podpowiedź dostajemy "1f8b magic number". Po przejściu do [pierwszego linku](https://billatnapier.wordpress.com/2013/04/22/magic-numbers-in-files/) możemy się dowiedzieć, że pliki zaczynające się od `1F 8B 08` to pliki GZip. Mamy program `unpack`, więc probujemy wypakować plik:
```
[NIGHTMARE] / # \cp /lib/apk/db/HAKUNAMATATA.txt /tmp/HAKUNAMATATA.gz
[NIGHTMARE] / # /tmp/unpack -d /tmp/HAKUNAMATATA.gz 
[NIGHTMARE] / # cat /tmp/HAKUNAMATATA 

======================================
Just create EMPTY file called /ghost
It will be not empty anymore...
======================================

[NIGHTMARE] / # >/ghost
[NIGHTMARE] / # cat /ghost 


I'm ghost of this container.
I run as one of the processes, but you have to find me!

How to check process list? How to find my source?
It's your problem!
```
Już prawie! Sprawdźmy jakie procesy mamy uruchomione:
```
[NIGHTMARE] / # ls -lha /proc/*/exe 
lrwxrwxrwx 1 root root 0 Nov  1 22:56 /proc/1/exe -> /bin/bash
lrwxrwxrwx 1 root root 0 Nov  1 23:35 /proc/4847/exe -> /bin/sleep
lrwxrwxrwx 1 root root 0 Nov  1 22:56 /proc/8/exe -> /bin/bash
lrwxrwxrwx 1 root root 0 Nov  1 22:56 /proc/9/exe -> /bin/bash
lrwxrwxrwx 1 root root 0 Nov  1 23:35 /proc/self/exe -> /bin/ls
lrwxrwxrwx 1 root root 0 Nov  1 23:35 /proc/thread-self/exe -> /bin/ls
[NIGHTMARE] / # echo $$
9
```
Proces 4847 cały czas znika i pojawia się z innym PID, proces 9 to nasz proces, a jedynka to 'główne' polecenie - zostaje 8. Skacząc po plikach i przeglądając zawartość w końcu możemy trafić na źródło naszego ducha:
```
[NIGHTMARE] / # cat /proc/8/fd/255 
#!/bin/bash
# YOU FOUND GHOST!
# CONGRATULATIONS!
# THIS IS THE END.
#
# Please share this game with your friends :)
#
# Author: Jakub 'unknow' Mrugalski
# https://mrugalski.pl

sleep 5 && rm /run.sh

while [ ! -d /gate ]; do sleep 1; done
echo -e "You are inside haunted container.nYou are not alone!nTry to find me, or... I will find YOU" >/gate/message.ghost
while [ ! -f /ghost ]; do sleep 1; done
echo -e "nnI'm ghost of this container.nI run as one of the processes, but you have to find me!nnHow to check process list? How to find my source?nIt's your problem!" >/ghost
while [ 1==1 ]; do sleep 1; done
```

# Podsumowanie
Zadanie bardzo przyjemne i trzeba się przy nim nakombinować. Mi osobiście zajęło ono około dwie godziny (a miałem dzisiaj iść wcześniej spać).

Z niecierpliwością czekać, co nowego Unknow wymyśli :)
