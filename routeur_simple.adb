with Ada.Command_Line; use Ada.Command_Line;
with Ada.Text_IO; use Ada.Text_IO;
with Ada.Strings; use Ada.Strings;
with Ada.Text_IO.Unbounded_IO;  use Ada.Text_IO.Unbounded_IO;
with Ada.Integer_Text_IO; use Ada.Integer_Text_IO;
with Ada.Exceptions; use Ada.Exceptions;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;
with Adresse_IP; use Adresse_IP;
with Table_Routage; use Table_Routage;

procedure Routeur_simple is
    
    Option_Erreur : exception; -- Exception levée quand l'utilisateur utilise mal les options

    -- Procedure qui rappelle l'utilisation des options
    -- Cette procédure est appelée lorsque l'exception Option_Erreur est lévée
    procedure Afficher_Utilisation is
    begin
        New_Line;
        Put_Line("Utilisation des options en ligne de commande :");
        Put_Line("-c <taille> : Définir la taille du cache. La valeur 0 indique qu’il n y a pas de cache. La valeur par défaut est 10.");
        Put_Line("-P FIFO|LRU|LFU : Définir la politique utilisée pour le cache (par défaut FIFO)");
        Put_Line("-s : Afficher les statistiques. C’est l’option activée par défaut.");
        Put_Line("-S : Ne pas afficher les statistiques.");
        Put_Line("-t <fichier> : Définir le nom du fichier contenant les routes de la table de routage. Défault : table.txt");
        Put_Line("-p <fichier> : Définir le nom du fichier contenant les paquets à router. Défault : paquet.txt");
        Put_Line("-r <fichier> : Définir le nom du fichier contenant les résultats. Défault : resultats.txt");
    end Afficher_Utilisation;

    -- Surcharge l'opérateur unaire "+" pour convertir une String
	-- en Unbounded_String.
	function "+" (Item : in String) return Unbounded_String
		renames To_Unbounded_String;

    -- Valeur par défault des options
    taille_cache : Integer := 10;
    politique : Unbounded_String := +"FIFO";
    afficher_stat : Boolean := True;
    f_table : Unbounded_String :=  +"table.txt";
    f_paquet : Unbounded_String := +"paquet.txt";
    f_resultat : Unbounded_String := +"resultats.txt";
    
    -- Variable de la boucle while d'initialisation des options 
    i : Integer := 1; 

    -- Variables pour l'ouverture du fichier f_table
    Table : File_Type;
    InterfaceLue : Unbounded_String;
    Destination, Masque : T_adresse_ip;
    Octet1, Octet2, Octet3, Octet4 : Integer;
    Poubelle : Character; -- Varible utilisée pour consommer des caratères inutiles
    Table_Routage : T_Table_Routage;

    -- Variables pour l'ecriture des resultats
    Paquets : File_Type;
    Paquet : T_adresse_ip;
    Resultat : File_Type;

