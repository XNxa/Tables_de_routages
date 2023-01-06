
generic
    type T_Donnees is private;

package Liste_Chainee is

    type T_Liste is limited private;

    -- Initialiser une liste chainée vide
    procedure Initialiser (Liste : out T_Liste);

	-- Ajouter une nouvelle cellule dans la liste chainée
    procedure Enregistrer (Liste : in out T_Liste ; Donnees : in T_Donnees);

    -- Supprimer une cellule de la liste chainée
    procedure Supprimer (Liste : in out T_Liste ; Donnees : in T_Donnees);
    
    -- Retourner la taille de la liste chainée
    function Taille (Liste : in T_Liste) return Integer;
    
    -- Retourner les données d'une cellule de la liste chainée
    function La_Donnee (Liste : in T_Liste ; Index : in Integer) return T_Donnees with
        Pre => Index > 0 and Index <= Taille(Liste);
	
	-- Permettre de vider la liste Chainée
    procedure Vider (Liste : in out T_Liste);

private

    type T_Cellule;

    type T_Liste is access T_Cellule;
    
    type T_Cellule is record
        Donnee : T_Donnees;
        Suivant : T_Liste;
    end record;

end Liste_Chainee;