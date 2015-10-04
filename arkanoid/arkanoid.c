//Sterowanie klawiszami A i D
//Testowane na Dev-C++ 5.4.0

#include <conio.h> 
#include <stdio.h> 
#include <windows.h> 
#include <time.h> 


void gotoxy(int x, int y)  // Funkcja odpowiadajaca za przechodzenie na dana wspolrzedna w okienku konsoli
{ 
	HANDLE stdOutput; 
	COORD pos; 

	stdOutput = GetStdHandle(STD_OUTPUT_HANDLE); 

	pos.X = x; 
	pos.Y = y; 

	SetConsoleCursorPosition(stdOutput, pos); 
} 

void main() { 
	int x=16,y=16,dx=1,dy=1, xx = 16, yy=16, dxx=1, dyy=1; // Zmienne wspolrzednych oraz szybkosci pilek
	long k; //Zmienna sterujaca w petli
	char c='o', cc='O'; // Graficzne przedstawienie pilek
	int pal=22; //Pozycja startowa paletki 
	char znak='0'; // Zmienna odpowiadajaca za odczyt danych z klawiatury
	int punkty=0; 
	int klocki=0;
	int kombo=0;
	int licznik=2; // Zmienna pomocnicza do obslugi szybkosci pilki
	int i,j,l; // Zmienne sterujace w petli
	srand(time(0)); // Sprawienie, aby wyniki byly 'bardziej losowe'
	int tablica[73][13]; // Inicjalizacja tablicy w ktorej przechowywane beda klocki
	gotoxy(18,1);
	printf("WCISNIJ ENTER" );
	getchar ();   

	for(i=6; i<=72; i+=3) // Rysowanie klockow, w tym przypadku bedzie ich 115
	{
		for (j=4; j<=12; j+=2)
		{
			l=1 + rand()  % 9;
			tablica[i][j] = l;
			gotoxy(i,j);
			printf("%i",l);
		}
	} 

	gotoxy(18,1);
	printf("                   " ); // Wyczyszczenie tekstu

	while((y!=25) && (yy!=25)){ // Dopoki pilki nie wyszly za paletke
	gotoxy(x,y);
	printf("%c",c);

	licznik++;
	if (licznik>=3)
			{ // Obsluga szybkosci wolniejszej pilki
				gotoxy(xx,yy);
				printf(" ");
				xx+=dxx;
				yy+=dyy; 
				gotoxy(xx,yy);
				printf("%c", cc);
                
                
			}

	gotoxy(pal,24);


	printf("  _____  ");// Rysowanie paletki
	znak = '0'; // Czyszczenie ostatniego wcisnietego klawisza

	if (kbhit()) znak=getch(); // Wczytanie klawisza z klawiatury
	if (znak==97) pal-=2; // Poruszanie paletka
	if (znak==100) pal+=2; 

	if (pal < 0) pal=0;  // Zabezbieczenie przed wyjsciem poza ekran
	if (pal > 70) pal=70; 

	gotoxy(1,1);
	printf("PUNKTY: %i", punkty);
	gotoxy(1,2);
	printf("KLOCKI: %i", klocki);
	gotoxy(18,2);
	printf("COMBO: %i", kombo); 
	
	// PILKA 1
	if ((y>=4) && (y<=12) && (x>=6) && (x<=72)){ //Tylko dla obszaru z klockami
		if ( ( tablica[x][y] >=1  ) && (tablica[x][y] <=9)) {
			punkty+=tablica[x][y]; // Zwiekszenie ilosci punktow
			klocki++;
			tablica[x][y]=0; // Zniszczenie klocka
			kombo++;
			printf ("\a") ; // Sygnal dzwiekowy
			dy=-dy; // Zmiana kierunku pionowego ruchu pilki

		}

	}

	// PILKA 2
	if ((yy>=4) && (yy<=12) && (xx>=6) && (xx<=72)){  
		if ( ( tablica[xx][yy] >=1  ) && (tablica[xx][yy] <=9)) {
			punkty+=tablica[xx][yy];  // Zwiekszenie ilosci punktow
			klocki++;
			tablica[xx][yy]=0; // Zniszczenie klocka
			kombo++;
			printf ("\a") ; // Sygnal dzwiekowy
			dyy=-dyy; // Zmiana kierunku pionowego ruchu pilki
		}

	}

	// Pilka 1
	if ((x==79) || (x==1))dx=-dx; // Zmiana kierunku poziomego ruchu pilki

	if ((y==24) && ((x>=pal+2) && (x<=pal+6 ) ) || ( (y==24) && (( x<=2) || (x>=77)  ))) 
	// Zdarzenie, gdy pilka uderzy w paletke
	{  
		dy=-dy; // Zmiana kierunku pionowego pilki
		printf ("\a") ; 
		gotoxy(25,2);
		printf("    ");
		kombo=0; 
	} 

	if (y==1) dy=-dy; // Zdarzenie gdy pilka uderzy w sufit
	
	// Pilka2
	if (licznik>=3){
	if ((xx==79) || (xx==1))dxx=-dxx;

	if ((yy==24) && ((xx>=pal+2) && (xx<=pal+6 ) ) || ( (yy==24) && (( xx<=2) || (xx>=77)  ))) 
	{
		dyy=-dyy;
		printf ("\a") ;
		gotoxy(25,2);
		printf("    ");
		kombo=0; 
	} 

	if (yy==1) dyy=-dyy;

	licznik=1;
	}

	for(k=0;k<35000000;k++); // Obsluga szybkosci gry

	gotoxy(x,y);
	printf(" ");

	x+=dx;
	y+=dy;


	}

	gotoxy(18,1);
	if (klocki>=100) printf("GRATULUJE"); else
	printf("KONIEC GRY" );

	getchar ();


}


