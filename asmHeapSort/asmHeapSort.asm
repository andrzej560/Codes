.686 
.387
.model flat, stdcall 
.xmm
.data
.code


Tworz proc uses ebx ecx edx tablica:DWORD, nowa_tablica:DWORD, ilosc:DWORD, liczbaWatkow:DWORD, indexWatku:DWORD
;nag³ówek procedury uzupe³niaj¹cej now¹ tablicê danymi, deklaracja korzystania z rejestrów ebx, ecx, edx
;jako parametry przekazujemy adres tablicy z danymi, adres pustej tablicy, iloœæ elementów, iloœæ w¹tków oraz index
;aktualnego w¹tku 

local localLiczbaWatkow:DWORD;lokalna zmienna przechowywuj¹ca ilosc Watkow
local localIloscElem:DWORD   ;lokalna zmienna przechowywuj¹ca iloœæ elementów

 
mov eax, ilosc				;wpisanie do rejestru eax "iloœæ" z parametrów
mov localIloscElem, eax     ;wpisanie do zmiennej lokalnej
mov eax, liczbaWatkow       ;wpisanie do rejestru eax liczby w¹tków
mov localLiczbaWatkow, eax  ;wpisanie do zmiennej lokalnej wartoœci z eax
 
 
xor eax, eax				;wyzerowanie akumulatora
 
mov ecx, indexWatku         ;wpisanie do ecx indeksu aktualnie przerabianego w¹tku, 
							;bêdzie on s³u¿y³ do odpowiednich iteracji
mov ebx, tablica			;przekazanie adresu tablicy do ebx
mov edx, nowa_tablica		;przekazanie adresu nowej_tablicy do edx
 
 
 
lea ebx, [ebx+ecx*4]		;zwiêkszenie adresu tablicy, przesuniêcie wzglêdem 
							;poprzedniego adresu o wartoœæ indeksu w¹tku pomno¿onego razy rozmiar danych
lea edx, [edx+ecx*4]		;zwiêkszenie adresu tablicy



petla:
mov eax, [ebx]				;przeniesienie do akumulatora elementu z tablicy ebx
mov [edx], eax				;wpisanie do nowej tablicy elementu z akumulatora

mov eax, localLiczbaWatkow	;wpisanie do akumulatora liczby w¹tków celem odpowiedniego zwiêkszenia adresu
lea ebx, [ebx+eax*4]		;przesuniêcie siê w tablicy wzglêdem poprzedniego adresu o wartoœæ 
							;liczby w¹tków pomno¿onej razy rozmiar danych w tablicy
lea edx, [edx+eax*4]		;przesuniêcie siê w nowej tablicy
add ecx, eax				;zwiêkszenie indeksu iteracji o liczbê w¹tków

 
cmp ecx, localIloscElem		;porównanie aktualnego indeksu z iloœci¹ elementów

jbe petla                   ;skok do pêtla je¿eli indeks nie wyszed³ poza zakres tablicy
 
 
 
xor eax, eax				;wyzerowanie akumulatora
ret							;powrót
 
Tworz endp					;zakoñczenie procedury
 

Sortuj proc uses ebx ecx edx esi edi nowa_tablica:DWORD, ilosc:DWORD
;nag³ówek procedury odpowiedzialnej za sortowanie, bêdzie wykorzystywa³a rejestry ebx, ecx, esi, edi
;jako argumenty przekazujemy adres tablicy oraz iloœæ elementów

local k:DWORD				
local j:DWORD
local m:DWORD
							;zmienne odpowiadaj¹ce za indeksowanie tablic oraz przechowywanie danych tymczasowych
local localIloscElem:DWORD  ;lokalna zmienna przechowywuj¹ca iloœæ elementów
local localAdresTab:DWORD   ;zmienna odpowiedzialna za przechowywanie pocz¹tkowego adresu tablicy
mov eax, ilosc				;wpisanie do rejestru eax "iloœæ" z parametrów
mov localIloscElem, eax     ;wpisanie do zmiennej lokalnej

