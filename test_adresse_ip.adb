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
    Fichier : File_Type;
    SupMasque : Boolean;

    procedure Test_de_la_fonction_Initialiser is
    begin

        Initialiser(Adresse1, 192, 168, 0, 1);
        Adresse_String := To_UString_Base10(Adresse1);
        Put_Line("Test de la fonction Initialiser avec octets quelconques : " & Adresse_String);
        pragma Assert (Adresse_String = "192.168.0.1");


        Initialiser(Adresse1, 0, 0, 0, 0);
        Adresse_String := To_UString_Base10(Adresse1);
        Put_Line("Test de la fonction Initialiser avec un octet de valeur minimale : " & Adresse_String);
        pragma Assert (Adresse_String = "0.0.0.0");


        Initialiser(Adresse1, 255, 255, 255, 255);
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

        --Lire_Adresse(Adresse1, Fichier);
        --Adresse_String := To_UString_Base10(Adresse1);
        --Put_Line("Test avec une adresse IP trop courte dans le fichier : " & Adresse_String);
        
        Close(Fichier);

        Put_Line("Fonction Lire_Adresse OK");
    end Test_de_la_fonction_Lire_Adresse;

    procedure Test_To_UString_Base10 is
    begin

        Initialiser(Adresse1, 192, 168, 0, 1);
        Adresse_String := To_UString_Base10(Adresse1);
        Put_Line("Test Test_To_UString_Base10 avec octets quelconques : " & Adresse_String);
        pragma Assert (Adresse_String = "192.168.0.1");

        Put_Line("Fonction To_UString_Base10 OK");
    end Test_To_UString_Base10;

    procedure Test_Est_Compatible is
    begin

        Initialiser(Adresse1, 192, 168, 0, 0);
        Initialiser(Masque, 255, 255, 255, 255);
        Initialiser(Adresse2, 192, 168, 18, 22);
        Compatible := Est_Compatible(Adresse2, Masque, Adresse1);
        Put_Line("Test avec deux adresses partiellement différentes et un masque long : " & Boolean'Image(Compatible));
        pragma Assert (not Compatible);

        Initialiser(Masque, 255, 255, 0, 0);
        Compatible := Est_Compatible(Adresse2, Masque, Adresse1);
        Put_Line("Test avec deux adresses partiellement différentes et un masque court : " & Boolean'Image(Compatible));
        pragma Assert (Compatible);

        Put_Line("Fonction Est_Compatible OK");
    end Test_Est_Compatible;

    procedure Test_Sup_Masque is
    begin

        Initialiser(Adresse1, 0, 0, 0, 0);
        Initialiser(Adresse2, 0, 0, 0, 0);
        SupMasque := Sup_Masque(Adresse1, Adresse2);
        Put_Line("Test avec deux adresses égales : " & Boolean'Image(SupMasque));
        pragma Assert (SupMasque);

        Initialiser(Adresse1, 0, 0, 0, 1);
        SupMasque := Sup_Masque(Adresse1, Adresse2);
        Put_Line("Test avec Adresse de gauche supérieure à Adresse de droite : " & Boolean'Image(SupMasque));
        pragma Assert (SupMasque);

        SupMasque := Sup_Masque(Adresse2, Adresse1);
        Put_Line("Test avec Adresse de droite supérieure à Adresse de gauche : " & Boolean'Image(SupMasque));
        pragma Assert (not SupMasque);

        Put_Line("Fonction Sup_Masque OK");
    end Test_Sup_Masque;

begin

    Put_Line("Test de la fonction Initialiser :");
    Test_de_la_fonction_Initialiser;
    New_Line;
    Put_Line("------------------------------------------------------------------------");
    New_Line;
    Put_Line("Test de la fonction Lire_Adresse :");
    Test_de_la_fonction_Lire_Adresse;
    New_Line;
    Put_Line("------------------------------------------------------------------------");
    New_Line;
    Put_Line("Test de la fonction Est_Compatible :");
    Test_Est_Compatible;
    New_Line;
    Put_Line("------------------------------------------------------------------------");
    New_Line;
    Put_Line("Test de la fonction To_UString_Base10 :");
    Test_To_UString_Base10;
    New_Line;
    Put_Line("------------------------------------------------------------------------");
    New_Line;
    Put_Line("Test de la fonction Sup_Masque :");
    Test_Sup_Masque;

end Test_Adresse_IP;