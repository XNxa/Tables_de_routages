with Adresse_IP; use Adresse_IP;
with Outils; use Outils;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;

package Cache_a is

    type T_Cache is limited private;

    -- Xavier
    -- procedure Initialiser
    -- Initialise la liste arbre binaire vide representant le cache
    -- paramètres :
        -- Cache : out T_Cache
        -- taille : in Integer
    -- Pre-condition :
        -- taille > 0
    procedure Initialiser (Cache : out T_Cache; taille : in Integer) with
        Pre => taille > 0;

    -- Xavier
    -- function Chercher
    -- Chercher une adresse dans le cache si elle y est, sinon renvoyer une route nulle
    -- Paramètres :
        -- Cache : in T_Cache
        -- PaquetARouter : in T_Adresse_IP
    function Chercher (Cache : in T_Cache; PaquetARouter : in T_Adresse_IP) return T_Route;

    -- Xavier
    -- procedure Mettre_a_jour
    -- Place en première position la route utilisée dans un tableau qui enregistre l'ordre d'utilisation
    -- des routes
    -- paramètres :
        -- Cache : in out T_Cache
        -- Route : in T_Route
        -- politique : in String
    -- Pre-condition :
        -- politique = +"LRU"
    procedure Mettre_a_jour (Cache : in out T_Cache; Route : in T_Route ; politique : in String) with
        pre => politique = +"LRU";

    -- Xavier
    -- procedure Enregistrer
    -- Supprimer un élément du cache s'il est plein et une nouvelle adresse dans le 
    -- cache en accord avec la politique LRU
    -- Paramètres :
        -- Cache : in out T_Cache
        -- Route : in T_Route
        -- politique : in String
     -- Pre-condition :
        -- politique == +"LRU"
    procedure Enregistrer (Cache : in out T_Cache; Route : in T_Route ; politique : in String) with
        pre => politique = +"LRU";

    -- Yanis
    -- procedure Afficher_Cache
    -- Afficher le cache
    -- Paramètre :
        -- Cache : in T_Cache
    procedure Afficher_Cache (Cache : in T_Cache);

    -- Xavier
    -- procedure Vider
    -- Vider le cache de toutes les adresses
    -- Paramètre :
        -- Cache : in T_Cache
    procedure Vider (Cache : in out T_Cache);

private

    Taille_Max_cache : Integer;
    ROUTEVIDE : T_Route;

    type T_Tab_Ordre is Array(1..100) of T_Route;

    type T_Ordre is record
        Tab : T_Tab_Ordre;
        TailleEffective : Integer;
    end record;

    type T_Cellule;

    type T_Cache is access T_Cellule;

    type T_Cellule is record
        Route : T_Route;
        Gauche : T_Cache; -- bit 0
        Droite : T_Cache; -- bit 1
        estNoeud : Boolean;
    end record;
    
    Ordre : T_Ordre;

end Cache_a;
