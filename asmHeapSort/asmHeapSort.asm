.686 
.387
.model flat, stdcall 
.xmm
.data
.code


Tworz proc uses ebx ecx edx tablica:DWORD, nowa_tablica:DWORD, ilosc:DWORD, liczbaWatkow:DWORD, indexWatku:DWORD
;nag��wek procedury uzupe�niaj�cej now� tablic� danymi, deklaracja korzystania z rejestr�w ebx, ecx, edx
;jako parametry przekazujemy adres tablicy z danymi, adres pustej tablicy, ilo�� element�w, ilo�� w�tk�w oraz index
;aktualnego w�tku 

local localLiczbaWatkow:DWORD;lokalna zmienna przechowywuj�ca ilosc Watkow
local localIloscElem:DWORD   ;lokalna zmienna przechowywuj�ca ilo�� element�w

 
mov eax, ilosc				;wpisanie do rejestru eax "ilo��" z parametr�w
mov localIloscElem, eax     ;wpisanie do zmiennej lokalnej
mov eax, liczbaWatkow       ;wpisanie do rejestru eax liczby w�tk�w
mov localLiczbaWatkow, eax  ;wpisanie do zmiennej lokalnej warto�ci z eax
 
 
xor eax, eax				;wyzerowanie akumulatora
 
mov ecx, indexWatku         ;wpisanie do ecx indeksu aktualnie przerabianego w�tku, 
							;b�dzie on s�u�y� do odpowiednich iteracji
mov ebx, tablica			;przekazanie adresu tablicy do ebx
mov edx, nowa_tablica		;przekazanie adresu nowej_tablicy do edx
 
 
 
lea ebx, [ebx+ecx*4]		;zwi�kszenie adresu tablicy, przesuni�cie wzgl�dem 
							;poprzedniego adresu o warto�� indeksu w�tku pomno�onego razy rozmiar danych
lea edx, [edx+ecx*4]		;zwi�kszenie adresu tablicy



petla:
mov eax, [ebx]				;przeniesienie do akumulatora elementu z tablicy ebx
mov [edx], eax				;wpisanie do nowej tablicy elementu z akumulatora

mov eax, localLiczbaWatkow	;wpisanie do akumulatora liczby w�tk�w celem odpowiedniego zwi�kszenia adresu
lea ebx, [ebx+eax*4]		;przesuni�cie si� w tablicy wzgl�dem poprzedniego adresu o warto�� 
							;liczby w�tk�w pomno�onej razy rozmiar danych w tablicy
lea edx, [edx+eax*4]		;przesuni�cie si� w nowej tablicy
add ecx, eax				;zwi�kszenie indeksu iteracji o liczb� w�tk�w

 
cmp ecx, localIloscElem		;por�wnanie aktualnego indeksu z ilo�ci� element�w

jbe petla                   ;skok do p�tla je�eli indeks nie wyszed� poza zakres tablicy
 
 
 
xor eax, eax				;wyzerowanie akumulatora
ret							;powr�t
 
Tworz endp					;zako�czenie procedury
 

Sortuj proc uses ebx ecx edx esi edi nowa_tablica:DWORD, ilosc:DWORD
;nag��wek procedury odpowiedzialnej za sortowanie, b�dzie wykorzystywa�a rejestry ebx, ecx, esi, edi
;jako argumenty przekazujemy adres tablicy oraz ilo�� element�w

local k:DWORD				
local j:DWORD
local m:DWORD
							;zmienne odpowiadaj�ce za indeksowanie tablic oraz przechowywanie danych tymczasowych
local localIloscElem:DWORD  ;lokalna zmienna przechowywuj�ca ilo�� element�w
local localAdresTab:DWORD   ;zmienna odpowiedzialna za przechowywanie pocz�tkowego adresu tablicy
mov eax, ilosc				;wpisanie do rejestru eax "ilo��" z parametr�w
mov localIloscElem, eax     ;wpisanie do zmiennej lokalnej

mov ebx, nowa_tablica		;przekazanie adresu nowej_tablicy do ebx
mov localAdresTab, ebx		;zapami�tanie pocz�tkowego adresu tablicy

mov ecx, 2					;ustawienie licznika na warto�� pocz�tkow� p�tli

petla:
mov j, ecx					;zmienna s�u��ca do iterowania tablicy przyjmuje warto�� licznika
mov eax, ecx				;umieszczenie warto�ci ecx w akumulatorze, po dzieleniu warto�� trafi do 'k'
mov ebx, 2					;b�dziemy dzieli� przez 2
xor edx,edx					;wyzerowanie rejestru na reszte z dzielenia
div ebx						;podzielenie przez 2, wynik w akumulatorze (reszta w edx)
mov k, eax					;umieszczenie wyniku pod k

mov ebx, localAdresTab		;wyzerowanie iteracji celem �atwiejszego przeprowadzenia skok�w po tablicy
lea ebx, [ebx+ecx*4]		;zwi�kszenie adresu tablicy o odpowiedni indeks 
mov eax, [ebx]				;wrzucenie do akumulatora warto�ci z tablicy
mov m, eax					;wrzucenie do zmiennej tymczasowej warto�ci z akumulatora, p�niej ten element b�dzie przypisany do tablicy

