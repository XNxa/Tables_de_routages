with Ada.Unchecked_Deallocation;
with Ada.Text_IO.Unbounded_IO;  use Ada.Text_IO.Unbounded_IO;
with Ada.Text_IO; use Ada.Text_IO;

package body Routage is

    procedure Free is
        new Ada.Unchecked_Deallocation(Object => T_Cellule, Name => T_Table_Routage);

    procedure Initialiser (Table_Routage : out T_Table_Routage) is
    begin
        Table_Routage := null;
    end Initialiser;

    procedure Enregistrer (Table_Routage : in out T_Table_Routage ; Route : T_route) is 
    begin
        Table_Routage := new T_Cellule'(Route, Table_Routage);
    end Enregistrer;

    function Chercher_Route (Table_Routage : in T_Table_Routage ; PaquetARouter : in T_adresse_ip) return T_Route is
        Table_Aux : T_Table_Routage := Table_Routage;
        RouteARetourner : T_Route;
    begin
        Initialiser(RouteARetourner.Masque, 0, 0, 0, 0);
        while Table_Aux /= null loop
            if Est_Compatible(PaquetARouter, Table_Aux.all.Route.Masque, Table_Aux.all.Route.Adresse) and Sup_Masque(Table_Aux.all.Route.Masque, RouteARetourner.Masque) then
                RouteARetourner.Adresse := PaquetARouter;
                RouteARetourner.Masque := Table_aux.all.Route.Masque;
                RouteARetourner.Port := Table_aux.all.Route.Port;
            end if;
            Table_Aux := Table_aux.all.Suivant;
        end loop;
            RouteARetourner.Masque := Adresse_IP.Adapter_Masque(PaquetARouter);
        return RouteARetourner;
    end Chercher_Route;

    procedure Afficher_Table_Routage (Table_Routage : in T_Table_Routage) is
        Table_Aux : T_Table_Routage := Table_Routage;
    begin
        Put_line("Table");
        while Table_Aux /= null loop
            Put(To_UString_Base10(Table_Aux.all.Route.Adresse));
            Put(" ");
            Put(To_UString_Base10(Table_Aux.all.Route.Masque));
            Put(" ");
            Put(Table_Aux.all.Route.Port);
            New_Line;
            Table_Aux := Table_Aux.all.Suivant;
        end loop;
        New_Line;
    end Afficher_Table_Routage;

    procedure Vider (Table_Routage : in out T_Table_Routage) is 
        A_Detruire : T_Table_Routage;
    begin
        while Table_Routage /= null loop
            A_Detruire := Table_Routage;
            Table_Routage := Table_Routage.All.Suivant;
            Free(A_Detruire);
        end loop;
    end Vider;

end Routage;