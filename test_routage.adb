with Ada.Text_IO; use Ada.Text_IO;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;
with Routage; use Routage;
with Adresse_IP; use Adresse_IP;
with outils ; use outils ;
with Ada.Strings.Fixed; use Ada.Strings.Fixed;
with Ada.Integer_Text_IO; use Ada.Integer_Text_IO;
with Ada.Text_IO.Unbounded_IO; use Ada.Text_IO.Unbounded_IO;

procedure Test_Routage is
    
    Table_Routage : T_Table_Routage;
    PaquetARouter : T_adresse_ip;
    Destination1, Destination2, Destination3 : T_adresse_ip;
    Masque1, Masque2, Masque3 : T_adresse_ip;
    Interface1, Interface2, Interface3, InterfaceRoute ,Adresse_a_retourner: Unbounded_String;
    Route : T_Route;
    Octet1, Octet2, Octet3, Octet4 : Integer;


    procedure Initialisation_table_routage is
    begin
        Initialiser(Table_Routage);
    end Initialisation_table_routage;

    procedure test_Enregistrer is
    begin
        Octet1 := 10;
        Octet2 := 0;
        Octet3 := 0;
        Octet4 := 0;
        Initialiser(Destination1, Octet1, Octet2, Octet3, Octet4);
        Octet1 := 255;
        Octet2 := 255;
        Octet3 := 255;
        Octet4 := 0;
        Initialiser(Masque1, Octet1, Octet2, Octet3, Octet4);
        Interface1 := To_Unbounded_String("Interface1");
        Enregistrer(Table_Routage, Destination1, Masque1, Interface1);

        Octet1 := 192;
        Octet2 := 168;
        Octet3 := 1;
        Octet4 := 0;
        Initialiser(Destination2, Octet1, Octet2, Octet3, Octet4);
        Octet1 := 255;
        Octet2 := 255;
        Octet3 := 255;
        Octet4 := 0;
        Initialiser(Masque2, Octet1, Octet2, Octet3, Octet4);
        Interface2 := To_Unbounded_String("Interface2");
        Enregistrer(Table_Routage, Destination2, Masque2, Interface2);

        Octet1 := 172;
        Octet2 := 16;
        Octet3 := 0;
        Octet4 := 0;
        Initialiser(Destination3, Octet1, Octet2, Octet3, Octet4);
        Octet1 := 255;
        Octet2 := 240;
        Octet3 := 0;
        Octet4 := 0;
        Initialiser(Masque3, Octet1, Octet2, Octet3,Octet4);
        Interface3 := To_Unbounded_String("Interface3");
        Enregistrer(Table_Routage, Destination3, Masque3, Interface3);

        Afficher_Table_Routage(Table_Routage);


    end test_Enregistrer;

    procedure Test_Chercher_Route is
    begin
        Octet1 := 10;
        Octet2 := 0;
        Octet3 := 0;
        Octet4 := 1;
        Initialiser(PaquetARouter, Octet1, Octet2, Octet3, Octet4);
        Route := Chercher_Route(Table_Routage, PaquetARouter);
        Put_Line("Route trouvée pour l'adresse 10.0.0.1 : " &Route.Port );

        Octet1 := 192;
        Octet2 := 168;
        Octet3 := 1;
        Octet4 := 1;
        Initialiser(PaquetARouter, Octet1, Octet2, Octet3, Octet4);
        Route := Chercher_Route(Table_Routage, PaquetARouter);
        Put_Line("Route trouvée pour l'adresse 192.168.1.1 : " &Route.Port );


        Octet1 := 172;
        Octet2 := 16;
        Octet3 := 1;
        Octet4 := 1;
        Initialiser(PaquetARouter, Octet1, Octet2, Octet3, Octet4);
        Route := Chercher_Route(Table_Routage, PaquetARouter);
        Put_Line("Route trouvée pour l'adresse 172.16.1.1 : " &Route.Port );

        Octet1 := 100;
        Octet2 := 0;
        Octet3 := 0;
        Octet4 := 1;
        Initialiser(PaquetARouter, Octet1, Octet2, Octet3, Octet4);
        Route := Chercher_Route(Table_Routage, PaquetARouter);
        Put_Line("Route trouvée pour l'adresse 100.0.0.1 : " &Route.Port );

    end Test_Chercher_Route;

begin

    Put_Line("Test de la fonction Enregistrer :");
    test_Enregistrer;
    New_Line;
    Put_Line("Test de la fonction Chercher_Route :");
    Test_Chercher_Route;
     
    

end Test_Routage;