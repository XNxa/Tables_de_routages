with Adresse_IP; use Adresse_IP;
with Ada.Text_IO; use Ada.Text_IO;
with Ada.Strings.Fixed; use Ada.Strings.Fixed;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;
with Ada.Integer_Text_IO; use Ada.Integer_Text_IO;
with Ada.Text_IO.Unbounded_IO; use Ada.Text_IO.Unbounded_IO;

procedure Test_Adresse_IP is

-- Déclaration des variables
    Adresse1, Adresse2, Adresse3 : T_adresse_ip;
    Masque : T_adresse_ip;
    Compatible : Boolean;
    Adresse_String : Unbounded_String;
    Octet1, Octet2, Octet3, Octet4 : Integer;
    Fichier : File_Type;

    procedure Test_de_la_fonction_Initialiser is
    begin
        Octet1 := 192;
        Octet2 := 168;
        Octet3 := 0;
        Octet4 := 1;
        Initialiser(Adresse1, Octet1, Octet2, Octet3, Octet4);
        Adresse_String := To_UString_Base10(Adresse1);
        Put_Line("Test de la fonction Initialiser : " & Adresse_String);
        pragma Assert (Adresse_String = "192.168.0.1");

        Octet1 := 0;
        Octet2 := 0;
        Octet3 := 0;
        Octet4 := 0;
        Initialiser(Adresse1, Octet1, Octet2, Octet3, Octet4);
        Adresse_String := To_UString_Base10(Adresse1);
        Put_Line("Test de la fonction Initialiser avec un octet de valeur minimale : " & Adresse_String);
        pragma Assert (Adresse_String = "0.0.0.0");

        Octet1 := 255;
        Octet2 := 255;
        Octet3 := 255;
        Octet4 := 255;
        Initialiser(Adresse1, Octet1, Octet2, Octet3, Octet4);
        Adresse_String := To_UString_Base10(Adresse1);
        Put_Line("Test de la fonction Initialiser avec un octet de valeur maximale : " & Adresse_String);
        pragma Assert (Adresse_String = "255.255.255.255");

        Put_Line("Fonction initialise OK");
    end Test_de_la_fonction_Initialiser;

    procedure Test_de_la_fonction_Lire_Adresse is
    begin
        Open(Fichier, In_File, "test_adresse.txt");
        Lire_Adresse(Adresse2, Fichier);
        Adresse_String := To_UString_Base10(Adresse2);
        Put_Line("Test de la fonction Lire_Adresse : " & Adresse_String);
        pragma Assert (Adresse_String = "192.168.0.1");

        Lire_Adresse(Adresse1, Fichier);
        Adresse_String := To_UString_Base10(Adresse1);
        Put_Line("Test avec une adresse IP invalide dans le fichier : " & Adresse_String);
        Close(Fichier);

        -- Créer un fichier vide "adresse.txt"
        Open(Fichier, In_File, "test_adresse_vide.txt");
        Lire_Adresse(Adresse1, Fichier);
        Adresse_String := To_UString_Base10(Adresse1);
        Put_Line("Test avec un fichier vide : " & Adresse_String);
        Close(Fichier);

         Put_Line("Fonction Lire_Adresse OK");
    end Test_de_la_fonction_Lire_Adresse;

begin
-- 
     Octet1 := 0;
        Octet2 := 0;
        Octet3 := 0;
        Octet4 := 0;
        Initialiser(Adresse1, Octet1, Octet2, Octet3, Octet4);
        Initialiser(Masque, Octet1, Octet2, Octet3, Octet4);
        Octet1 := 0;
        Octet2 := 0;
        Octet3 := 0;
        Octet4 := 1;
        Initialiser(Adresse3, Octet1, Octet2, Octet3, Octet4);
        Compatible := Est_Compatible(Adresse1, Masque, Adresse3);
        Put_Line("Test de la fonction Est_Compatible avec une adresse et un masque de valeur minimale : " & Boolean'Image(Compatible));




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