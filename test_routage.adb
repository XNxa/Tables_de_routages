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

    procedure Initialisation_table_routage is
    begin
        Initialiser(Table_Routage);
    end Initialisation_table_routage;

    procedure test_Enregistrer is
    begin

        Initialiser(Destination1, 10, 0, 0, 0);
        Initialiser(Masque1, 255, 255, 255, 0);
        Interface1 := To_Unbounded_String("Interface1");
        Enregistrer(Table_Routage, Destination1, Masque1, Interface1);

        Initialiser(Destination2, 192, 168, 1, 0);
        Initialiser(Masque2, 255, 255, 255, 0);
        Interface2 := To_Unbounded_String("Interface2");
        Enregistrer(Table_Routage, Destination2, Masque2, Interface2);

        Initialiser(Destination3, 172, 16, 0, 0);
        Initialiser(Masque3, 255, 240, 0,0);
        Interface3 := To_Unbounded_String("Interface3");
        Enregistrer(Table_Routage, Destination3, Masque3, Interface3);

        Afficher_Table_Routage(Table_Routage);


    end test_Enregistrer;

    procedure Test_Chercher_Route is
    begin

        Initialiser(PaquetARouter, 10, 0, 0, 1);
        Route := Chercher_Route(Table_Routage, PaquetARouter);
        Put_Line("Route trouvée pour l'adresse 10.0.0.1 : " &Route.Port );

        Initialiser(PaquetARouter,  192, 168, 1, 1);
        Route := Chercher_Route(Table_Routage, PaquetARouter);
        Put_Line("Route trouvée pour l'adresse 192.168.1.1 : " &Route.Port );

        Initialiser(PaquetARouter, 172, 16, 1, 1);
        Route := Chercher_Route(Table_Routage, PaquetARouter);
        Put_Line("Route trouvée pour l'adresse 172.16.1.1 : " &Route.Port );

        Initialiser(PaquetARouter, 100, 0, 0, 1);
        Route := Chercher_Route(Table_Routage, PaquetARouter);
        Put_Line("Route trouvée pour l'adresse 100.0.0.1 : " &Route.Port );

    end Test_Chercher_Route;

    procedure test_Vider is
    begin
        Vider(Table_Routage);
        Put_Line ("La table à bien était vidée");
    end test_Vider;

begin

    Put_Line("Test de la fonction Enregistrer :");
    test_Enregistrer;
    New_Line;
    Put_Line("Test de la fonction Chercher_Route :");
    Test_Chercher_Route;
    New_Line;
    Put_Line("Test de la fonction Vider :");
    test_Vider;

end Test_Routage;