with Ada.Command_Line; use Ada.Command_Line;
with Ada.Text_IO; use Ada.Text_IO;
with Ada.Strings; use Ada.Strings;
with Ada.Text_IO.Unbounded_IO;  use Ada.Text_IO.Unbounded_IO;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;
with Adresse_IP; use Adresse_IP;
with Routage; use Routage;
with Cache_L;
with Outils; use Outils;

procedure Routeur_LL is
    
    procedure Afficher_Erreur (Message : in String) is 
    begin
        Put_Line(Message);
        raise Option_Erreur;
    end Afficher_Erreur;

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
        InterfaceLue : Unbounded_String;
        Destination, Masque : T_adresse_ip; 
    begin
        Open(FD_Table, In_File, To_String(f_table));
        -- Ouvrir f_table en lecture
        Initialiser (Table_Routage);
        -- Parcourir les lignes du fichier
        begin
        while not End_Of_File(FD_Table) loop
        -- Séparer la ligne courante en Destination | Masque | Interface

            Lire_Adresse (Destination, FD_Table); -- Destination
            Lire_Adresse (Masque, FD_Table); -- Masque
            InterfaceLue := Get_line(FD_Table); -- Interface
            Trim(InterfaceLue, Both); -- Supprimer les espaces blancs

            -- Enregistrer la ligne courante dans la table de routage
            Enregistrer(Table_Routage, Destination, Masque, InterfaceLue);

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

    procedure Lire_Commande (Fichier : File_Type ; Commande : out T_Commandes) is
        Lecture : Unbounded_String;
    begin
        Get_Line(Fichier, Lecture);

        if Lecture = "table" then
            Commande := C_Table;

        elsif Lecture = "cache" then
            Commande := C_Cache;

        elsif Lecture = "stat" then
            Commande := C_Stat; 
        
        elsif Lecture = "fin" then
            Commande := C_Fin;
        end if;
    end Lire_Commande;

    -- Valeur par défault des options
    taille_cache : Integer := 10;
    politique : Unbounded_String := +"FIFO";
    afficher_stat : Boolean := True;
    f_table : Unbounded_String :=  +"table.txt";
    f_paquet : Unbounded_String := +"paquet.txt";
    f_resultat : Unbounded_String := +"resultats.txt";

    -- Variables pour l'ouverture du fichier f_table
    Table_Routage : T_Table_Routage;

    -- Variables pour l'ecriture des resultats
    FD_Paquet : File_Type;
    Paquet : T_adresse_ip;
    FD_Resultat : File_Type;

    package Cache_Liste is new Cache_L (taille_cache);
    use Cache_Liste;

    Cache : T_Cache;
    Route : T_Route;

    Commande : T_Commandes;

begin
    -- Initialiser les options à partir des arguments en ligne de commande
    Initialiser_Options (taille_cache, politique, afficher_stat, f_table, f_paquet, f_resultat);
    
    -- Importer la table de routage depuis le fichier
    Importer_Table (Table_Routage, f_table);
    
    -- Associer chaque paquet à une InterfaceLue
    Open(FD_Paquet, In_File, To_String(f_paquet));
    Create(FD_Resultat, Out_File, To_String(f_resultat));

    -- Initialiser le cache
    Initialiser (Cache);

    begin
    while not End_Of_File(FD_Paquet) loop
    begin
    
        -- Lecture d'un Paquet
        Lire_Adresse (Paquet, FD_Paquet);

        Route := Chercher (Cache, Paquet);

        if Route.Port = +"null" then 
            Route := Chercher_Route (Table_Routage, Paquet);
            Enregistrer (Cache, Route, To_String(politique));
        else
            Mettre_a_jour (Cache, Route, To_string(politique));
        end if;

        Enregister_Resultat (FD_Resultat, Route);

    exception
        when Data_Error =>
            Lire_Commande (FD_Paquet, Commande);
            case Commande is
                when C_table =>
                    Afficher_Table_Routage (Table_Routage);
                when C_cache =>
                    Afficher_Cache (Cache);
                when C_stat =>
                    null;
                    -- Afficher_Stat (Cache);
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

    -- Vider la table de routage et le cache à la fin de leurs utilisations    
    Vider(Table_Routage);
    Vider(Cache);

    exception
        when Option_Erreur =>
            Afficher_Utilisation;
end Routeur_LL;