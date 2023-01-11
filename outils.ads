with Adresse_IP; use Adresse_IP;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;

package Outils is 

    Option_Erreur : exception; -- Exception levée quand l'utilisateur utilise mal les options
    Route_Absente_Error : Exception;
    Cache_vide_Error : Exception;

    type T_route is record
        Adresse : T_adresse_IP;
        Masque : T_adresse_IP;
        Port : Unbounded_String;
    end record;

    type T_Commandes is (C_table, C_cache, C_stat, C_fin);

        -- Procedure qui rappelle l'utilisation des options
    -- Cette procédure est appelée lorsque l'exception Option_Erreur est lévée
    procedure Afficher_Utilisation;

    -- Surcharge l'opérateur unaire "+" pour convertir une String
	-- en Unbounded_String.
	function "+" (Item : in String) return Unbounded_String
		renames To_Unbounded_String;


end Outils;