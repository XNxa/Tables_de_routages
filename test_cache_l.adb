with Ada.Text_IO; use Ada.Text_IO;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;
with Adresse_IP; use Adresse_IP;
with Outils; use Outils;
with Ada.Strings.Fixed; use Ada.Strings.Fixed;
with Ada.Integer_Text_IO; use Ada.Integer_Text_IO;
with Ada.Text_IO.Unbounded_IO; use Ada.Text_IO.Unbounded_IO;
with Cache_L; use Cache_L;

procedure Test_Cache_L is
    
    
    My_Cache : T_Cache;
    PaquetARouter : T_adresse_ip;
    Route1, Route2, Route3, Route4 : T_Route;
   -- FIFO : String := "FIFO";
   -- LFU : String := "LFU";
    Result : T_Route;

    

    procedure Initialisation_cache is
    begin
        Initialiser(My_Cache, 3);
    end Initialisation_cache;
    
    procedure Test_Enregistrer is
    begin
        Put_Line("Test de la fonction Enregistrer pour un Cache non plein");

        Initialiser(Route1.Adresse, 10, 0, 0, 0);
        Initialiser(Route1.Masque, 255, 255, 255, 0);
        Route1.Port := +"Interface1";
        Enregistrer(My_Cache, Route1, "LRU");

        Initialiser(Route2.Adresse, 192, 168, 1, 0);
        Initialiser(Route2.Masque, 255, 255, 255, 0);
        Route2.Port := +"Interface2";
        Enregistrer(My_Cache, Route2, "LRU");

        Initialiser(Route3.Adresse, 172, 16, 0, 0);
        Initialiser(Route3.Masque, 255, 240, 0, 0);
        Route3.Port := +"Interface3";
        Enregistrer(My_Cache, Route3, "LRU");

        Afficher_Cache(My_Cache);

        Put_Line("Fonction Enregistrer OK");
        New_Line;
    end Test_Enregistrer;


    procedure Test_Chercher is

    begin
        Put_Line("Test de la fonction Chercher ");

        Initialiser(PaquetARouter, 10, 0, 0, 1);
        Result := Chercher(My_Cache, PaquetARouter);
        Put_Line("Route trouvée pour l'adresse 10.0.0.1 : " &Result.Port );
        pragma Assert (Result.Port = "Interface1" );

        Initialiser(PaquetARouter, 192, 168, 1, 1);
        Result := Chercher(My_Cache, PaquetARouter);
        Put_Line("Route trouvée pour l'adresse 192.168.1.1 : " &Result.Port );
        pragma Assert (Result.Port = "Interface2" );

        Initialiser(PaquetARouter, 100, 0, 1, 1);
        Result := Chercher(My_Cache, PaquetARouter);
        Put_Line("Route trouvée pour l'adresse 100.0.1.1 : " &Result.Port );
        pragma Assert (Result.Port = "null" );

        New_Line;
        Put_Line("Fonction Chercher OK");
        New_Line;
    end Test_Chercher;

    procedure Test_Enregistrer_FIFO is
    begin

        Put_Line("Test de la fonction Enregistrer avec un Cache plein en politique FIFO");
        New_Line;
        Put_Line("Cache avant modification : ");
        Afficher_Cache(My_Cache);
        Initialiser(Route4.Adresse, 28, 35, 0, 0);
        Initialiser(Route4.Masque, 255, 255, 255, 0);
        Route4.Port := +"Interface4";
        Enregistrer(My_Cache, Route4, "FIFO");
        Put_Line("Cache après modification : " );
        Afficher_Cache(My_Cache);
        Put_Line("La route modifiée est bien la première à avoir été enregistrée (Interface1)");
        New_Line;

    end Test_Enregistrer_FIFO;


    procedure Test_Mettre_a_jour_LRU is
    begin
        Put_Line("Test de la fonction Enregistrer avec un Cache plein en politique FIFO");
        New_Line;
        Put_Line("On utilise les routes du Cache dans l'ordre suivant :");
        Initialiser(PaquetARouter, 192, 168, 1, 1);
        Result := Chercher(My_Cache, PaquetARouter);
        Mettre_a_jour(My_Cache, Result, "LRU"); 
        Put(To_UString_Base10(Result.Adresse));
        Put(" ");
        Put(To_UString_Base10(Result.Masque));
        Put(" ");
        Put_Line(Result.Port);
        Initialiser(PaquetARouter, 172, 16, 1, 1);
        Result := Chercher(My_Cache, PaquetARouter);
        Mettre_a_jour(My_Cache, Result, "LRU"); 
        Put(To_UString_Base10(Result.Adresse));
        Put(" ");
        Put(To_UString_Base10(Result.Masque));
        Put(" ");
        Put_Line(Result.Port);
        Initialiser(PaquetARouter, 28, 35, 0, 55);
        Result := Chercher(My_Cache, PaquetARouter);
        Mettre_a_jour(My_Cache, Result, "LRU"); 
        Put(To_UString_Base10(Result.Adresse));
        Put(" ");
        Put(To_UString_Base10(Result.Masque));
        Put(" ");
        Put_Line(Result.Port);




        --Route3.Port := To_Unbounded_String("Interface5");
      --  Mettre_a_jour(My_Cache, Route3, "LRU");
      --  Result := Chercher(My_Cache, PaquetARouter);
       -- Put_Line("Route après modification : " &Result.Port);
       -- Afficher_Cache(My_Cache);
    end Test_Mettre_a_jour_LRU;


    procedure Test_Mettre_a_jour_LFU is
    begin

        Initialiser(PaquetARouter, 192, 168, 1, 1);
        Result := Chercher(My_Cache, PaquetARouter);
        Put_Line("Route avant modification : " &Result.Port);
        Route3.Port := To_Unbounded_String("Interface6");
        Mettre_a_jour(My_Cache, Route3, "LFU");
        Result := Chercher(My_Cache, PaquetARouter);
        Put_Line("Route après modification : " &Result.Port);
        Afficher_Cache(My_Cache);
    end Test_Mettre_a_jour_LFU;

    procedure Test_Vider is
    begin
        Vider(My_Cache);
        Afficher_Cache(My_Cache);
    end Test_Vider;


begin

    Initialisation_cache;
    New_Line;
    Put_Line("------------------------------------------------------------------------");
    New_Line;
    Test_Enregistrer;
    New_Line;
    Put_Line("------------------------------------------------------------------------");
    New_Line;
    Test_Chercher;
    New_Line;
    Put_Line("------------------------------------------------------------------------");
    New_Line;
    Test_Enregistrer_FIFO;
    New_Line;
    Put_Line("------------------------------------------------------------------------");
    New_Line;
    Test_Mettre_a_jour_LRU;
   -- Test_Mettre_a_jour_LFU;
    
    Test_Vider;

end Test_Cache_L;