-- ============================================================================
-- Script de création de la base de données LAAS
-- Système de Gestion de Base de Données : PostgreSQL
-- ============================================================================

-- Suppression des tables existantes (dans l'ordre inverse des dépendances)
DROP TABLE IF EXISTS SponsoringProjet CASCADE;
DROP TABLE IF EXISTS ParticipationProjetLAAS CASCADE;
DROP TABLE IF EXISTS Encadrer CASCADE;
DROP TABLE IF EXISTS ParticipationPersonelPubli CASCADE;
DROP TABLE IF EXISTS ParticipationAEPubli CASCADE;
DROP TABLE IF EXISTS PresidentCongres CASCADE;
DROP TABLE IF EXISTS ParticipationPersoJPO CASCADE;
DROP TABLE IF EXISTS Auteur_externe CASCADE;
DROP TABLE IF EXISTS Lab_externe CASCADE;
DROP TABLE IF EXISTS Publication CASCADE;
DROP TABLE IF EXISTS Chercheur CASCADE;
DROP TABLE IF EXISTS Enseignant_chercheur CASCADE;
DROP TABLE IF EXISTS Projets_LAAS CASCADE;
DROP TABLE IF EXISTS Partenaire CASCADE;
DROP TABLE IF EXISTS Scientifique CASCADE;
DROP TABLE IF EXISTS Doctorant CASCADE;
DROP TABLE IF EXISTS Congres CASCADE;
DROP TABLE IF EXISTS Journee_Portes_Ouvertes CASCADE;
DROP TABLE IF EXISTS Evenement CASCADE;
DROP TABLE IF EXISTS Etablissement CASCADE;
DROP TABLE IF EXISTS Personnel CASCADE;

-- ============================================================================
-- TABLES PRINCIPALES
-- ============================================================================

-- Table Personnel
CREATE TABLE Personnel (
    id_personnel SERIAL PRIMARY KEY,
    nom VARCHAR(100) NOT NULL,
    prenom VARCHAR(100) NOT NULL,
    date_de_naissance DATE NOT NULL,
    adresse TEXT,
    date_recrutement DATE NOT NULL,
    CONSTRAINT chk_date_naissance CHECK (date_de_naissance < date_recrutement)
);

-- Table Evenement
CREATE TABLE Evenement (
    id_event SERIAL PRIMARY KEY,
    date_debut DATE NOT NULL,
    date_fin DATE NOT NULL,
    CONSTRAINT chk_dates_event CHECK (date_debut <= date_fin)
);

-- Table Journee_Portes_Ouvertes
CREATE TABLE Journee_Portes_Ouvertes (
    id_jpo INTEGER PRIMARY KEY,
    CONSTRAINT fk_jpo_event FOREIGN KEY (id_jpo) 
        REFERENCES Evenement(id_event)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

-- Table Congres
CREATE TABLE Congres (
    id_congres INTEGER PRIMARY KEY,
    nb_inscris INTEGER,
    classe VARCHAR(50),
    CONSTRAINT fk_congres_event FOREIGN KEY (id_congres) 
        REFERENCES Evenement(id_event)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    CONSTRAINT chk_nb_inscris CHECK (nb_inscris >= 0)
);

-- Table Doctorant
CREATE TABLE Doctorant (
    id_doc INTEGER PRIMARY KEY,
    date_debut_these DATE NOT NULL,
    date_soutenance DATE,
    CONSTRAINT fk_doctorant_personnel FOREIGN KEY (id_doc) 
        REFERENCES Personnel(id_personnel)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    CONSTRAINT chk_dates_these CHECK (date_debut_these < date_soutenance OR date_soutenance IS NULL)
);

-- Table Scientifique
CREATE TABLE Scientifique (
    id_scientifique INTEGER PRIMARY KEY,
    grade VARCHAR(100) NOT NULL,
    CONSTRAINT fk_scientifique_personnel FOREIGN KEY (id_scientifique) 
        REFERENCES Personnel(id_personnel)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

-- Table Etablissement
CREATE TABLE Etablissement (
    id_etablissement SERIAL PRIMARY KEY,
    nom VARCHAR(200) NOT NULL,
    acronyme VARCHAR(50),
    adresse TEXT
);

-- Table Partenaire
CREATE TABLE Partenaire (
    id_partenaire SERIAL PRIMARY KEY,
    nom VARCHAR(200) NOT NULL,
    pays VARCHAR(100) NOT NULL
);

-- Table Projets_LAAS
CREATE TABLE Projets_LAAS (
    id_projet SERIAL PRIMARY KEY,
    titre VARCHAR(300) NOT NULL,
    acronyme VARCHAR(50),
    annee_debut INTEGER NOT NULL,
    duree INTEGER NOT NULL,
    cout_global NUMERIC(15, 2),
    budget NUMERIC(15, 2),
    id_porteur INTEGER NOT NULL,
    CONSTRAINT fk_projet_porteur FOREIGN KEY (id_porteur) 
        REFERENCES Scientifique(id_scientifique)
        ON DELETE RESTRICT
        ON UPDATE CASCADE,
    CONSTRAINT chk_duree CHECK (duree > 0),
    CONSTRAINT chk_cout_global CHECK (cout_global >= 0),
    CONSTRAINT chk_budget CHECK (budget >= 0)
);

-- Table Enseignant_chercheur
CREATE TABLE Enseignant_chercheur (
    id_ec INTEGER PRIMARY KEY,
    echelon VARCHAR(50),
    id_etablissement INTEGER NOT NULL,
    CONSTRAINT fk_ec_scientifique FOREIGN KEY (id_ec) 
        REFERENCES Scientifique(id_scientifique)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    CONSTRAINT fk_ec_etablissement FOREIGN KEY (id_etablissement) 
        REFERENCES Etablissement(id_etablissement)
        ON DELETE RESTRICT
        ON UPDATE CASCADE
);

-- Table Chercheur
CREATE TABLE Chercheur (
    id_chercheur INTEGER PRIMARY KEY,
    CONSTRAINT fk_chercheur_scientifique FOREIGN KEY (id_chercheur) 
        REFERENCES Scientifique(id_scientifique)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

-- Table Publication
CREATE TABLE Publication (
    id_publication SERIAL PRIMARY KEY,
    titre VARCHAR(500) NOT NULL,
    annee INTEGER NOT NULL,
    nom_de_conference VARCHAR(200),
    classe VARCHAR(50),
    nb_pages INTEGER,
    CONSTRAINT chk_nb_pages CHECK (nb_pages > 0)
);

-- Table Lab_externe
CREATE TABLE Lab_externe (
    id_l_externe SERIAL PRIMARY KEY,
    nom VARCHAR(200) NOT NULL,
    pays VARCHAR(100) NOT NULL
);

-- Table Auteur_externe
CREATE TABLE Auteur_externe (
    id_a_externe SERIAL PRIMARY KEY,
    nom VARCHAR(100) NOT NULL,
    prenom VARCHAR(100) NOT NULL,
    adresse_mail VARCHAR(200),
    id_l_externe INTEGER NOT NULL,
    CONSTRAINT fk_auteur_lab FOREIGN KEY (id_l_externe) 
        REFERENCES Lab_externe(id_l_externe)
        ON DELETE RESTRICT
        ON UPDATE CASCADE
);

-- ============================================================================
-- TABLES D'ASSOCIATIONS
-- ============================================================================

-- Table ParticipationPersoJPO
CREATE TABLE ParticipationPersoJPO (
    id_participant INTEGER NOT NULL,
    id_jpo INTEGER NOT NULL,
    PRIMARY KEY (id_participant, id_jpo),
    CONSTRAINT fk_participation_jpo_personnel FOREIGN KEY (id_participant) 
        REFERENCES Personnel(id_personnel)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    CONSTRAINT fk_participation_jpo_event FOREIGN KEY (id_jpo) 
        REFERENCES Journee_Portes_Ouvertes(id_jpo)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

-- Table PresidentCongres
CREATE TABLE PresidentCongres (
    id_scientifique INTEGER NOT NULL,
    id_congres INTEGER NOT NULL,
    PRIMARY KEY (id_scientifique, id_congres),
    CONSTRAINT fk_president_scientifique FOREIGN KEY (id_scientifique) 
        REFERENCES Scientifique(id_scientifique)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    CONSTRAINT fk_president_congres FOREIGN KEY (id_congres) 
        REFERENCES Congres(id_congres)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

-- Table ParticipationAEPubli
CREATE TABLE ParticipationAEPubli (
    id_publication INTEGER NOT NULL,
    id_a_externe INTEGER NOT NULL,
    PRIMARY KEY (id_publication, id_a_externe),
    CONSTRAINT fk_participation_ae_publication FOREIGN KEY (id_publication) 
        REFERENCES Publication(id_publication)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    CONSTRAINT fk_participation_ae_auteur FOREIGN KEY (id_a_externe) 
        REFERENCES Auteur_externe(id_a_externe)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

-- Table ParticipationPersonelPubli
CREATE TABLE ParticipationPersonelPubli (
    id_publication INTEGER NOT NULL,
    id_personnel INTEGER NOT NULL,
    PRIMARY KEY (id_publication, id_personnel),
    CONSTRAINT fk_participation_perso_publication FOREIGN KEY (id_publication) 
        REFERENCES Publication(id_publication)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    CONSTRAINT fk_participation_perso_personnel FOREIGN KEY (id_personnel) 
        REFERENCES Personnel(id_personnel)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

-- Table Encadrer
CREATE TABLE Encadrer (
    id_scientifique INTEGER NOT NULL,
    id_doc INTEGER NOT NULL,
    PRIMARY KEY (id_scientifique, id_doc),
    CONSTRAINT fk_encadrer_scientifique FOREIGN KEY (id_scientifique) 
        REFERENCES Scientifique(id_scientifique)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    CONSTRAINT fk_encadrer_doctorant FOREIGN KEY (id_doc) 
        REFERENCES Doctorant(id_doc)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

-- Table ParticipationProjetLAAS
CREATE TABLE ParticipationProjetLAAS (
    id_participant INTEGER NOT NULL,
    id_projet INTEGER NOT NULL,
    PRIMARY KEY (id_participant, id_projet),
    CONSTRAINT fk_participation_projet_scientifique FOREIGN KEY (id_participant) 
        REFERENCES Scientifique(id_scientifique)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    CONSTRAINT fk_participation_projet_projet FOREIGN KEY (id_projet) 
        REFERENCES Projets_LAAS(id_projet)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

-- Table SponsoringProjet
CREATE TABLE SponsoringProjet (
    id_sponsor INTEGER NOT NULL,
    id_projet INTEGER NOT NULL,
    PRIMARY KEY (id_sponsor, id_projet),
    CONSTRAINT fk_sponsoring_partenaire FOREIGN KEY (id_sponsor) 
        REFERENCES Partenaire(id_partenaire)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    CONSTRAINT fk_sponsoring_projet FOREIGN KEY (id_projet) 
        REFERENCES Projets_LAAS(id_projet)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

-- ============================================================================
-- INDICES POUR OPTIMISATION DES PERFORMANCES
-- ============================================================================

CREATE INDEX idx_personnel_nom ON Personnel(nom);
CREATE INDEX idx_personnel_date_recrutement ON Personnel(date_recrutement);
CREATE INDEX idx_evenement_dates ON Evenement(date_debut, date_fin);
CREATE INDEX idx_scientifique_grade ON Scientifique(grade);
CREATE INDEX idx_projet_porteur ON Projets_LAAS(id_porteur);
CREATE INDEX idx_projet_annee ON Projets_LAAS(annee_debut);
CREATE INDEX idx_publication_annee ON Publication(annee);
CREATE INDEX idx_auteur_externe_lab ON Auteur_externe(id_l_externe);

-- ============================================================================
-- COMMENTAIRES SUR LES TABLES ET COLONNES
-- ============================================================================

COMMENT ON TABLE Personnel IS 'Table contenant les informations sur le personnel du LAAS';
COMMENT ON TABLE Evenement IS 'Table générique pour tous les événements organisés';
COMMENT ON TABLE Journee_Portes_Ouvertes IS 'Table spécialisée pour les journées portes ouvertes';
COMMENT ON TABLE Congres IS 'Table spécialisée pour les congrès';
COMMENT ON TABLE Doctorant IS 'Table contenant les informations spécifiques aux doctorants';
COMMENT ON TABLE Scientifique IS 'Table contenant les informations spécifiques aux scientifiques';
COMMENT ON TABLE Projets_LAAS IS 'Table contenant les projets de recherche du LAAS';
COMMENT ON TABLE Publication IS 'Table contenant les publications scientifiques';

-- ============================================================================
-- FIN DU SCRIPT
-- ============================================================================