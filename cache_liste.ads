with Adresse_IP; use Adresse_IP;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;

package cache_liste is

    type T_Cache is limited private;

    -- Créer un cache vide
    procedure Initialiser (Cache : out T_Cache);

    -- Ajouter une adresse IP dans le cache (au debut de la liste chainée)
    procedure Ajouter_Debut (Cache : in out T_Cache; Adresse : in T_Adresse_IP; Masque : in T_adresse_ip ; interface : in Unbounded_String);

    -- Ajouter une adresse IP dans le cache (à la fin de la liste chainée)
    procedure Ajouter_Fin (Cache : in out T_Cache; Adresse : in T_Adresse_IP; Masque : in T_adresse_ip ; interface : in Unbounded_String);

    -- Chercher une adresse IP dans le cache
    procedure Chercher_Route (Cache : in T_Cache; PaquetARouter : in T_Adresse_IP);

    -- Supprimer une adresse IP du cache
    procedure Supprimer (Cache : in out T_Cache; Adresse : in T_Adresse_IP; Masque : in T_adresse_ip ; interface : in Unbounded_String);

    -- Vider le cache
    procedure Vider (Cache : in out T_Cache);

private

end cache_liste;