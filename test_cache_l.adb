with Ada.Text_IO; use Ada.Text_IO;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;
with Adresse_IP; use Adresse_IP;
with Outils; use Outils;
with Ada.Strings.Fixed; use Ada.Strings.Fixed;
with Ada.Integer_Text_IO; use Ada.Integer_Text_IO;
with Ada.Text_IO.Unbounded_IO; use Ada.Text_IO.Unbounded_IO;
with Cache_L;

procedure Test_Cache_L is
    
    package Cache is new Cache_L(Taille_Cache => 3);
    use Cache;
    -- Declare a variable to hold the cache
    My_Cache : T_Cache;

    -- Declare variables to hold test data
    PaquetARouter : T_adresse_ip;
    Route1, Route2, Route3 : T_Route;
    Octet1, Octet2, Octet3, Octet4 : Integer;
    politique : String := "LRU";
   -- FIFO : String := "FIFO";
   -- LFU : String := "LFU";
    Result : T_Route;

    

    procedure Initialisation_cache is
    begin
        Initialiser(My_Cache);
    end Initialisation_cache;
    
    procedure Test_Enregistrer is
    begin
        Octet1 := 10;
        Octet2 := 0;
        Octet3 := 0;
        Octet4 := 0;
        Initialiser(Route1.Adresse, Octet1, Octet2, Octet3, Octet4);
        Octet1 := 255;
        Octet2 := 255;
        Octet3 := 255;
        Octet4 := 0;
        Initialiser(Route1.Masque, Octet1, Octet2, Octet3, Octet4);
        Route1.Port := To_Unbounded_String("Interface1");
        Enregistrer(My_Cache, Route1, politique);

        Octet1 := 192;
        Octet2 := 168;
        Octet3 := 1;
        Octet4 := 0;
        Initialiser(Route2.Adresse, Octet1, Octet2, Octet3, Octet4);
        Octet1 := 255;
        Octet2 := 255;
        Octet3 := 255;
        Octet4 := 0;
        Initialiser(Route2.Masque, Octet1, Octet2, Octet3, Octet4);
        Route2.Port := To_Unbounded_String("Interface2");
        Enregistrer(My_Cache, Route2, politique);

        Octet1 := 172;
        Octet2 := 16;
        Octet3 := 0;
        Octet4 := 0;
        Initialiser(Route3.Adresse, Octet1, Octet2, Octet3, Octet4);
        Octet1 := 255;
        Octet2 := 240;
        Octet3 := 0;
        Octet4 := 0;
        Initialiser(Route3.Masque, Octet1, Octet2, Octet3, Octet4);

        Route3.Port := To_Unbounded_String("Interface3");
        Enregistrer(My_Cache, Route3, politique);
        Afficher_Cache(My_Cache);
    end Test_Enregistrer;


    procedure Test_Chercher is

    begin
        Octet1 := 10;
        Octet2 := 0;
        Octet3 := 0;
        Octet4 := 1;
        Initialiser(PaquetARouter, Octet1, Octet2, Octet3, Octet4);
        Result := Chercher(My_Cache, PaquetARouter);
        Put_Line("Route trouvée pour l'adresse 10.0.0.1 : " &Result.Port );

        Octet1 := 192;
        Octet2 := 168;
        Octet3 := 1;
        Octet4 := 1;
        Initialiser(PaquetARouter, Octet1, Octet2, Octet3, Octet4);
        Result := Chercher(My_Cache, PaquetARouter);
        Put_Line("Route trouvée pour l'adresse 192.168.1.1 : " &Result.Port );
    end Test_Chercher;

    procedure Test_Mettre_a_jour_FIFO is
    begin
        Octet1 := 192;
        Octet2 := 168;
        Octet3 := 1;
        Octet4 := 1;
        Initialiser(PaquetARouter, Octet1, Octet2, Octet3, Octet4);
        Result := Chercher(My_Cache, PaquetARouter);
        Put_Line("Route avant modification : " &Result.Port);
        Route3.Port := To_Unbounded_String("Interface4");
        Mettre_a_jour(My_Cache, Route3, "FIFO");
        Result := Chercher(My_Cache, PaquetARouter);
        Put_Line("Route après modification : " &Result.Port);
        Afficher_Cache(My_Cache);
    end Test_Mettre_a_jour_FIFO;


    procedure Test_Mettre_a_jour_LRU is
    begin
        Octet1 := 192;
        Octet2 := 168;
        Octet3 := 1;
        Octet4 := 1;
        Initialiser(PaquetARouter, Octet1, Octet2, Octet3, Octet4);
        Result := Chercher(My_Cache, PaquetARouter);
        Put_Line("Route avant modification : " &Result.Port);
        Route3.Port := To_Unbounded_String("Interface5");
        Mettre_a_jour(My_Cache, Route3, "LRU");
        Result := Chercher(My_Cache, PaquetARouter);
        Put_Line("Route après modification : " &Result.Port);
        Afficher_Cache(My_Cache);
    end Test_Mettre_a_jour_LRU;


    procedure Test_Mettre_a_jour_LFU is
    begin
        Octet1 := 192;
        Octet2 := 168;
        Octet3 := 1;
        Octet4 := 1;
        Initialiser(PaquetARouter, Octet1, Octet2, Octet3, Octet4);
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
    Test_Enregistrer;
    Test_Chercher;
    Test_Mettre_a_jour_FIFO;
    Test_Mettre_a_jour_LFU;
    Test_Mettre_a_jour_LRU;
    Test_Vider;

end Test_Cache_L;





