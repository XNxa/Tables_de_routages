with Liste_Chainee;
with Adresse_IP; use Adresse_IP;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;   

package Routagebis is

    type T_Table_Routage is limited private;
    
    -- Initialiser une liste chainée vide
    procedure Initialiser (Table_Routage : out T_Table_Routage);

	-- Ajouter une nouvelle cellule dans la liste chainée
    procedure Enregistrer (Table_Routage : in out T_Table_Routage ; 
            Destination : T_adresse_ip ; Masque : T_adresse_ip; InterfaceRoute : Unbounded_string);

	-- Chercher si une adresse correspond à une route dans la table de routage
	-- Renvoie l'interface de la route qui correspond le mieux
    function Chercher_Route (Table_Routage : in T_Table_Routage ; PaquetARouter : in T_adresse_ip) return Unbounded_String;

	-- Permet de vider la liste Chainée
    procedure Vider (Table_Routage : in out T_Table_Routage);

private
    
    type T_Route is record
            Adresse : T_adresse_ip;
            Masque : T_adresse_ip;
            Port : Unbounded_string;
    end record;
    
    package Liste_Routage is new Liste_Chainee (T_Donnees => T_Route);
    use Liste_Routage;

    type T_Table_Routage is access Liste_Routage.T_Liste;

end Routagebis;