mov ebx, nowa_tablica		;przekazanie adresu nowej_tablicy do ebx
mov localAdresTab, ebx		;zapamiêtanie pocz¹tkowego adresu tablicy

mov ecx, 2					;ustawienie licznika na wartoœæ pocz¹tkow¹ pêtli

petla:
mov j, ecx					;zmienna s³u¿¹ca do iterowania tablicy przyjmuje wartoœæ licznika
mov eax, ecx				;umieszczenie wartoœci ecx w akumulatorze, po dzieleniu wartoœæ trafi do 'k'
mov ebx, 2					;bêdziemy dzieliæ przez 2
xor edx,edx					;wyzerowanie rejestru na reszte z dzielenia
div ebx						;podzielenie przez 2, wynik w akumulatorze (reszta w edx)
mov k, eax					;umieszczenie wyniku pod k

mov ebx, localAdresTab		;wyzerowanie iteracji celem ³atwiejszego przeprowadzenia skoków po tablicy
lea ebx, [ebx+ecx*4]		;zwiêkszenie adresu tablicy o odpowiedni indeks 
mov eax, [ebx]				;wrzucenie do akumulatora wartoœci z tablicy
mov m, eax					;wrzucenie do zmiennej tymczasowej wartoœci z akumulatora, póŸniej ten element bêdzie przypisany do tablicy

petla_while:

mov esi, k					;wrzucenie do rejestru esi wartoœci spod k celem dokonania operacji porównania
cmp esi, 0					;jakie jest esi wzglêdem zera?
jbe koniec_while			;je¿eli esi jest mniejsze lub równe 0 zakoñcz pêtle while

mov ebx, localAdresTab		;wyzerowanie iteracji celem ³atwiejszego przeprowadzenia skoków po tablicy
lea ebx, [ebx+esi*4]		;zwiêkszenie adresu tablicy o indeks 'k'

mov eax, [ebx]				;wrzucenie do akumulatora  wartoœci z tablicy
mov edi, m					;zapamiêtanie 'm' w rejestrze edi
cmp edi, eax				;porównanie elementu z tablicy z wartoœci¹ zapamiêtan¹
jle koniec_while			;je¿eli mniejsze lub równe zakoñcz pêtle while


mov ebx, localAdresTab		;wyzerowanie iteracji celem ³atwiejszego przeprowadzenia skoków po tablicy
lea ebx, [ebx+esi*4]		;zwiêkszenie adresu tablicy o indeks 'k'
mov eax, [ebx]				;wrzucenie wartoœci zapamiêtanej w akumulatorze w odpowiednie miejsce w tablicy

mov edi, j					;zapamiêtanie indeksu j celem w³asciwego przejœcia po tablicy
mov ebx, localAdresTab		;wyzerowanie iteracji celem ³atwiejszego przeprowadzenia skoków po tablicy
lea ebx, [ebx+edi*4]		;zwiêkszenie adresu tablicy o indeks 'j'
mov [ebx], eax				;zapamiêtanie elementu z tablicy w akumulatorze


mov j, esi					;wrzucenie pod wartoœæ 'j' wartoœci 'k'

mov ebx, 2					;bêdziemy dzieliæ przez 2
xor edx, edx				;wyzerowanie rejestru na resztê z dzielenia
mov eax, j					;umiesznienie w akumulatorze wartoœci któr¹ bedziêmy dzieliæ
div ebx						;operacja dzielenia
mov esi, eax				;umieszczenie wartoœci z akumulatora w rejestrze esi
mov k, eax					;umieszczenie wyniku dzielenia w 'k'


jmp petla_while				;bezwarunkowy skok na pocz¹tek pêtli

koniec_while:

mov eax, m					;wrzucenie zapamiêtanej wartoœci do akumulatora
mov edi, j					;wrzucenie wartoœci 'j' do rejestru edi celem odpowiedniego zwiêkszenia adresu
mov ebx, localAdresTab		;wyzerowanie iteracji celem ³atwiejszego przeprowadzenia skoków po tablicy
lea ebx, [ebx+edi*4]		;zwiêkszenie adresu tablicy o indeks 'j'

mov [ebx], eax				;wrzucenie przetrzymywanej wartoœci w odpowiednie miejsce w tablicy

inc ecx						;zwiêkszenie indeksu tablic
cmp ecx, localIloscElem		;porównanie aktualnego indeksu z iloœci¹ elementów

jbe petla                   ;skok do pêtla je¿eli indeks nie wyszed³ poza zakres tablicy


							;rozbiór kopca
mov ecx, localIloscElem		;ustawienie indeksu pêtli na iloœæ elementów


petla_sortuj:				;pêtla rozbioru kopca


mov ebx, localAdresTab		;wyzerowanie iteracji celem ³atwiejszego przeprowadzenia skoków po tablicy
lea ebx, [ebx+1*4]			;ustawienie adresu tablicy na pierwszy element
mov eax, [ebx]				;wrzucenie pierwszej wartoœci z tablicy do zmiennej tymczasowej
							;w akumulatorze jest wartoœæ tymczasowa

mov ebx, localAdresTab		;wyzerowanie iteracji celem ³atwiejszego przeprowadzenia skoków po tablicy
lea ebx, [ebx+ecx*4]		;ustawienie adresu na wartoœæ indeksu 'i'
mov edx, [ebx]				;zapamiêtanie wartoœci spod adresu 'i'

mov ebx, localAdresTab		;wyzerowanie iteracji celem ³atwiejszego przeprowadzenia skoków po tablicy
lea ebx, [ebx+1*4]			;ustawienie adresu tablicy na pierwszy element
mov [ebx], edx				;wrzucenie waroœci spod adresu 'i'


mov ebx, localAdresTab		;wyzerowanie iteracji celem ³atwiejszego przeprowadzenia skoków po tablicy
lea ebx, [ebx+ecx*4]		;zwiêkszenie adresu tablicy o indeks 'i'
mov [ebx], eax				;wrzucenie wartoœci spod adresu '1'

mov j, 1					;ustawienie indeksu 'j' na 1
mov k, 2					;ustawienie indeksu 'k' na 2

petla_while_sortuj:

mov esi, k					;wrzucenie do rejestru esi wartoœci spod k celem dokonania operacji porównania
cmp esi, ecx				;jakie jest esi wzglêdem wartoœci indeksu?
jae koniec_while_sortuj		;je¿eli esi jest mniejsze lub równe 0 zakoñcz pêtle while

mov esi, k					;wrzucenie 'k' jako tymczasow¹ wartoœæ do rejestru 'esi'
inc esi						;zwiêkszenie o 1 wartoœci w esi
cmp esi, ecx				;operacja porównania wartoœci 'k' oraz indeksu g³ównego
jae else_if					;je¿eli wiêksze lub równe skocz do else_if

mov ebx, localAdresTab		;wyzerowanie iteracji celem ³atwiejszego przeprowadzenia skoków po tablicy
lea ebx, [ebx+esi*4]		;ustawienie adresu na wartoœæ indeksu 'k+1'
mov edx, [ebx]				;wrzucenie wartoœci spod indeksu 'k+1' do rejestru edx

mov esi, k					;wrzucenie 'k' jako tymczasow¹ wartoœæ do rejestru 'esi'
mov ebx, localAdresTab		;wyzerowanie iteracji celem ³atwiejszego przeprowadzenia skoków po tablicy
lea ebx, [ebx+esi*4]		;zwiêkszenie adresu wartoœæ indeksu 'k'
mov eax, [ebx]				;wrzucenie wartoœci z tablicy spod indeksu 'k' do akumulatora


