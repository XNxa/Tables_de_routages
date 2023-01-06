package body Routagebis is

    procedure Initialiser (Table_Routage : out T_Table_Routage) is
    begin
        Table_Routage := new T_Liste;
        Liste_Routage.Initialiser (Table_Routage.all);
    end Initialiser;

    procedure Enregistrer (Table_Routage : in out T_Table_Routage ; Destination : T_adresse_ip ; Masque : T_adresse_ip; 
                InterfaceRoute : Unbounded_String) is 
        Route : T_Route;
    begin
        Route.Adresse := Destination;
        Route.Masque := Masque;
        Route.Port := InterfaceRoute;
        Enregistrer (Table_Routage.all, Route);
    end Enregistrer;

    function Chercher_Route (Table_Routage : in T_Table_Routage ; PaquetARouter : in T_adresse_ip) return Unbounded_String is
        Masque : T_adresse_ip;
        InterfaceARetourner : Unbounded_String;
        Compteur : Integer := 1;
        Taille : Integer;
        Route : T_Route;
    begin
        Initialiser(Masque, 0, 0, 0, 0);
        Taille := Liste_Routage.Taille(Table_Routage.all);
        while Compteur <= Taille loop
            Route := La_Donnee(Table_Routage.all, Compteur);
            if Est_Compatible(PaquetARouter, Route.Masque, Route.Adresse) and Sup_Masque(Route.Masque, Masque) then
                Masque := Route.Masque;
                InterfaceARetourner := Route.Port;
            end if;
            Compteur := Compteur + 1;
        end loop;
        return InterfaceARetourner;
    end Chercher_Route;

    procedure Vider (Table_Routage : in out T_Table_Routage) is 
    begin
        Liste_Routage.Vider (Table_Routage.all);
        Table_Routage := null;
    end Vider;

end Routagebis;