petla_while:

mov esi, k					;wrzucenie do rejestru esi warto�ci spod k celem dokonania operacji por�wnania
cmp esi, 0					;jakie jest esi wzgl�dem zera?
jbe koniec_while			;je�eli esi jest mniejsze lub r�wne 0 zako�cz p�tle while

mov ebx, localAdresTab		;wyzerowanie iteracji celem �atwiejszego przeprowadzenia skok�w po tablicy
lea ebx, [ebx+esi*4]		;zwi�kszenie adresu tablicy o indeks 'k'

mov eax, [ebx]				;wrzucenie do akumulatora  warto�ci z tablicy
mov edi, m					;zapami�tanie 'm' w rejestrze edi
cmp edi, eax				;por�wnanie elementu z tablicy z warto�ci� zapami�tan�
jle koniec_while			;je�eli mniejsze lub r�wne zako�cz p�tle while


mov ebx, localAdresTab		;wyzerowanie iteracji celem �atwiejszego przeprowadzenia skok�w po tablicy
lea ebx, [ebx+esi*4]		;zwi�kszenie adresu tablicy o indeks 'k'
mov eax, [ebx]				;wrzucenie warto�ci zapami�tanej w akumulatorze w odpowiednie miejsce w tablicy

mov edi, j					;zapami�tanie indeksu j celem w�asciwego przej�cia po tablicy
mov ebx, localAdresTab		;wyzerowanie iteracji celem �atwiejszego przeprowadzenia skok�w po tablicy
lea ebx, [ebx+edi*4]		;zwi�kszenie adresu tablicy o indeks 'j'
mov [ebx], eax				;zapami�tanie elementu z tablicy w akumulatorze


mov j, esi					;wrzucenie pod warto�� 'j' warto�ci 'k'

mov ebx, 2					;b�dziemy dzieli� przez 2
xor edx, edx				;wyzerowanie rejestru na reszt� z dzielenia
mov eax, j					;umiesznienie w akumulatorze warto�ci kt�r� bedzi�my dzieli�
div ebx						;operacja dzielenia
mov esi, eax				;umieszczenie warto�ci z akumulatora w rejestrze esi
mov k, eax					;umieszczenie wyniku dzielenia w 'k'


jmp petla_while				;bezwarunkowy skok na pocz�tek p�tli

koniec_while:

mov eax, m					;wrzucenie zapami�tanej warto�ci do akumulatora
mov edi, j					;wrzucenie warto�ci 'j' do rejestru edi celem odpowiedniego zwi�kszenia adresu
mov ebx, localAdresTab		;wyzerowanie iteracji celem �atwiejszego przeprowadzenia skok�w po tablicy
lea ebx, [ebx+edi*4]		;zwi�kszenie adresu tablicy o indeks 'j'

mov [ebx], eax				;wrzucenie przetrzymywanej warto�ci w odpowiednie miejsce w tablicy

inc ecx						;zwi�kszenie indeksu tablic
cmp ecx, localIloscElem		;por�wnanie aktualnego indeksu z ilo�ci� element�w

jbe petla                   ;skok do p�tla je�eli indeks nie wyszed� poza zakres tablicy


							;rozbi�r kopca
mov ecx, localIloscElem		;ustawienie indeksu p�tli na ilo�� element�w


petla_sortuj:				;p�tla rozbioru kopca


mov ebx, localAdresTab		;wyzerowanie iteracji celem �atwiejszego przeprowadzenia skok�w po tablicy
lea ebx, [ebx+1*4]			;ustawienie adresu tablicy na pierwszy element
mov eax, [ebx]				;wrzucenie pierwszej warto�ci z tablicy do zmiennej tymczasowej
							;w akumulatorze jest warto�� tymczasowa

mov ebx, localAdresTab		;wyzerowanie iteracji celem �atwiejszego przeprowadzenia skok�w po tablicy
lea ebx, [ebx+ecx*4]		;ustawienie adresu na warto�� indeksu 'i'
mov edx, [ebx]				;zapami�tanie warto�ci spod adresu 'i'

mov ebx, localAdresTab		;wyzerowanie iteracji celem �atwiejszego przeprowadzenia skok�w po tablicy
lea ebx, [ebx+1*4]			;ustawienie adresu tablicy na pierwszy element
mov [ebx], edx				;wrzucenie waro�ci spod adresu 'i'


mov ebx, localAdresTab		;wyzerowanie iteracji celem �atwiejszego przeprowadzenia skok�w po tablicy
lea ebx, [ebx+ecx*4]		;zwi�kszenie adresu tablicy o indeks 'i'
mov [ebx], eax				;wrzucenie warto�ci spod adresu '1'

mov j, 1					;ustawienie indeksu 'j' na 1
mov k, 2					;ustawienie indeksu 'k' na 2

petla_while_sortuj:

mov esi, k					;wrzucenie do rejestru esi warto�ci spod k celem dokonania operacji por�wnania
cmp esi, ecx				;jakie jest esi wzgl�dem warto�ci indeksu?
jae koniec_while_sortuj		;je�eli esi jest mniejsze lub r�wne 0 zako�cz p�tle while

