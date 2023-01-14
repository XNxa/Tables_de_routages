with Adresse_IP; use Adresse_IP;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;
with Ada.Text_IO; use Ada.Text_IO;

package Outils is 

    Option_Erreur : exception; -- Exception levée quand l'utilisateur utilise mal les options
    Route_Absente_Error : Exception; -- Exception levée quand on souhaite supprimer une route 
                                     -- absente d'un cache ou lorsqu'on souhaite augmenter sa
                                     -- fréquence d'utilisation en politique LFU
    Cache_vide_Error : Exception; -- Exception levée quand on souhaite supprimer la route en bout de chaine
                                  -- d'un cache en liste chainée quand celui-ci est vide
    Politique_Non_Supportee_Error : Exception; -- Exception levée quand l'utilisateur utilise une politique 
                                               -- autre que LRU avec un cache en arbre binaire
    Table_invalide_erreur : Exception; -- Exception levée quand la table de routage utilisée
                                       -- n'a pas le bon format

    type T_route is record
        Adresse : T_adresse_IP;
        Masque : T_adresse_IP;
        Port : Unbounded_String;
    end record;

    type T_Commandes is (C_table, C_cache, C_stat, C_fin);

    -- procedure Afficher_Utilisation
    -- Permet de rappeller l'utilisation des options
    -- Cette procédure est appelée lorsque l'exception Option_Erreur est lévée
    procedure Afficher_Utilisation;

    -- procedure Afficher_Erreur
    -- Permet d'afficher un message d'erreur et lève Option_Erreur
    -- paramètre :
        -- Message : in String
    procedure Afficher_Erreur (Message : in String);

    -- procedure Lire_Commande
    -- Lit les commandes dans le fichier Paquet
    -- paramètres :
        -- Fichier : in File_Type
        -- Commande : out T_Commandes
    procedure Lire_Commande (Fichier : in File_Type ; Commande : out T_Commandes);

    -- Surcharge l'opérateur unaire "+" pour convertir une String
	-- en Unbounded_String.
	function "+" (Item : in String) return Unbounded_String
		renames To_Unbounded_String;

    -- procedure Afficher_Route
    -- Permet d'afficher une route (adresse, masque, interface)
    -- paramètre :
        -- Route : in T_route
    procedure Afficher_Route(Route : in T_route);


end Outils;