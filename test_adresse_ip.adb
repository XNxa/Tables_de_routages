with Adresse_IP; use Adresse_IP;
with Ada.Text_IO; use Ada.Text_IO;
with Ada.Strings.Fixed; use Ada.Strings.Fixed;
with Ada.Integer_Text_IO; use Ada.Integer_Text_IO;


procedure Test_Adresse_IP is

-- Déclaration des variables
    Adresse1, Adresse2, Adresse3 : T_adresse_ip;
    Masque : T_adresse_ip;
    Compatible : Boolean;
    UString : Unbounded_String;
    Octet1, Octet2, Octet3, Octet4 : Integer;
    Fichier : File_Type;

begin
-- Test de la fonction Initialiser
    Octet1 := 192;
    Octet2 := 168;
    Octet3 := 0;
    Octet4 := 1;
    Initialiser(Adresse1, Octet1, Octet2, Octet3, Octet4);
    UString := To_UString_Base10(Adresse1);
    Put_Line("Test de la fonction Initialiser : " & UString);

    -- Test de la fonction Lire_Adresse
    Open(Fichier, In_File, "adresse.txt");
    Lire_Adresse(Adresse2, Fichier);
    UString := To_UString_Base10(Adresse2);
    Put_Line("Test de la fonction Lire_Adresse : " & UString);
    Close(Fichier);

    -- Test de la fonction To_UString_Base10
    UString := To_UString_Base10(Adresse2);
    Put_Line("Test de la fonction To_UString_Base10 : " & UString);

    -- Test de la fonction Est_Compatible
    Octet1 := 255;
    Octet2 := 255;
    Octet3 := 0;
    Octet4 := 0;
    Initialiser(Masque, Octet1, Octet2, Octet3, Octet4);
    Octet1 := 192;
    Octet2 := 168;
    Octet3 := 0;
    Octet4 := 2;
    Initialiser(Adresse3, Octet1, Octet2, Octet3, Octet4);
    Compatible := Est_Compatible(Adresse1, Masque, Adresse3);
    Put_Line("Test de la fonction Est_Compatible : " & Boolean'Image(Compatible));

end Test_Adresse_IP;