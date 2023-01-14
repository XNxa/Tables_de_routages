with Ada.Strings.Fixed; Use Ada.Strings.Fixed;
with Ada.Integer_Text_IO; use Ada.Integer_Text_IO;

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

    procedure Lire_Adresse (Adresse : out T_adresse_ip ; Fichier : in out File_Type) is
        Octet1, Octet2, Octet3, Octet4 : Integer;
        Poubelle : Character;
    begin
        Get(Fichier, Octet1);
        Get(Fichier, Poubelle); -- Consommer le caractère '.'
        Get(Fichier, Octet2);
        Get(Fichier, Poubelle);
        Get(Fichier, Octet3);
        Get(Fichier, Poubelle);
        Get(Fichier, Octet4);
        Get(Fichier, Poubelle); 
        Initialiser(Adresse, Octet1, Octet2, Octet3, Octet4);
    end Lire_Adresse;

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

    function Adapter_Masque (Paquet : in T_adresse_ip) return T_adresse_ip is
        Masque : T_adresse_ip;
    begin
        if (Paquet / UN_OCTET ** 3) mod UN_OCTET = 0 then
            Initialiser(Masque, 0, 0, 0, 0);
        elsif (Paquet / UN_OCTET ** 2) mod UN_OCTET = 0 then
            Initialiser(Masque, 255, 0, 0, 0);
        elsif (Paquet / UN_OCTET ** 1) mod UN_OCTET = 0 then
            Initialiser(Masque, 255, 255, 0, 0);
        elsif (Paquet mod UN_OCTET) = 0 then
            Initialiser(Masque, 255, 255, 255, 0);
        else
            Initialiser(Masque, 255, 255, 255, 255);
        end if;
        return Masque;
    end Adapter_Masque;

    function Valeur_Bit (Adresse : in T_adresse_ip; N : in Integer) return Boolean is        
    begin
        return ((Adresse * 2**(N-1)) and POIDS_FORT) /= 0;
    end Valeur_Bit;

    function Sup_Masque (Left : T_adresse_ip; Right : T_adresse_ip) return Boolean is
    begin
        return (Left/2)>(Right/2) or ((Left/2)=(Right/2) and ((Left and 2**0) >= (Right and 2**0)));
    end Sup_Masque;

end Adresse_IP;