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
    SupMasque : Boolean;

    procedure Test_de_la_fonction_Initialiser is
    begin
        Octet1 := 192;
        Octet2 := 168;
        Octet3 := 0;
        Octet4 := 1;
        Initialiser(Adresse1, Octet1, Octet2, Octet3, Octet4);
        Adresse_String := To_UString_Base10(Adresse1);
        Put_Line("Test de la fonction Initialiser avec octets quelconques : " & Adresse_String);
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
        Put_Line("Test avec une adresse IP trop longue dans le fichier : " & Adresse_String);

        Lire_Adresse(Adresse1, Fichier);
        Adresse_String := To_UString_Base10(Adresse1);
        Put_Line("Test avec une adresse IP trop courte dans le fichier : " & Adresse_String);
        Close(Fichier);

        Put_Line("Fonction Lire_Adresse OK");
    end Test_de_la_fonction_Lire_Adresse;

    procedure Test_To_UString_Base10 is
    begin
        Octet1 := 192;
        Octet2 := 168;
        Octet3 := 0;
        Octet4 := 1;
        Initialiser(Adresse1, Octet1, Octet2, Octet3, Octet4);
        Adresse_String := To_UString_Base10(Adresse1);
        Put_Line("Test Test_To_UString_Base10 avec octets quelconques : " & Adresse_String);
        pragma Assert (Adresse_String = "192.168.0.1");

        Put_Line("Fonction To_UString_Base10 OK");
    end Test_To_UString_Base10;

    procedure Test_Est_Compatible is
    begin
        Octet1 := 168;
        Octet2 := 97;
        Octet3 := 0;
        Octet4 := 0;
        Initialiser(Adresse1, Octet1, Octet2, Octet3, Octet4);
        Octet1 := 255;
        Octet2 := 255;
        Octet3 := 255;
        Octet4 := 255;
        Initialiser(Masque, Octet1, Octet2, Octet3, Octet4);
        Octet1 := 168;
        Octet2 := 97;
        Octet3 := 18;
        Octet4 := 22;
        Initialiser(Adresse2, Octet1, Octet2, Octet3, Octet4);
        Compatible := Est_Compatible(Adresse2, Masque, Adresse1);
        Put_Line("Test avec deux adresses partiellement différentes et un masque long : " & Boolean'Image(Compatible));

        Octet1 := 168;
        Octet2 := 97;
        Octet3 := 0;
        Octet4 := 0;
        Initialiser(Adresse1, Octet1, Octet2, Octet3, Octet4);
        Octet1 := 255;
        Octet2 := 255;
        Octet3 := 0;
        Octet4 := 0;
        Initialiser(Masque, Octet1, Octet2, Octet3, Octet4);
        Octet1 := 168;
        Octet2 := 97;
        Octet3 := 18;
        Octet4 := 22;
        Initialiser(Adresse2, Octet1, Octet2, Octet3, Octet4);
        Compatible := Est_Compatible(Adresse2, Masque, Adresse1);
        Put_Line("Test avec deux adresses partiellement différentes et un masque court : " & Boolean'Image(Compatible));

        Put_Line("Fonction Est_Compatible OK");
    end Test_Est_Compatible;

    procedure Test_Sup_Masque is
    begin
        Octet1 := 0;
        Octet2 := 0;
        Octet3 := 0;
        Octet4 := 0;
        Initialiser(Adresse1, Octet1, Octet2, Octet3, Octet4);
        Initialiser(Adresse2, Octet1, Octet2, Octet3, Octet4);
        SupMasque := Sup_Masque(Adresse1, Adresse2);
        Put_Line("Test avec deux adresses égales : " & Boolean'Image(SupMasque));

        Octet1 := 0;
        Octet2 := 0;
        Octet3 := 0;
        Octet4 := 1;
        Initialiser(Adresse1, Octet1, Octet2, Octet3, Octet4);
        Octet4 := 0;
        Initialiser(Adresse2, Octet1, Octet2, Octet3, Octet4);
        SupMasque := Sup_Masque(Adresse1, Adresse2);
        Put_Line("Test avec Adresse de droite supérieure à Adresse de gauche : " & Boolean'Image(SupMasque));

        Octet1 := 0;
        Octet2 := 0;
        Octet3 := 0;
        Octet4 := 1;
        Initialiser(Adresse1, Octet1, Octet2, Octet3, Octet4);
        Octet4 := 0;
        Initialiser(Adresse2, Octet1, Octet2, Octet3, Octet4);
        SupMasque := Sup_Masque(Adresse2, Adresse1);
        Put_Line("Test avec Adresse de gauche supérieure à Adresse de droite : " & Boolean'Image(SupMasque));

        Put_Line("Fonction Sup_Masque OK");
    end Test_Sup_Masque;

begin

    Put_Line("Test de la fonction Initialiser :");
    Test_de_la_fonction_Initialiser;
    new_Line;
    --Put_Line("Test de la fonction Lire_Adresse :");
   -- Test_de_la_fonction_Lire_Adresse;
    new_Line;
    Put_Line("Test de la fonction Est_Compatible :");
    Test_Est_Compatible;
    new_Line;
    Put_Line("Test de la fonction To_UString_Base10 :");
    Test_To_UString_Base10;
    new_Line;
    Put_Line("Test de la fonction Sup_Masque :");
    Test_Sup_Masque;

end Test_Adresse_IP;