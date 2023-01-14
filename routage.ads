with Adresse_IP; use Adresse_IP;
with Outils; use Outils;

package Routage is

	type T_Table_Routage is limited private;

	-- procedure Initialiser
	-- Initialiser une liste chainée vide
	-- Paramètre :
		-- Table_Routage : out T_Table_Routage
    procedure Initialiser (Table_Routage : out T_Table_Routage);
		
	-- procedure Enregistrer
	-- Ajouter une nouvelle cellule contenant une adresse, un masque et une interface au début de la liste chainée 
	-- Paramètres :
		-- Table_Routage : in out T_Table_Routage
		-- Route : in T_Route
    procedure Enregistrer (Table_Routage : in out T_Table_Routage ; Route : in T_Route);


	-- fonction Chercher_Route
	-- Comparer bit à bit le paquet à router avec les adresses de la table
	-- Si le paquet à router est présent :
	-- Retourner la route dont l'adresse est compatible avec le paquet et dont le masque est le plus grand.
	-- Sinon, lever l'exception Table_invalide_erreur 
	-- Paramètres :
		-- Table_Routage : in T_Table_Routage
		-- PaquetARouter : in T_adresse_ip
    function Chercher_Route (Table_Routage : in T_Table_Routage ; PaquetARouter : in T_adresse_ip) return T_Route;


	-- procédure Afficher_Table_Routage
	-- Permet d'afficher la table de routage
	-- Paramètres :
		-- Table_Routage : in T_Table_Routage
	procedure Afficher_Table_Routage (Table_Routage : in T_Table_Routage);

	-- procédure Vider
	-- Permet de vider la table de routage
	-- Paramètres :
		-- Table_Routage : in out T_Table_Routage
    procedure Vider (Table_Routage : in out T_Table_Routage);


private
	
	type T_Cellule;
	
	type T_Table_Routage is access T_Cellule;
	
	type T_Cellule is record
		Route : T_Route;
		Suivant: T_Table_Routage;
	end record;

end Routage;
