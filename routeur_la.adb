with Ada.Command_Line; use Ada.Command_Line;
with Ada.Text_IO; use Ada.Text_IO;
with Ada.Strings; use Ada.Strings;
with Ada.Text_IO.Unbounded_IO;  use Ada.Text_IO.Unbounded_IO;
with Ada.Integer_Text_IO; use Ada.Integer_Text_IO;
with Ada.Float_Text_IO; use Ada.Float_Text_IO;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;
with Adresse_IP; use Adresse_IP;
with Routage; use Routage;
with Cache_A; use Cache_A;
with Outils; use Outils;

procedure Routeur_LA is
    
    procedure Initialiser_Options (taille_cache : out Integer; politique : out Unbounded_String ; afficher_stat : out Boolean ; 
        f_table : out Unbounded_String ; f_paquet : out Unbounded_String ; f_resultat : out Unbounded_String ) is

        i : Integer := 1;
    begin
        while i <= Argument_Count loop
            
            if Argument(i) = "-c" or Argument(i) = "-P" or Argument(i) = "-t" or Argument(i) = "-p" or Argument(i) = "-r" then
                
                if i+1 <= Argument_Count then

                    if Argument(i) = "-c" then
                        begin
                            taille_cache := Integer'Value(Argument(i+1));
                            exception
                                -- Erreur levée si l'argument après -c n'est pas un entier
                                when CONSTRAINT_ERROR =>
                                    Afficher_Erreur("L'option -c prend un entier en Argument");
                        end;

                    elsif Argument(i) = "-P" then
                        politique := +Argument(i+1);
                        if not (politique = +"FIFO" or politique = +"LFU" or politique = +"LRU") then
                            Afficher_Erreur("Politique choisie inconnue");
                        end if;

                    elsif Argument(i) = "-t" then
                        f_table := +Argument(i+1);
                        if Tail(f_table, 4) /= ".txt" then
                            Afficher_Erreur("Nom de fichier de table incorrect");
                        end if;
                    
                    elsif Argument(i) = "-p" then
                        f_paquet := +Argument(i+1);
                        if Tail(f_paquet, 4) /= ".txt" then
                            Afficher_Erreur("Nom de fichier de paquet incorrect");
                        end if;
                    
                    elsif Argument(i) = "-r" then
                        f_resultat := +Argument(i+1); 
                        if Tail(f_resultat, 4) /= ".txt" then
                            Afficher_Erreur("Nom de fichier de resultat incorrect");
                        end if;
                    end if;

                    i := i + 2;

                else
                    Afficher_Erreur("Mauvais nombre d'argument");
                end if;
            
            elsif Argument(i) = "-s" or Argument(i) = "-S" then
                afficher_stat := (Argument(i) = "-s");
                i := i + 1;
            else
                Afficher_Erreur("Option non reconnue");
            end if;
        end loop;
    end Initialiser_Options;

    procedure Importer_Table (Table_Routage : in out T_Table_Routage ; f_table : in Unbounded_String) is
        FD_Table : File_Type;
        Route : T_Route;
    begin
        Open(FD_Table, In_File, To_String(f_table));
        -- Ouvrir f_table en lecture
        Initialiser (Table_Routage);
        -- Parcourir les lignes du fichier
        begin
        while not End_Of_File(FD_Table) loop
        -- Séparer la ligne courante en Destination | Masque | Interface

            Lire_Adresse (Route.Adresse, FD_Table); -- Destination
            Lire_Adresse (Route.Masque, FD_Table); -- Masque
            Route.Port := Get_line(FD_Table); -- Interface
            Trim(Route.Port, Both); -- Supprimer les espaces blancs


            -- Enregistrer la ligne courante dans la table de routage
            Enregistrer(Table_Routage, Route);

        end loop;
        exception
            when End_Error =>
                Put("Attention, Blancs en surplus à la fin du fichier : " & f_table);
        end;
        Close(FD_Table);
    end Importer_Table;

    procedure Enregister_Resultat (Fichier : File_Type ; Route : T_Route) is
    begin
        Put(Fichier, To_UString_Base10(Route.Adresse));
        Put(Fichier, " ");
        Put(Fichier, Route.Port);
        New_Line(Fichier);
    end Enregister_Resultat;

    procedure Afficher_Stats (CompteurDefaultCache : in Integer ; CompteurDemandeRoute : in Integer) is
    begin
        Put("Nombre de paquets traités : ");
        Put(CompteurDemandeRoute, 1);
        New_Line;
        Put("Nombre de paquets absents dans le cache : ");
        Put(CompteurDefaultCache, 1);
        New_Line;
        Put("Taux de paquets absents dans le cache : ");
        Put(CompteurDefaultCache * 100 / CompteurDemandeRoute, 1);
        Put("%");
        New_Line;
        New_Line;
    end Afficher_Stats;

    -- Valeur par défault des options
    taille_cache : Integer := 10;
    politique : Unbounded_String := +"LRU";
    afficher_stat : Boolean := True;
    f_table : Unbounded_String :=  +"table.txt";
    f_paquet : Unbounded_String := +"paquet.txt";
    f_resultat : Unbounded_String := +"resultats.txt";

    -- Structures de données utilisées par le programme
    Table_Routage : T_Table_Routage;
    Cache : T_Cache;

    -- Descripteur de fichier pour les entrées sorties
    FD_Resultat : File_Type;
    FD_Paquet : File_Type;

    Paquet : T_adresse_ip;
    Route : T_Route;
    Commande : T_Commandes;

    CompteurDefaultCache : Integer := 0;
    CompteurDemandeRoute : Integer := 0;