begin

    -- Initialiser les options à partir des arguments en ligne de commande
    while i <= Argument_Count loop
        
        if Argument(i) = "-c" or Argument(i) = "-P" or Argument(i) = "-t" or Argument(i) = "-p" or Argument(i) = "-r" then
            
            if i+1 <= Argument_Count then

                if Argument(i) = "-c" then
                    begin
                        taille_cache := Integer'Value(Argument(i+1));
                        exception
                            -- Erreur levée si l'argument après -c n'est pas un entier
                            when CONSTRAINT_ERROR => 
                                Put_Line("L'option -c prend un entier en Argument");
                                raise Option_Erreur;
                    end;

                elsif Argument(i) = "-P" then
                    politique := +Argument(i+1);
                    if not (politique = +"FIFO" or politique = +"LFU" or politique = +"LRU") then
                        Put_Line("Politique choisie inconnue");
                        raise Option_Erreur;
                    end if;

                elsif Argument(i) = "-t" then
                    f_table := +Argument(i+1);
                    if Tail(f_table, 4) /= ".txt" then 
                        Put_Line("Nom de fichier de table incorrect");
                        raise Option_Erreur;
                    end if;
                
                elsif Argument(i) = "-p" then
                    f_paquet := +Argument(i+1);
                    if Tail(f_paquet, 4) /= ".txt" then 
                        Put_Line("Nom de fichier de paquet incorrect");
                        raise Option_Erreur;
                    end if;
                
                elsif Argument(i) = "-r" then
                    f_resultat := +Argument(i+1); 
                    if Tail(f_resultat, 4) /= ".txt" then 
                        Put_Line("Nom de fichier de resultat incorrect");
                        raise Option_Erreur;
                    end if;
                end if;

                i := i + 2;

            else 
                Put_Line("Mauvais nombre d'argument");
                raise Option_Erreur;
            end if;
        
        elsif Argument(i) = "-s" or Argument(i) = "-S" then
            afficher_stat := (Argument(i) = "-s");
            i := i + 1;
        else
            Put_Line("Option non reconnue");
            raise Option_Erreur;
        end if;
    end loop;

    
    -- Importer la table de routage depuis le fichier
    
    -- Ouvrir f_table en lecture
    Open(Table, In_File, To_String(f_table));

    Initialiser (Table_Routage);

    -- Parcourir les lignes du fichier
    begin
    while not End_Of_File(Table) loop

        -- Séparer la ligne courante en Destination | Masque | Interface

        -- Destination
        Get(Table, Octet1);
        Get(Table, Poubelle); -- Consommer le caractère '.'
        Get(Table, Octet2);
        Get(Table, Poubelle);
        Get(Table, Octet3);
        Get(Table, Poubelle);
        Get(Table, Octet4);
        Get(Table, Poubelle); 
        Initialiser(Destination, Octet1, Octet2, Octet3, Octet4);

        -- Masque
        Get(Table, Octet1);
        Get(Table, Poubelle);
        Get(Table, Octet2);
        Get(Table, Poubelle);
        Get(Table, Octet3);
        Get(Table, Poubelle);
        Get(Table, Octet4);
        Get(Table, Poubelle);
        Initialiser(Masque, Octet1, Octet2, Octet3, Octet4);
        
        -- Interface
        InterfaceLue := Get_line(Table);
        Trim(InterfaceLue, Both);

        -- Enregistrer la ligne courante dans la table de routage
        Enregistrer(Table_Routage, Destination, Masque, InterfaceLue);

    end loop;
    exception
        when End_Error =>
            Put("Attention, Blancs en surplus à la fin du fichier : " & f_table);
    end;
    Close(Table);

    Open(Paquets, In_File, To_String(f_paquet));
    Create(Resultat, Out_File, To_String(f_resultat));
    begin
    while not End_Of_File(Paquets) loop
    -- Associer chaque paquet à une InterfaceLue

        -- Lecture d'un Paquet
        Get(Paquets, Octet1);
        Get(Paquets, Poubelle); -- Consommer le caractère '.'
        Get(Paquets, Octet2);
        Get(Paquets, Poubelle);
        Get(Paquets, Octet3);
        Get(Paquets, Poubelle);
        Get(Paquets, Octet4);
        Initialiser(Paquet, Octet1, Octet2, Octet3, Octet4);

        -- Enregistrer dans le fichier resultat
        Put(Resultat, To_UString_Base10(Paquet));
        Put(Resultat, " ");
        Put(Resultat, Chercher_Route(Table_Routage, Paquet));
        New_Line(Resultat);

        -- TODO :
        -- - Traitement spécial si pas adresse mais mot clé de commande utilisateur

    end loop;
    exception
        when End_Error =>
            Put("Attention, Blancs en surplus à la fin du fichier : " & f_paquet);
    end;
    Close(Paquets);
    Close(Resultat);

    -- Vider la table de routage à la fin de son utilisation    
    Vider(Table_Routage);

    exception
        when Option_Erreur =>
            Afficher_Utilisation;
end Routeur_simple;