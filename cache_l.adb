with Ada.Unchecked_Deallocation;
with Ada.Text_IO.Unbounded_IO;  use Ada.Text_IO.Unbounded_IO;
with Ada.Text_IO; use Ada.Text_IO;


package body Cache_L is
    
    procedure Free is
        new Ada.Unchecked_Deallocation(Object => T_Cellule, Name => T_Cache);

    function Cache_plein (Cache : in T_Cache) return Boolean is
        Cache_aux : T_Cache := Cache;
        i : Integer := 0;
    begin
        while Cache_aux /= null loop
            i := i + 1;
            Cache_aux := Cache_aux.all.Suivant;
        end loop;
        return (i = Taille_du_Cache);
    end Cache_plein;

    procedure Supprimer (Cache : in out T_Cache; Route : in T_Route) is
        A_detruire : T_Cache;
    begin
        if Cache /= null then
            if Cache.All.Route = Route then
                A_detruire := Cache;
                Cache := Cache.all.Suivant;
                Free (A_detruire);
            else
                Supprimer (Cache.all.Suivant, Route);
            end if;
        else
            raise Route_Absente_Error;
        end if;
    end Supprimer;

    procedure Supprimer_Fin (Cache : in out T_Cache) is
        A_detruire : T_Cache;
    begin
        if Cache /= null then
            if Cache.Suivant = null then
                A_detruire := Cache;
                Cache := null;
                Free (A_detruire);
            else
                Supprimer_Fin (Cache.Suivant);
            end if;
        else
            raise Cache_Vide_Error;
        end if;
    end Supprimer_Fin;

    procedure Ajouter_Debut (Cache : in out T_Cache; Route : in T_Route) is
        Frequence : constant Integer := 1;
    begin
        Cache := new T_Cellule'(Route, Frequence, Cache);
    end Ajouter_Debut;

    procedure Ajouter_Fin (Cache : in out T_Cache; Route : in T_Route) is
        Frequence : constant Integer := 1;
    begin
        if Cache /= null then
            Ajouter_Fin (Cache.Suivant, Route);
        else
            Cache := new T_Cellule'(Route, Frequence, null);
        end if;
    end Ajouter_Fin;

    function Augmenter_Frequence (Cache : in T_Cache; Route : in T_Route) return Integer is
    begin
       if Cache /= null then
            if Cache.All.Route = Route then
                Cache.All.Frequence := Cache.All.Frequence + 1;
                return Cache.All.Frequence;
            else
                return Augmenter_Frequence (Cache.Suivant, Route);
            end if;
        else
            raise Route_Absente_Error;
        end if;
    end Augmenter_Frequence;

    procedure Ordonner_Liste (Cache : in out T_Cache ; Route : in T_route; Frequence : in Integer) is
    begin
        if Cache /= null and then Cache.all.Frequence <= Frequence then
            Supprimer (Cache, Route);
            Cache := new T_Cellule'(Route, Frequence, cache);
        else 
            Ordonner_Liste (Cache.Suivant, Route, Frequence);
        end if;
    end;

    procedure Initialiser (Cache : out T_Cache; taille : in Integer) is 
    begin
        Taille_du_Cache := taille;
        Cache := null;
    end Initialiser;

    function Chercher (Cache : in T_Cache; PaquetARouter : in T_Adresse_IP) return T_Route is
        Cache_aux : T_Cache := Cache; -- Pour parcourir la liste
        Route_non_trouvee : T_Route;
        Adresse_non_trouvee : T_Adresse_IP;
    begin
        Initialiser (Adresse_non_trouvee, 0, 0, 0, 0);
        Route_non_trouvee := T_Route'(Adresse_non_trouvee, Adresse_non_trouvee, +"null");

        while Cache_aux /= null and then not Est_Compatible(PaquetARouter, Cache_aux.All.Route.Masque, Cache_aux.All.Route.Adresse ) loop
            Cache_aux := Cache_aux.Suivant;
        end loop;

        if Cache_aux = null then
            return Route_non_trouvee;
        else
            return Cache_aux.All.Route;
        end if;

    end Chercher;

    procedure Mettre_a_jour (Cache : in out T_Cache; Route : in T_Route; politique : in String) is
        Frequence : Integer;
    begin
        if politique = "LRU" then
            Supprimer (Cache, Route);
            Ajouter_Debut (Cache, Route);

        elsif politique = "LFU" then
            Frequence := Augmenter_Frequence (Cache, Route);
            Ordonner_Liste (Cache, Route, Frequence);
        else 
            Pragma Assert (politique = "FIFO");
            null;

        end if;
    end Mettre_a_jour;

    procedure Enregistrer (Cache : in out T_Cache; Route : in T_Route ; politique : in String) is
    begin 
        if Cache_plein(Cache) then
            Supprimer_Fin (Cache);
        end if;

        if politique = "LRU" or politique = "FIFO" then
            Ajouter_Debut (Cache, Route);
        else 
            Pragma Assert (politique = "LFU");
            Ajouter_Fin (Cache, Route);
        end if;
    end Enregistrer;

    procedure Afficher_Cache (Cache : in T_Cache) is
        Cache_aux : T_Cache := Cache;
    begin
        Put_Line("Cache");
        while Cache_aux /= null loop
            Put(To_UString_Base10(Cache_aux.all.Route.Adresse));
            Put(" ");
            Put(To_UString_Base10(Cache_aux.all.Route.Masque));
            Put(" ");
            Put(Cache_aux.all.Route.Port);
            New_Line;
            Cache_aux := Cache_aux.Suivant;
        end loop;
        New_Line;
    end Afficher_Cache;

    procedure Vider (Cache : in out T_Cache) is
        A_detruire : T_Cache;
    begin
        while Cache /= null loop
            A_detruire := Cache;
            Cache := Cache.Suivant;
            Free (A_detruire);
        end loop;
    end Vider;

end Cache_L;