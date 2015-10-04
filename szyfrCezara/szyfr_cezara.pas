program szyfr_cezara;
uses crt;
LABEL menu_1, menu_2, menu_3;//etykiety

function FileExists(FileName:String): Boolean;   //sprawdza czy plik istnieje
 var
 F: file;

 begin
  {$I-}
  Assign(f, FileName);
  FileMode:=0;
  Reset(F);
  Close(F);
  {$I+}
  FileExists:=(IOResult = 0) and (FileName <> '');
 end;

var
 plik, plik_2: text;
 sciezka_pliku,sciezka_pliku_2, odczyt: string;
 wybor: string; // zmienna wyboru opcji
 i,a: integer; // przesuniecie w kodzie
 znak: char;//odczytany znak
 k: integer;// zmienna sterujaca w petli


begin
clrscr;
writeln('---SZYFR CEZARA---');
writeln();
writeln('---MENU OPCJI---');
writeln('(wpisz odpowiedni numer z klawiatury)');
writeln();
menu_1:
writeln('1. SZYFROWANIE');
writeln('2. DESZYFROWANIE');
writeln('3. WYJSCIE Z PROGRAMU');
readln(wybor); //wybor odpowiedniej opcji z menu

if ((wybor='1') or (wybor='2')) then
    GOTO menu_2
else if (wybor='3') then
    GOTO menu_3
else
  begin
    writeln('(sprobuj jeszcze raz)');
    GOTO menu_1;
  end;  // blok wyboru opcji w menu

menu_2:
writeln();
writeln('---PODAJ SCIEZKE PLIKU---');
readln(sciezka_pliku);

if FileExists(sciezka_pliku) then
writeln('Plik wczytany pomyslnie')
else begin
     writeln ('Plik nie zostal wczytany');
     GOTO menu_1;
     end;                                     //sprawdzenie czy plik istnieje


repeat
  writeln('Podaj przesuniecie');
  {$I-}
  readln(a);
  {$I+}
  i:=ioresult;
  if i<>0 then
    begin
    writeln('Wprowadz dane ponownie');

    end;
until i=0;                         //odczyt przesuniecia
if a<0 then a:=a*-1;

assign(plik, sciezka_pliku);
reset(plik);

if sciezka_pliku='cezar.txt' then
   sciezka_pliku_2:='cezar2.txt' else sciezka_pliku_2:='cezar.txt';

assign(plik_2, sciezka_pliku_2);
rewrite(plik_2);

while not eof(plik) do
  begin
  readln(plik, odczyt);
  for k:=1 to length(odczyt) do
    begin
    znak:=odczyt[k];




    if wybor ='1' then

       znak:=chr(( (ord(znak)) + a) mod 256)

       else znak:=chr (( (ord(znak)) - a) mod 256);



    //write(znak);
    odczyt[k]:=znak;

    end;
  odczyt:=odczyt+#13+#10;
  write(plik_2, odczyt);
  end;

writeln('Proces zakonczony');
close(plik);
close(plik_2);

writeln();
GOTO menu_1;
menu_3:
end.