begin
    -- Initialiser les options à partir des arguments en ligne de commande
    Initialiser_Options (taille_cache, politique, afficher_stat, f_table, f_paquet, f_resultat);
    
    -- Importer la table de routage depuis le fichier
    Importer_Table (Table_Routage, f_table);
    
    -- Associer chaque paquet à une InterfaceLue
    Open(FD_Paquet, In_File, To_String(f_paquet));
    Create(FD_Resultat, Out_File, To_String(f_resultat));

    -- Initialiser le cache
    Initialiser (Cache, taille_cache);

    begin
    while not End_Of_File(FD_Paquet) loop
    begin
    
        -- Lecture d'un Paquet
        Lire_Adresse (Paquet, FD_Paquet);

        -- Chercher la route associée au paquet
        Route := Chercher (Cache, Paquet);
        CompteurDemandeRoute := CompteurDemandeRoute + 1;

        if Route.Port = +"null" then
            CompteurDefaultCache := CompteurDefaultCache + 1;
            Route := Chercher_Route (Table_Routage, Paquet);
            Enregistrer (Cache, Route, To_String(politique));
        else
            Mettre_a_jour (Cache, Route, To_string(politique));
        end if;

        -- Enregistrer le résultat dans le fichier de sortie
        Enregister_Resultat (FD_Resultat, Route);

    exception
        when Data_Error =>
            Lire_Commande (FD_Paquet, Commande);
            Put("(Ligne : ");
            Put(Integer(Line(FD_Paquet))-1, 1);
            put(") Commande : ");
            case Commande is
                when C_table =>
                    Afficher_Table_Routage (Table_Routage);
                when C_cache =>
                    Afficher_Cache (Cache);
                when C_stat =>
                    Afficher_Stats (CompteurDefaultCache, CompteurDemandeRoute);
                when C_fin =>
                    exit;
            end case;
    end;
    end loop;
    
    
    exception
        when End_Error =>
            Put("Attention, Blancs en surplus à la fin du fichier : " & f_paquet);
    end;
    Close(FD_Paquet);
    Close(FD_Resultat);

    if afficher_stat then
        Afficher_Stats (CompteurDefaultCache, CompteurDemandeRoute);
    end if;

    -- Vider la table de routage et le cache à la fin de leurs utilisations    
    Vider(Table_Routage);
    Vider(Cache);

    exception
        when Option_Erreur =>
            Afficher_Utilisation;
end Routeur_LA;