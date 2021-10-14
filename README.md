1. Zmienamy odpowiednio zmienne w skrypcie po swoja instalacje
2. uruchamiamy skrypt
3. Podązamy zgodnie z instrukcjami na STDOUT
4. plik konfiguracyjny $user.ovpn kopiujemy na swoj lokalny komputer instalujemy klienta ovpn.
5. laczymy sie z vpn za pomoca komendy sudo openvpn --config $user.ovpn
6. Probujemy sie laczyc za pomoca adresu prywatnego na port 22.

PS. Jesli kontener sie usunie lub zginie skrypt tworzy rowniez docker-compose dzieki ktoremu pozniej mozna uruchomic serwis za pomoca docker-compose up -d
