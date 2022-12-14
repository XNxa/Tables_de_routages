with Adresse_IP; use Adresse_IP;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;

package Table_Routage is

	type T_Table_Routage is limited private;

    procedure Initialiser (Table_Routage : out T_Table_Routage);

    procedure Enregistrer (Table_Routage : in out T_Table_Routage ; 
            Destination : T_adresse_ip ; Masque : T_adresse_ip; InterfaceRoute : Unbounded_string);

    function Chercher_Route (Table_Routage : in T_Table_Routage ; PaquetARouter : in T_adresse_ip) return Unbounded_String;

    procedure Vider (Table_Routage : in out T_Table_Routage);


private
	
	type T_Cellule;
	
	type T_Table_Routage is access T_Cellule;
	
	type T_Cellule is record
		Destination : T_adresse_ip;
        Masque : T_adresse_ip;
		InterfaceRoute : Unbounded_String;
		Suivant: T_Table_Routage;
	end record;

end Table_Routage;
