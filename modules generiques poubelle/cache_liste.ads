with Adresse_IP; use Adresse_IP;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;
with Liste_Chainee;

generic
    Taille_Cache : Integer;

package Cache_liste is

    type T_Cache is limited private;

    -- Créer un cache vide
    procedure Initialiser (Cache : out T_Cache);

    -- Chercher une adresse IP dans le cache
    procedure MettreAJour (Cache : in out T_Cache; Adresse : in T_Adresse_IP; Masque : in T_Adresse_IP; Port : in Unbounded_String ; Politique : in String);

    -- Ajouter une adresse IP dans le cache selon une politique choisie
    procedure Enregistrer (Cache : in out T_Cache; Adresse : in T_Adresse_IP; Masque : in T_Adresse_IP; Port : in Unbounded_String ; Politique : in String);

    -- Vider le cache
    procedure Vider (Cache : in out T_Cache);

private

    type T_Donnee_cache is record
        Adresse_IP : T_Adresse_IP;
        Masque : T_Adresse_IP;
        Port : Unbounded_String;
        Frequence : Integer;
    end record;

    package Liste_Cache is new Liste_Chainee (T_Donnee_cache); 
    use Liste_Cache;

    type T_Cache is access T_Liste;    

end Cache_liste;