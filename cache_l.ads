with Adresse_IP; use Adresse_IP;
with Outils; use Outils;

package Cache_L is

    type T_Cache is limited private;


    -- procedure Initialiser
    -- Initialiser la liste chainée vide representant le cache avec un cache de la taille voulue
    -- Paramètres :
        -- Cache : out T_Cache
        -- taille : in Integer
    -- Pre-condition :
        -- taille > 0
    procedure Initialiser (Cache : out T_Cache; taille : in Integer) with
        Pre => taille > 0;


    -- function Chercher
    -- Chercher une adresse dans le cache si elle y est, sinon renvoyer une route nulle
    -- Paramètres :
        -- Cache : in T_Cache
        -- PaquetARouter : in T_Adresse_IP
    function Chercher (Cache : in T_Cache; PaquetARouter : in T_Adresse_IP) return T_Route;


    -- procedure Mettre_a_jour
    -- Mettre à jour le cache en accord avec la politique
    -- Paramètres :
        -- Cache : in out T_Cache
        -- Route : in T_Route
        -- politique : in String
    -- Pre-condition :
        -- politique == (+"FIFO" or +"LRU" or +"LFU")
    procedure Mettre_a_jour (Cache : in out T_Cache; Route : in T_Route ; politique : in String) with
        pre => politique == (+"FIFO" or +"LRU" or +"LFU");


    -- procedure Enregistrer
    -- Supprimer un élément du cache s'il est plein et une nouvelle adresse dans le cache en accord avec la politique
    -- Paramètres :
        -- Cache : in out T_Cache
        -- Route : in T_Route
        -- politique : in String
     -- Pre-condition :
        -- politique == (+"FIFO" or +"LRU" or +"LFU")
    procedure Enregistrer (Cache : in out T_Cache; Route : in T_Route ; politique : in String) with
        pre => politique == (+"FIFO" or +"LRU" or +"LFU");

    
    -- procedure Afficher_Cache
    -- Afficher le cache
    -- Paramètre :
        -- Cache : in T_Cache
    procedure Afficher_Cache (Cache : in T_Cache);


    -- procedure Vider
    -- Vider le cache de toutes les adresses
    -- Paramètre :
        -- Cache : in T_Cache
    procedure Vider (Cache : in out T_Cache);


private

    Taille_du_cache : Integer := 10;

    type T_Cellule;

    type T_Cache is access T_Cellule;

    type T_Cellule is record
        Route : T_Route;
        Frequence : Integer;
        Suivant : T_Cache;
    end record;

end Cache_L;