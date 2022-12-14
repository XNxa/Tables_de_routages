with Ada.Unchecked_Deallocation;

package body Table_Routage is

    procedure Free is
        new Ada.Unchecked_Deallocation(Object => T_Cellule, Name => T_Table_Routage);

    procedure Initialiser (Table_Routage : out T_Table_Routage) is
    begin
        Table_Routage := null;
    end Initialiser;

    procedure Enregistrer (Table_Routage : in out T_Table_Routage ; Destination : T_adresse_ip ; Masque : T_adresse_ip; 
                InterfaceRoute : Unbounded_String) is 
    begin
        Table_Routage := new T_Cellule'(Destination, Masque, InterfaceRoute, Table_Routage);
    end Enregistrer;

    function Chercher_Route (Table_Routage : in T_Table_Routage ; PaquetARouter : in T_adresse_ip) return Unbounded_String is
        Table_Aux : T_Table_Routage := Table_Routage;
        Masque : T_adresse_ip;
        InterfaceARetourner : Unbounded_String;
    begin
        Initialiser(Masque, 0, 0, 0, 0);
        while Table_Aux /= null loop
            if Est_Compatible(PaquetARouter, Table_Aux.all.Masque, Table_Aux.all.Destination) and Table_Aux.all.Masque >= Masque then
                Masque := Table_aux.all.Masque;
                InterfaceARetourner := Table_aux.all.InterfaceRoute;
            end if;
            Table_Aux := Table_aux.all.Suivant;
        end loop;
        return InterfaceARetourner;
    end Chercher_Route;

    procedure Vider (Table_Routage : in out T_Table_Routage) is 
        A_Detruire : T_Table_Routage;
    begin
        while Table_Routage /= null loop
            A_Detruire := Table_Routage;
            Table_Routage := Table_Routage.All.Suivant;
            Free(A_Detruire);
        end loop;
    end Vider;

end Table_Routage;