cmp edx, eax				;porównanie wartoœci spod indeksu 'k+1' z wartoœci¹ 'k'
jle else_if					;je¿eli mniejsze lub równe skocz do else_if
		
inc esi						;ustawienie 'k' na 'k+1'
mov m, esi					;wrzucenie wartoœci 'k+1' do zmiennej m
jmp koniec_if				;bezwarunkowy skok do koniec_if
else_if:

mov esi, k					;wrzucenie do rejestru wartoœci 'k'
mov m, esi					;przypisanie wartoœci 'k' do 'm'

koniec_if:

mov esi, m					;ustawienie rejestru na wartoœæ 'm'
mov ebx, localAdresTab		;wyzerowanie iteracji celem ³atwiejszego przeprowadzenia skoków po tablicy
lea ebx, [ebx+esi*4]		;ustawienie adresu na wartoœæ indeksu 'm'
mov edx, [ebx]				;zapamiêtanie wartoœci spod adresu 'm'


mov esi, j					;wpisanie do rejestru esi wartoœci 'j'
mov ebx, localAdresTab		;wyzerowanie iteracji celem ³atwiejszego przeprowadzenia skoków po tablicy
lea ebx, [ebx+esi*4]		;ustawienie adresu tablicy na element spod indeksu 'j'
mov eax, [ebx]				;wrzucenie wartoœci z tablicy do zmiennej tymczasowej
							;w akumulatorze jest wartoœæ tymczasowa

cmp edx, eax				;porównanie wartoœci z tablicy o indeksie 'm' i 'j'
jle koniec_while_sortuj


mov esi, j					;wpisanie wartoœci 'j' do rejestru esi
mov ebx, localAdresTab		;wyzerowanie iteracji celem ³atwiejszego przeprowadzenia skoków po tablicy
lea ebx, [ebx+esi*4]		;ustawienie adresu tablicy na element spod indeksu 'j'
mov eax, [ebx]				;wrzucenie pierwszej wartoœci z tablicy do zmiennej tymczasowej
							;w akumulatorze jest wartoœæ tymczasowa

mov esi, m					;wpisanie wartoœci 'm' do rejestru esi
mov ebx, localAdresTab		;wyzerowanie iteracji celem ³atwiejszego przeprowadzenia skoków po tablicy
lea ebx, [ebx+esi*4]		;ustawienie adresu na wartoœæ indeksu 'm'
mov edx, [ebx]				;zapamiêtanie wartoœci spod adresu 'm'

mov esi, j					;wpisanie do rejestru esi wartoœci 'j'
mov ebx, localAdresTab		;wyzerowanie iteracji celem ³atwiejszego przeprowadzenia skoków po tablicy
lea ebx, [ebx+esi*4]		;ustawienie adresu tablicy na element spod indeksu 'j'
mov [ebx], edx				;wrzucenie wartoœci spod adresu 'j'

mov esi, m					;wpisanie wartoœci 'm' do rejestru esi
mov ebx, localAdresTab		;wyzerowanie iteracji celem ³atwiejszego przeprowadzenia skoków po tablicy
lea ebx, [ebx+esi*4]		;zwiêkszenie adresu tablicy o indeks 'm'
mov [ebx], eax				;wrzucenie wartoœci spod adresu 'm'

mov j, esi					;wpisanie do zmiennej 'j' wartoœci z rejestru esi (m)

mov k, esi					;wpisanie wartoœci 'j' do 'k'
add k, esi					;zdublowanie wartoœci 'k'
jmp petla_while_sortuj		;bezwarunkowy skok do petla_while_sortuj

koniec_while_sortuj:

dec ecx						;zmniejszenie licznika
cmp ecx, 1					;porównanie licznika z wartoœci¹ 1

ja petla_sortuj				;jak wiêksze to ponów pêtle


mov eax, localAdresTab		;wpisanie do akumulatora adresu tablicy
ret							;powrót
Sortuj endp

end