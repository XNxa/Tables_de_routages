    


package body Cache_liste is
    
    -- Ajouter une adresse IP dans le cache (au debut de la liste chainée)
    procedure Ajouter_Debut (Cache : in out T_Cache; Adresse : in T_Adresse_IP; Masque : in T_adresse_ip ; interface : in Unbounded_String);

    -- Ajouter une adresse IP dans le cache (à la fin de la liste chainée)
    procedure Ajouter_Fin (Cache : in out T_Cache; Adresse : in T_Adresse_IP; Masque : in T_adresse_ip ; interface : in Unbounded_String);

    -- Supprimer une adresse IP du cache
    procedure Supprimer (Cache : in out T_Cache; Adresse : in T_Adresse_IP; Masque : in T_adresse_ip ; interface : in Unbounded_String);
        A_Supprimer : T_Donnee_cache;
    begin
        A_Supprimer.Adresse_IP := Adresse;
        A_Supprimer.Masque := Masque;
        A_Supprimer.Port := interface;
        A_Supprimer.Frequence := 1;
        Liste_Cache.Supprimer (Cache.All, A_Supprimer);
    end Supprimer;
    
    procedure AugmenterFrequence (Cache : in out T_Cache; Adresse : in T_Adresse_IP; Masque : in T_adresse_ip ; interface : in Unbounded_String);


    -- Initialiser le cache
    procedure Initialiser (Cache : out T_Cache) is
    begin
        Cache := new T_Liste;
        Initialiser (Cache.All);
    end Initialiser;

    procedure MettreAJour (Cache : in out T_Cache; Adresse : in T_Adresse_IP; Masque : in T_adresse_ip ; Port : in Unbounded_String ; politique : String ) is
    begin
        if Politique = "LRU" then
            Supprimer (Cache, Adresse, Masque, Port);
            Ajouter_Debut (Cache, Adresse, Masque, Port);
        elsif Politique = "LFU" then
            AugmenterFrequence (Cache, Adresse, Masque, Port);
        else 
            pragma Assert (Politique = "FIFO");
            Null;
        end if;
    end MettreAJour;

    procedure Enregistrer (Cache : in out T_Cache; Adresse : in T_Adresse_IP; Masque : in T_adresse_ip ; Port : in Unbounded_String ; politique : String ) is
    begin
        if Taille(Cache.All) = Taille_Cache then
            Supprimer (Cache, La_Donnee(Cache, Taille_Cache));
        end if;

        if Politique = "LRU" or Politique = "FIFO" then
                Ajouter_Debut (Cache, Adresse, Masque, Port);
        else
            pragma Assert (Politique = "LFU");
            Ajouter_Fin (Cache, Adresse, Masque, Port);
        end if;
    end Enregistrer;

    -- Vide le cache
    procedure Vider (Cache : in out T_Cache) is
    begin
        Vider (Cache.All);
        Cache := null;
    end Vider;

end Cache_liste;