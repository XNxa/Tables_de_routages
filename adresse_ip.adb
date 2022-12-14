with Ada.Strings.Fixed; Use Ada.Strings.Fixed;
with Ada.Long_Integer_Text_IO; use Ada.Long_Integer_Text_IO;

package body Adresse_IP is
    
    procedure Initialiser (Adresse : out T_adresse_ip ; Octet1 : in Integer ; Octet2 : in Integer; Octet3 : in Integer; Octet4 : in Integer) is
        IpTemp : T_adresse_ip;
        O1, O2, O3, O4 : T_adresse_ip;
    begin
        -- Conversion dans le type T_Adresse_IP pour permettre les calculs
        O1 := T_adresse_ip(Octet1); 
        O2 := T_adresse_ip(Octet2);
        O3 := T_adresse_ip(Octet3);
        O4 := T_adresse_ip(Octet4);

        -- Construction de l'adresse dans une variable temporaire car Adresse en out
        -- Schéma de Horner :
        IpTemp := O1;
        IpTemp := IpTemp * UN_OCTET + O2;
        IpTemp := IpTemp * UN_OCTET + O3;
        IpTemp := IpTemp * UN_OCTET + O4;

        Adresse := IpTemp;
    end Initialiser; 

    function To_UString_Base10 (Adresse : in T_adresse_ip) return Unbounded_String is
        IpTemp1 : T_Adresse_IP;
        IpTemp2 : T_Adresse_IP;
        IpTemp3 : T_Adresse_IP;
        IpTemp4 : T_Adresse_IP;
        Resultat : Unbounded_String := To_Unbounded_String("");
    begin
        -- Extraire chaque octets de l'adresse
        IpTemp1 := Adresse;
        IpTemp2 := IpTemp1 / UN_OCTET;
        IpTemp3 := IpTemp2 / UN_OCTET;
        IpTemp4 := IpTemp3 / UN_OCTET;

        -- Construire la Unbounded_string avec les octets dans l'ordre
        -- L'utilisation de trim permet d'enlever l'espace blanc ajouté par la fonction Integer'image
        Append(Resultat, Trim(Integer'Image (Integer(IpTemp4 mod UN_OCTET)), Left));
        Append(Resultat, ".");
        Append(Resultat, Trim(Integer'Image (Integer(IpTemp3 mod UN_OCTET)), Left));
        Append(Resultat, ".");
        Append(Resultat, Trim(Integer'Image (Integer(IpTemp2 mod UN_OCTET)), Left));
        Append(Resultat, ".");
        Append(Resultat, Trim(Integer'Image (Integer(IpTemp1 mod UN_OCTET)), Left));

        return Resultat;
    end To_UString_Base10;

    function Est_Compatible (Adresse : in T_adresse_ip; Masque : in T_adresse_ip; Destination : in T_adresse_ip) return Boolean is
    begin
        return ((Adresse and Masque) = Destination);
    end Est_Compatible;

    function ">=" (Left : T_adresse_ip; Right : T_adresse_ip) return Boolean is
    begin        
        return Long_Integer(Left)>=Long_Integer(Right);
    end ">=";

end Adresse_IP;