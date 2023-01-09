with Adresse_IP; use Adresse_IP;
with Outils; use Outils;
with Ada.Text_IO; use Ada.Text_IO;
with Ada.Strings; use Ada.Strings;
with Ada.Text_IO.Unbounded_IO;  use Ada.Text_IO.Unbounded_IO;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;

generic
    Taille_Cache : Integer;

package Cache_L is

    type T_Cache is limited private;

    -- Initialiser la liste chainée vide representant le cache
    procedure Initialiser (Cache : out T_Cache);

    -- Chercher une adresse dans le cache
    function Chercher (Cache : in T_Cache; PaquetARouter : in T_Adresse_IP) return T_Route;

    -- Mettre a jour le cache
    procedure Mettre_a_jour (Cache : in out T_Cache; Route : in T_Route ; politique : in String);

    -- Enregistrer une nouvelle adresse dans le cache
    procedure Enregistrer (Cache : in out T_Cache; Route : in T_Route ; politique : in String);

    -- Afficher le cache
    procedure Afficher_Cache (Cache : in T_Cache);

    -- Vider le cache de toutes les lignes
    procedure Vider (Cache : in out T_Cache);


private

    type T_Cellule;

    type T_Cache is access T_Cellule;

    type T_Cellule is record
        Route : T_Route;
        Frequence : Integer;
        Suivant : T_Cache;
    end record;

end Cache_L;