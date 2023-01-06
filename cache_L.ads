with Adresse_IP; use Adresse_IP;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;



package Cache_L is

    type T_Cache is limited private;

    -- Initialiser la liste chainée vide representant le cache
    procedure Initialiser (Cache : out T_Cache);

    -- Chercher une adresse dans le cache
    function Chercher (Cache : in T_Cache; Adresse : in T_Adresse_IP) return Unbounded_String;

    -- Mettre a jour le cache
    procedure Mettre_a_jour (Cache : in out T_Cache; Adresse : in T_Adresse_IP; Masque : in T_Adresse_IP; Port : in Unbounded_String);

    -- Enregistrer une nouvelle adresse dans le cache
    procedure Enregistrer (Cache : in out T_Cache; Adresse : in T_Adresse_IP; Masque : in T_Adresse_IP; Port : in Unbounded_String);

    -- Vider le cache de toutes les lignes
    procedure Vider (Cache : in out T_Cache);



private

    type T_Cellule;

    type T_Cache is access T_Cellule;

    type T_Cellule is record
        Adresse : T_Adresse_IP;
        Masque : T_Adresse_IP;
        Port : Unbounded_String;
        Frequence : Integer;
        Suivant : T_Cache;
    end record;

end Cache_L;