mov esi, k					;wrzucenie 'k' jako tymczasow� warto�� do rejestru 'esi'
inc esi						;zwi�kszenie o 1 warto�ci w esi
cmp esi, ecx				;operacja por�wnania warto�ci 'k' oraz indeksu g��wnego
jae else_if					;je�eli wi�ksze lub r�wne skocz do else_if

mov ebx, localAdresTab		;wyzerowanie iteracji celem �atwiejszego przeprowadzenia skok�w po tablicy
lea ebx, [ebx+esi*4]		;ustawienie adresu na warto�� indeksu 'k+1'
mov edx, [ebx]				;wrzucenie warto�ci spod indeksu 'k+1' do rejestru edx

mov esi, k					;wrzucenie 'k' jako tymczasow� warto�� do rejestru 'esi'
mov ebx, localAdresTab		;wyzerowanie iteracji celem �atwiejszego przeprowadzenia skok�w po tablicy
lea ebx, [ebx+esi*4]		;zwi�kszenie adresu warto�� indeksu 'k'
mov eax, [ebx]				;wrzucenie warto�ci z tablicy spod indeksu 'k' do akumulatora


cmp edx, eax				;por�wnanie warto�ci spod indeksu 'k+1' z warto�ci� 'k'
jle else_if					;je�eli mniejsze lub r�wne skocz do else_if
		
inc esi						;ustawienie 'k' na 'k+1'
mov m, esi					;wrzucenie warto�ci 'k+1' do zmiennej m
jmp koniec_if				;bezwarunkowy skok do koniec_if
else_if:

mov esi, k					;wrzucenie do rejestru warto�ci 'k'
mov m, esi					;przypisanie warto�ci 'k' do 'm'

koniec_if:

mov esi, m					;ustawienie rejestru na warto�� 'm'
mov ebx, localAdresTab		;wyzerowanie iteracji celem �atwiejszego przeprowadzenia skok�w po tablicy
lea ebx, [ebx+esi*4]		;ustawienie adresu na warto�� indeksu 'm'
mov edx, [ebx]				;zapami�tanie warto�ci spod adresu 'm'


mov esi, j					;wpisanie do rejestru esi warto�ci 'j'
mov ebx, localAdresTab		;wyzerowanie iteracji celem �atwiejszego przeprowadzenia skok�w po tablicy
lea ebx, [ebx+esi*4]		;ustawienie adresu tablicy na element spod indeksu 'j'
mov eax, [ebx]				;wrzucenie warto�ci z tablicy do zmiennej tymczasowej
							;w akumulatorze jest warto�� tymczasowa

cmp edx, eax				;por�wnanie warto�ci z tablicy o indeksie 'm' i 'j'
jle koniec_while_sortuj


mov esi, j					;wpisanie warto�ci 'j' do rejestru esi
mov ebx, localAdresTab		;wyzerowanie iteracji celem �atwiejszego przeprowadzenia skok�w po tablicy
lea ebx, [ebx+esi*4]		;ustawienie adresu tablicy na element spod indeksu 'j'
mov eax, [ebx]				;wrzucenie pierwszej warto�ci z tablicy do zmiennej tymczasowej
							;w akumulatorze jest warto�� tymczasowa

mov esi, m					;wpisanie warto�ci 'm' do rejestru esi
mov ebx, localAdresTab		;wyzerowanie iteracji celem �atwiejszego przeprowadzenia skok�w po tablicy
lea ebx, [ebx+esi*4]		;ustawienie adresu na warto�� indeksu 'm'
mov edx, [ebx]				;zapami�tanie warto�ci spod adresu 'm'

mov esi, j					;wpisanie do rejestru esi warto�ci 'j'
mov ebx, localAdresTab		;wyzerowanie iteracji celem �atwiejszego przeprowadzenia skok�w po tablicy
lea ebx, [ebx+esi*4]		;ustawienie adresu tablicy na element spod indeksu 'j'
mov [ebx], edx				;wrzucenie warto�ci spod adresu 'j'

mov esi, m					;wpisanie warto�ci 'm' do rejestru esi
mov ebx, localAdresTab		;wyzerowanie iteracji celem �atwiejszego przeprowadzenia skok�w po tablicy
lea ebx, [ebx+esi*4]		;zwi�kszenie adresu tablicy o indeks 'm'
mov [ebx], eax				;wrzucenie warto�ci spod adresu 'm'

mov j, esi					;wpisanie do zmiennej 'j' warto�ci z rejestru esi (m)

mov k, esi					;wpisanie warto�ci 'j' do 'k'
add k, esi					;zdublowanie warto�ci 'k'
jmp petla_while_sortuj		;bezwarunkowy skok do petla_while_sortuj

koniec_while_sortuj:

dec ecx						;zmniejszenie licznika
cmp ecx, 1					;por�wnanie licznika z warto�ci� 1

ja petla_sortuj				;jak wi�ksze to pon�w p�tle


mov eax, localAdresTab		;wpisanie do akumulatora adresu tablicy
ret							;powr�t
Sortuj endp

end