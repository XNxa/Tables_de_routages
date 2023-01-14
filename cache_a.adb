with Ada.Unchecked_Deallocation;

package body Cache_a is

    procedure Free is 
        new Ada.Unchecked_Deallocation (T_Cellule, T_Cache);

    procedure Initialiser (Cache : out T_Cache ; Taille : in Integer) is
        AdresseVide : T_Adresse_IP;
    begin
        Initialiser (AdresseVide, 0, 0, 0, 0);
        ROUTEVIDE := (AdresseVide, AdresseVide, +"null");

        Taille_Max_cache := Taille;
        
        Ordre.TailleEffective := 0;

        Cache := new T_Cellule'(ROUTEVIDE, null, null, True);
        
    end Initialiser;

    procedure Ajouter (Cache : in out T_Cache ; Route : in T_Route) is
        procedure Ajouter_b (Cache : in out T_Cache ; Route : in T_Route ; index : in Integer) is
        begin
            if Valeur_Bit(Route.Adresse, index) then
                if Cache.All.Droite = null then
                    Cache.All.estNoeud := True;
                    Cache.All.Droite := new T_Cellule'(Route, Null, Null, False);
                elsif Cache.All.Droite.All.estNoeud then
                    Ajouter_b(Cache.All.Droite, Route, index + 1);
                else
                    Cache.All.Droite.All.estNoeud := True;
                    Ajouter_b(Cache.All.Droite, Cache.All.Droite.All.Route, index + 1);
                    Ajouter_b(Cache.All.Droite, Route, index + 1);
                end if;
            else
                if Cache.Gauche = null then
                    Cache.All.estNoeud := True;
                    Cache.Gauche := new T_Cellule'(Route, Null, Null, False);
                elsif Cache.All.Gauche.All.estNoeud then
                    Ajouter_b(Cache.All.Gauche, Route, index + 1);
                else
                    Cache.All.Gauche.All.estNoeud := True;
                    Ajouter_b(Cache.All.Gauche, Cache.All.Gauche.All.Route, index + 1);
                    Ajouter_b(Cache.All.Gauche, Route, index + 1);
                end if;
            end if;
        end Ajouter_b;
    begin
        Ajouter_b(Cache, Route, 1);
    end Ajouter;

    procedure Supprimer (Cache : in out T_Cache ; Route : in T_Route) is
        procedure Supprimer_b (Cache : in out T_Cache ; Route : in T_Route ; index : in Integer) is
            A_detruire : T_Cache;
        begin
            if Valeur_Bit(Route.Adresse, index) then
                if Cache.All.Droite /= null then
                    if Cache.All.Droite.All.estNoeud then
                        Supprimer_b(Cache.All.Droite, Route, index + 1);
                        if Cache.All.Droite.All.Droite /= null and then ((not Cache.All.Droite.All.Droite.All.estNoeud) and Cache.All.Droite.All.Gauche = null) then
                            A_detruire := Cache.All.Droite;
                            Cache.all.Droite := Cache.All.Droite.All.Droite;
                            Free(A_detruire);
                        elsif Cache.All.Droite.All.Gauche /= null and then ((not Cache.All.Droite.all.Gauche.All.estNoeud) and Cache.All.Droite.All.Droite = null) then
                            A_detruire := Cache.All.Droite;
                            Cache.all.Droite := Cache.All.Droite.All.Gauche;
                            Free(A_detruire);
                        end if;
                    elsif Cache.All.Droite.All.Route = Route then
                        Free(Cache.All.Droite);
                        Cache.All.Droite := null;
                    end if;
                end if;
            else
                if Cache.All.Gauche /= null then
                    if Cache.All.Gauche.All.estNoeud then
                        Supprimer_b(Cache.All.Gauche, Route, index + 1);
                        if Cache.All.Gauche.All.Droite /= null and then ((not Cache.All.Gauche.All.Droite.All.estNoeud) and Cache.All.Gauche.All.Gauche = null) then
                            A_detruire := Cache.All.Gauche;
                            Cache.all.Gauche := Cache.All.Gauche.All.Droite;
                            Free(A_detruire);
                        elsif Cache.All.Gauche.All.Gauche /= null and then ((not Cache.All.Gauche.All.Gauche.All.estNoeud) and Cache.All.Gauche.All.Droite = null) then
                            A_detruire := Cache.All.Gauche;
                            Cache.all.Gauche := Cache.All.Gauche.All.Gauche;
                            Free(A_detruire);
                        end if;
                    elsif Cache.All.Gauche.All.Route = Route then
                        Free(Cache.All.Gauche);
                        Cache.All.Gauche := null;
                    end if;
                end if;
            end if;
        end Supprimer_b;
    begin
        Supprimer_b(Cache, Route, 1);
    end Supprimer;

    function Chercher (Cache : in T_Cache; PaquetARouter : in T_Adresse_IP) return T_Route is
        function Chercher_b (Cache : in T_Cache; PaquetARouter : in T_Adresse_IP; index : in Integer) return T_Route is
        begin
            if Cache.All.estNoeud then
                if Valeur_Bit(PaquetARouter, index) then
                    if Cache.All.Droite /= null then
                        return Chercher_b(Cache.All.Droite, PaquetARouter, index + 1);
                    else
                        return ROUTEVIDE;
                    end if;
                else
                    if Cache.All.Gauche /= null then
                        return Chercher_b(Cache.All.Gauche, PaquetARouter, index + 1);
                    else
                        return ROUTEVIDE;
                    end if;
                end if;
            elsif Est_Compatible(PaquetARouter, Cache.All.Route.Masque, Cache.All.Route.Adresse) then
                return Cache.All.Route;
            else
                return ROUTEVIDE;
            end if;
        end Chercher_b;
    begin
        return Chercher_b(Cache, PaquetARouter, 1);
    end Chercher;

    procedure Mettre_a_jour (Cache : in out T_Cache; Route : in T_Route ; politique : in String) is
    begin
        if politique = "LRU" then
            for i in 1 .. Ordre.TailleEffective loop
                if Ordre.Tab(i) = Route then
                    Ordre.Tab(i) := Ordre.Tab(Ordre.TailleEffective);
                    Ordre.Tab(Ordre.TailleEffective) := Route;
                    return;
                end if;
            end loop;
        else
            raise Politique_Non_Supportee_Error;
        end if;
    end Mettre_a_jour;

    procedure Enregistrer (Cache : in out T_Cache; Route : in T_Route ; politique : in String) is
    begin 
        if politique = "LRU" then
            if Ordre.TailleEffective >= Taille_Max_cache then
                Supprimer(Cache, Ordre.Tab(1));
                Ajouter(Cache, Route);
                for i in 1 .. Ordre.TailleEffective - 1 loop
                    Ordre.Tab(i) := Ordre.Tab(i + 1);
                end loop;
                Ordre.Tab(Ordre.TailleEffective) := Route;
            else
                Ajouter(Cache, Route);
                Ordre.TailleEffective := Ordre.TailleEffective + 1;
                Ordre.Tab(Ordre.TailleEffective) := Route;
            end if;
            Supprimer(Cache, Route);
            Ajouter(Cache, Route);
        else
            raise Politique_Non_Supportee_Error;
        end if;
    end Enregistrer;

    procedure Afficher_Cache (Cache : in T_Cache) is
        procedure Afficher_Cache_b (Cache : in T_Cache) is
        begin
            if Cache /= null then
                if not Cache.All.estNoeud then
                    Afficher_Route(Cache.All.Route);
                else
                    if Cache.All.Droite /= null then
                        Afficher_Cache_b(Cache.All.Droite);
                    end if;
                    if Cache.All.Gauche /= null then
                        Afficher_Cache_b(Cache.All.Gauche);
                    end if;
                end if;
            end if;
        end Afficher_Cache_b;
    begin
        Put_Line("Cache : ");
        Afficher_Cache_b(Cache);
        New_Line;
    end Afficher_Cache;

    procedure Vider (Cache : in out T_Cache) is
    begin
        if Cache.All.Droite /= null then
            Vider(Cache.All.Droite);
        end if;
        if Cache.All.Gauche /= null then
            Vider(Cache.All.Gauche);
        end if;
        Free(Cache);
        Cache := null;
    end Vider;

end Cache_a;