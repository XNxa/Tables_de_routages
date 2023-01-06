with Ada.Unchecked_Deallocation;

package body Liste_Chainee is

    Donnee_Absente_Exception : exception;

    procedure Free is
            new Ada.Unchecked_Deallocation(Object => T_Cellule, Name => T_Liste);

    procedure Initialiser (Liste : out T_Liste) is
    begin
        Liste := null;
    end Initialiser;

    procedure Enregistrer (Liste : in out T_Liste; Donnees : in T_Donnees) is
    begin
        Liste := new T_Cellule'(Donnees, Liste);
    end Enregistrer;

    procedure Supprimer (Liste : in out T_Liste; Donnees : in T_Donnees) is
        A_Detruire : T_Liste;
    begin
        if Liste /= null then
            if Liste.All.Donnee = Donnees then
                A_Detruire := Liste;
                Liste := Liste.All.Suivant;
                Free(A_Detruire);
            else
                Supprimer(Liste.All.Suivant, Donnees);
            end if;
        else
            raise Donnee_Absente_Exception;
        end if;
    end Supprimer;

    function Taille (Liste : in T_Liste) return Integer is
        Compteur : Integer := 0;
        Liste_aux : T_Liste := Liste;
    begin
        while Liste_aux /= null loop
            Liste_aux := Liste_aux.All.Suivant;
            Compteur := Compteur + 1;
        end loop;
        return Compteur;
    end Taille;

    function La_Donnee (Liste : in T_Liste ; Index : in Integer) return T_Donnees is
        Compteur : Integer := 1;
        Liste_aux : T_Liste := Liste;
    begin
        while Liste_aux /= null and then Compteur /= Index loop
            Liste_aux := Liste_aux.All.Suivant;
            Compteur := Compteur + 1;
        end loop;
        if Liste_aux = null and Compteur /= Index then
            raise Donnee_Absente_Exception;
        else
            return Liste_aux.All.Donnee;
        end if;
    end La_Donnee;

    procedure Vider (Liste : in out T_Liste) is
        A_Detruire : T_Liste;
    begin
        while Liste /= null loop
            A_Detruire := Liste;
            Liste := Liste.All.Suivant;
            Free(A_Detruire);
        end loop;
    end Vider;

end Liste_Chainee;