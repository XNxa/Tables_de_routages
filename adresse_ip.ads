with Ada.Strings.Unbounded; Use Ada.Strings.Unbounded;
with Ada.Strings; use Ada.Strings;
with Ada.Text_IO; use Ada.Text_IO;


package Adresse_IP is

    type T_adresse_ip is private;

    
    -- Yanis
    -- procedure Initialiser
    -- Permet d'initaliser une adresse dans le type T_adresse_ip à partir des valeurs entières de chaque octet
    -- Paramètres :
        -- Adresse : out T_adresse_ip
        -- Octet1 : in Integer
        -- Octet2 : in Integer
        -- Octet3 : in Integer
        -- Octet4 : in Integer
    -- Pré-condition : 0 <= (Octet1, Octet2, Octet3, Octet4) <= 255
    procedure Initialiser (Adresse : out T_adresse_ip ; Octet1 : in Integer ; 
             Octet2 : in Integer; Octet3 : in Integer; Octet4 : in Integer) with

        Pre => 0 <= Octet1 and Octet1 <= 255 and 0 <= Octet2 and Octet2 <= 255 
        and 0 <= Octet3 and Octet3 <= 255 and 0 <= Octet4 and Octet4 <= 255;

    
    -- Yanis
    -- procedure Lire_Adresse
    -- Permet de lire une adresse dans un fichier et de l'initialiser dans le type T_adresse_ip
    -- Paramètres :
        -- Adresse : out T_adresse_ip
        -- Fichier : in out File_Type
    procedure Lire_Adresse (Adresse : out T_adresse_ip ; Fichier : in out File_Type);


    -- Xavier
    -- function To_UString_Base10
    -- Permet d'obtenir une Unbounded_String correspondant à une adresse ip
    -- Paramètre :
        -- Adresse : in T_adresse_ip
    function To_UString_Base10 (Adresse : in T_adresse_ip) return Unbounded_String;


    -- Yanis
    -- function Est_Compatible
    -- Permet de comparer si une adresse à laquelle on applique un masque est compatible avec une destination
    -- Renvoie True si c'est compatible et False Sinon
    -- Paramètres :
        -- Adresse : in T_adresse_ip
        -- Masque : in T_adresse_ip
        -- Destination : in T_adresse_ip
    function Est_Compatible (Adresse : in T_adresse_ip; Masque : in T_adresse_ip;
             Destination : in T_adresse_ip) return Boolean;


    -- Xavier
    -- function Adapter_Masque
    -- Permet d'obtenir un masque adapté à une adresse
    -- Paramètre :
        -- Paquet : in T_adresse_ip
    function Adapter_Masque (Paquet : in T_adresse_ip) return T_adresse_ip;

    
    -- Xavier
    -- function Valeur_Bit
    -- Obtenir le n-ieme bit d'une adresse ip
    -- Paramètres :
        -- Adresse : in T_adresse_ip
        -- N : in Integer
    function Valeur_Bit (Adresse : in T_adresse_ip; N : in Integer) return Boolean;


    -- Xavier
    -- function Sup_Masque
    -- Permet de avoir si le membre de gauche est superieur ou égal au membre de droite
    -- Paramètres :
        -- Left : T_adresse_ip
        -- Right : T_adresse_ip
    function Sup_Masque (Left : T_adresse_ip; Right : T_adresse_ip) return Boolean;


private
    type T_adresse_ip is mod 2 ** 32;
    
    UN_OCTET: constant T_Adresse_IP := 2 ** 8;       -- 256
	POIDS_FORT : constant T_Adresse_IP  := 2 ** 31;	 -- 10000000.00000000.00000000.00000000

end Adresse_IP;
