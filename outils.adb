With Ada.Text_IO; use Ada.Text_IO;

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

end Outils;