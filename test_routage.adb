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
    Interface1, Interface2, Interface3, InterfaceRoute ,Adresse_a_retourner: Unbounded_String;
    Route,Route1, Route2, Route3, Route4 : T_Route;

    procedure Initialisation_table_routage is
    begin
        Initialiser(Table_Routage);
    end Initialisation_table_routage;

    procedure test_Enregistrer is
    begin

        Initialiser(Route1.Adresse, 10, 0, 0, 0);
        Initialiser(Route1.Masque, 255, 255, 255, 0);
        Route1.Port := +"Interface1";
        Enregistrer(Table_Routage, Route1);

        Initialiser(Route2.Adresse, 192, 168, 1, 0);
        Initialiser(Route2.Masque, 255, 255, 255, 0);
        Route2.Port := +"Interface2";
        Enregistrer(Table_Routage, Route2);

        Initialiser(Route3.Adresse, 172, 16, 0, 0);
        Initialiser(Route3.Masque, 255, 240, 0,0);
        Route3.Port := +"Interface3";
        Enregistrer(Table_Routage, Route3);

        Initialiser(Route4.Adresse, 0, 0, 0, 0);
        Initialiser(Route4.Masque, 0, 0, 0, 0);
        Route4.Port := +"Interface4";
        Enregistrer(Table_Routage, Route4);

        Afficher_Table_Routage(Table_Routage);


    end test_Enregistrer;

    procedure Test_Chercher_Route is
    begin

        Initialiser(PaquetARouter, 10, 0, 0, 1);
        Route := Chercher_Route(Table_Routage, PaquetARouter);
        Put_Line("Route trouvée pour l'adresse 10.0.0.1 : " &Route.Port );
        pragma Assert (Route.Port = "Interface1" );

        Initialiser(PaquetARouter,  192, 168, 1, 1);
        Route := Chercher_Route(Table_Routage, PaquetARouter);
        Put_Line("Route trouvée pour l'adresse 192.168.1.1 : " &Route.Port );
        pragma Assert (Route.Port = "Interface2" );

        Initialiser(PaquetARouter, 172, 16, 1, 1);
        Route := Chercher_Route(Table_Routage, PaquetARouter);
        Put_Line("Route trouvée pour l'adresse 172.16.1.1 : " &Route.Port );
        pragma Assert (Route.Port = "Interface3" );

        Initialiser(PaquetARouter, 100, 0, 0, 1);
        Route := Chercher_Route(Table_Routage, PaquetARouter);
        Put_Line("Route trouvée pour l'adresse 100.0.0.1 : " &Route.Port );
        pragma Assert (Route.Port = "Interface4" );

    end Test_Chercher_Route;

    procedure test_Vider is
    begin
        Vider(Table_Routage);
        Afficher_Table_Routage(Table_Routage);
        Put_Line ("La table à bien était vidée");
    end test_Vider;

begin

    Put_Line("Test de la fonction Enregistrer :");
    test_Enregistrer;
    New_Line;
    Put_Line("------------------------------------------------------------------------");
    New_Line;
    Put_Line("Test de la fonction Chercher_Route :");
    Test_Chercher_Route;
    New_Line;
    Put_Line("------------------------------------------------------------------------");
    New_Line;
    Put_Line("Test de la fonction Vider :");
    test_Vider;

end Test_Routage;