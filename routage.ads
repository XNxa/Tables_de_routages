with Adresse_IP; use Adresse_IP;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;
with Outils; use Outils;

package Routage is

	type T_Table_Routage is limited private;

	-- procedure Initialiser
	-- Initialiser une liste chainée vide
	-- Paramètre :
		-- Table_Routage : out T_Table_Routage
    procedure Initialiser (Table_Routage : out T_Table_Routage);
		
	-- procedure Enregistrer
	-- Ajouter une nouvelle cellule dans la liste chainée
	-- Paramètres :
		-- Table_Routage : in out T_Table_Routage
		-- Route : T_Route
    procedure Enregistrer (Table_Routage : in out T_Table_Routage ; Route : T_Route);


	-- Chercher si une adresse correspond à une route dans la table de routage
	-- Renvoie l'interface de la route qui correspond le mieux
    function Chercher_Route (Table_Routage : in T_Table_Routage ; PaquetARouter : in T_adresse_ip) return T_Route;


	-- Afficher la table de routage
	procedure Afficher_Table_Routage (Table_Routage : in T_Table_Routage);

	-- Permet de vider la liste Chainée
    procedure Vider (Table_Routage : in out T_Table_Routage);


private
	
	type T_Cellule;
	
	type T_Table_Routage is access T_Cellule;
	
	type T_Cellule is record
		Route : T_Route;
		Suivant: T_Table_Routage;
	end record;

end Routage;
