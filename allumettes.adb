with Ada.Text_IO;
use Ada.Text_IO;

with Ada.Integer_Text_IO;
use Ada.Integer_Text_IO;

with Alea;

--------------------------------------------------------------------------------
--  Auteur   : Mohammed Amine El Ouardini
--  Objectif : Jeu Allumettes
--------------------------------------------------------------------------------

procedure Allumettes is

    package Alea_1_3 is
        new Alea(1, 3);
    use Alea_1_3;

    -- Déclaration des variables
    type Niveau_Ordinateur is (Naif, Distrait, Rapide, Expert);
    Niveau : Niveau_Ordinateur;
    Tour_Humain : Boolean;
    Nombre_d_allumettes : Integer := 13;
    Allumettes : Integer;
    Action_Valide : Boolean;

    -- Demander le niveau de jeu
    procedure Demander_Niveau is
        Niveau_Char : Character;
    begin
        Put("Niveau de l'ordinateur (n)aïf, (d)istrait, (r)apide ou (e)xpert ?");
        Get(Niveau_Char);

        case Niveau_Char is
            when 'n' | 'N' => Niveau := Naif ; Put_Line("Mon niveau est naif.");
            when 'd' | 'D' => Niveau := Distrait ; Put_Line("Mon niveau est distrait.");
            when 'r' | 'R' => Niveau := Rapide ; Put_Line("Mon niveau est rapide.");
            when 'e' | 'E' => Niveau := Expert ; Put_Line("Mon niveau est expert.");
            when others     => Niveau := Expert ; Put_Line("Mon niveau est expert.");
        end case;
    end Demander_Niveau;

    -- Demander si le joueur commence
    procedure Demander_Si_Le_Joueur_Commence is
        Choix : Character;
    begin
        Put("Est-ce que vous commencez (o/n) ?");
        Get(Choix);

        if Choix = 'o' or Choix = 'O' then
            Tour_Humain := True;
        elsif Choix = 'n' or Choix = 'N' then
            Tour_Humain := False;
        end if;
        New_Line;
    end Demander_Si_Le_Joueur_Commence;

    -- Afficher le gagnant
    procedure Afficher_Gagnant is
    begin
        if Tour_Humain then
            Put_Line("Vous avez gagné.");
        else
            Put_Line("J'ai gagné.");
        end if;
        New_Line; 
    end Afficher_Gagnant;

    -- Afficher les allumettes restantes
    procedure Afficher_Allumettes is
    begin
        for Ligne in 1 .. 3 loop
            for I in 1 .. Nombre_d_allumettes loop
                Put("| ");  

                -- Séparation des groupes de 5 allumettes par un espace
                if I mod 5 = 0 and I /= Nombre_d_allumettes then
                    Put("  ");  
                end if;
            end loop;
            New_Line;
        end loop;
        New_Line;  
    end Afficher_Allumettes;

    -- Jouer pour l'humain
    procedure Jouer_Humain is
    begin
        Action_Valide := True;  
        Put("Combien d'allumettes prenez-vous ? ");
        Get(Allumettes);
        if Allumettes > 3 then
            Put("Arbitre : Il est interdit de prendre plus de 3 allumettes.");
            Action_Valide := False;
        elsif Allumettes > Nombre_d_allumettes then
		if Nombre_d_allumettes = 1 then
			Put("Arbitre : Il reste une seule allumette.");
		else	
        	    	Put("Arbitre : Il reste seulement " & Integer'Image(Nombre_d_allumettes) & " allumettes.");
		end if ;
       		Action_Valide := False;
        elsif Allumettes <= 0 then
            Put("Arbitre : Il faut prendre au moins une allumette.");
            Action_Valide := False;
        else
            Nombre_d_allumettes := Nombre_d_allumettes - Allumettes;
            Tour_Humain := False;
        end if;
	New_Line;
    end Jouer_Humain;

    -- Jouer pour l'ordinateur
    procedure Jouer_Ordinateur is
        Nombre_A_Prendre : Integer;
    begin
        Action_Valide := True;  
        case Niveau is
            when Naif =>
                if Nombre_d_allumettes = 1 then
                    Nombre_A_Prendre := 1;
                else
                    Get_Random_Number(Nombre_A_Prendre);
                end if;
            when Distrait =>
                Get_Random_Number(Nombre_A_Prendre);
            when Rapide =>
                Nombre_A_Prendre := Integer'Min(3, Nombre_d_allumettes);
            when Expert =>
                declare
                    R : constant Integer := Nombre_d_allumettes mod 4;
                begin
                    case R is
                        when 0 => Nombre_A_Prendre := 3;
                        when 1 => Nombre_A_Prendre := 1;
                        when 2 => Nombre_A_Prendre := 1;
                        when 3 => Nombre_A_Prendre := 2;
                        when others => null;
                    end case;
                end;
        end case;

        Nombre_d_allumettes := Nombre_d_allumettes - Nombre_A_Prendre;
        Put_Line("Je prends " & Integer'Image(Nombre_A_Prendre) & " allumette" & (if Nombre_A_Prendre = 1 then "" else "s") & ".");
        New_Line;  -- Ajoute une nouvelle ligne après le message de l'ordinateur
        Tour_Humain := True;
    end Jouer_Ordinateur;

begin
    -- Demander les informations de jeu
    Demander_Niveau;
    Demander_Si_Le_Joueur_Commence;

    -- Boucle principale du jeu
    loop
        if Nombre_d_allumettes = 0 then
            exit;
        end if;

        -- Affichage des allumettes restantes avant l'action de jeu
        if Action_Valide then
            Afficher_Allumettes;
        end if;

        -- Tour de l'humain ou de l'ordinateur
        if Tour_Humain then
            Jouer_Humain;
        else
            Jouer_Ordinateur;
        end if;
    end loop;

    -- Afficher le gagnant
    Afficher_Gagnant;

end Allumettes;

