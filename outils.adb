With Ada.Text_IO.Unbounded_IO; use Ada.Text_IO.Unbounded_IO;

package body Outils is

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

    procedure Afficher_Erreur (Message : in String) is 
    begin
        Put_Line(Message);
        raise Option_Erreur;
    end Afficher_Erreur;

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

    procedure Afficher_Route(Route : in T_route) is
    begin
        Put(To_UString_Base10(Route.Adresse));
        Put(" ");
        Put(To_UString_Base10(Route.Masque));
        Put(" ");
        Put(Route.Port);
        New_Line;
    end Afficher_Route;

end Outils;