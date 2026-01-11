-- ============================================================================
-- Script de création de la base de données LAAS
-- Système de Gestion de Base de Données : PostgreSQL
-- ============================================================================

-- Suppression des tables existantes (dans l'ordre inverse des dépendances)
DROP TABLE IF EXISTS sponsoring_projet CASCADE;
DROP TABLE IF EXISTS participation_projet_laas CASCADE;
DROP TABLE IF EXISTS encadrer CASCADE;
DROP TABLE IF EXISTS participation_personel_publi CASCADE;
DROP TABLE IF EXISTS participation_ae_publi CASCADE;
DROP TABLE IF EXISTS president_congres CASCADE;
DROP TABLE IF EXISTS participation_perso_jpo CASCADE;
DROP TABLE IF EXISTS auteur_externe CASCADE;
DROP TABLE IF EXISTS lab_externe CASCADE;
DROP TABLE IF EXISTS publication CASCADE;
DROP TABLE IF EXISTS chercheur CASCADE;
DROP TABLE IF EXISTS enseignant_chercheur CASCADE;
DROP TABLE IF EXISTS projets_laas CASCADE;
DROP TABLE IF EXISTS partenaire CASCADE;
DROP TABLE IF EXISTS scientifique CASCADE;
DROP TABLE IF EXISTS doctorant CASCADE;
DROP TABLE IF EXISTS congres CASCADE;
DROP TABLE IF EXISTS journee_portes_ouvertes CASCADE;
DROP TABLE IF EXISTS evenement CASCADE;
DROP TABLE IF EXISTS etablissement CASCADE;
DROP TABLE IF EXISTS personnel CASCADE;

-- ============================================================================
-- TABLES PRINCIPALES
-- ============================================================================

-- Table personnel
CREATE TABLE personnel (
    id_personnel SERIAL PRIMARY KEY,
    nom VARCHAR(100) NOT NULL,
    prenom VARCHAR(100) NOT NULL,
    date_de_naissance DATE NOT NULL,
    adresse TEXT,
    date_recrutement DATE NOT NULL,
    CONSTRAINT chk_date_naissance CHECK (date_de_naissance < date_recrutement)
);

-- Table Evenement
CREATE TABLE evenement (
    id_event SERIAL PRIMARY KEY,
    date_debut DATE NOT NULL,
    date_fin DATE NOT NULL,
    CONSTRAINT chk_dates_event CHECK (date_debut <= date_fin)
);

-- Table Journee_Portes_Ouvertes
CREATE TABLE journee_portes_ouvertes (
    id_jpo INTEGER PRIMARY KEY,
    CONSTRAINT fk_jpo_event FOREIGN KEY (id_jpo) 
        REFERENCES evenement(id_event)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

-- Table Congres
CREATE TABLE Congres (
    id_congres INTEGER PRIMARY KEY,
    nb_inscris INTEGER,
    classe VARCHAR(50),
    CONSTRAINT fk_congres_event FOREIGN KEY (id_congres) 
        REFERENCES evenement(id_event)
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
        REFERENCES personnel(id_personnel)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    CONSTRAINT chk_dates_these CHECK (date_debut_these < date_soutenance OR date_soutenance IS NULL)
);

-- Table Scientifique
CREATE TABLE scientifique (
    id_scientifique INTEGER PRIMARY KEY,
    grade VARCHAR(100) NOT NULL,
    CONSTRAINT fk_scientifique_personnel FOREIGN KEY (id_scientifique) 
        REFERENCES personnel(id_personnel)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

-- Table Etablissement
CREATE TABLE etablissement (
    id_etablissement SERIAL PRIMARY KEY,
    nom VARCHAR(200) NOT NULL,
    acronyme VARCHAR(50),
    adresse TEXT
);

-- Table Partenaire
CREATE TABLE partenaire (
    id_partenaire SERIAL PRIMARY KEY,
    nom VARCHAR(200) NOT NULL,
    pays VARCHAR(100) NOT NULL
);

-- Table Projets_LAAS
CREATE TABLE projets_laas (
    id_projet SERIAL PRIMARY KEY,
    titre VARCHAR(300) NOT NULL,
    acronyme VARCHAR(50),
    annee_debut INTEGER NOT NULL,
    duree INTEGER NOT NULL,
    cout_global NUMERIC(15, 2),
    budget NUMERIC(15, 2),
    id_porteur INTEGER NOT NULL,
    CONSTRAINT fk_projet_porteur FOREIGN KEY (id_porteur) 
        REFERENCES scientifique(id_scientifique)
        ON DELETE RESTRICT
        ON UPDATE CASCADE,
    CONSTRAINT chk_duree CHECK (duree > 0),
    CONSTRAINT chk_cout_global CHECK (cout_global >= 0),
    CONSTRAINT chk_budget CHECK (budget >= 0)
);

-- Table Enseignant_chercheur
CREATE TABLE enseignant_chercheur (
    id_ec INTEGER PRIMARY KEY,
    echelon VARCHAR(50),
    id_etablissement INTEGER NOT NULL,
    CONSTRAINT fk_ec_scientifique FOREIGN KEY (id_ec) 
        REFERENCES scientifique(id_scientifique)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    CONSTRAINT fk_ec_etablissement FOREIGN KEY (id_etablissement) 
        REFERENCES etablissement(id_etablissement)
        ON DELETE RESTRICT
        ON UPDATE CASCADE
);

-- Table Chercheur
CREATE TABLE chercheur (
    id_chercheur INTEGER PRIMARY KEY,
    CONSTRAINT fk_chercheur_scientifique FOREIGN KEY (id_chercheur) 
        REFERENCES scientifique(id_scientifique)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

-- Table Publication
CREATE TABLE publication (
    id_publication SERIAL PRIMARY KEY,
    titre VARCHAR(500) NOT NULL,
    annee INTEGER NOT NULL,
    nom_de_conference VARCHAR(200),
    classe VARCHAR(50),
    nb_pages INTEGER,
    CONSTRAINT chk_nb_pages CHECK (nb_pages > 0)
);

-- Table Lab_externe
CREATE TABLE lab_externe (
    id_l_externe SERIAL PRIMARY KEY,
    nom VARCHAR(200) NOT NULL,
    pays VARCHAR(100) NOT NULL
);

-- Table Auteur_externe
CREATE TABLE auteur_externe (
    id_a_externe SERIAL PRIMARY KEY,
    nom VARCHAR(100) NOT NULL,
    prenom VARCHAR(100) NOT NULL,
    adresse_mail VARCHAR(200),
    id_l_externe INTEGER NOT NULL,
    CONSTRAINT fk_auteur_lab FOREIGN KEY (id_l_externe) 
        REFERENCES lab_externe(id_l_externe)
        ON DELETE RESTRICT
        ON UPDATE CASCADE
);

-- ============================================================================
-- TABLES D'ASSOCIATIONS
-- ============================================================================

-- Table ParticipationPersoJPO
CREATE TABLE participation_perso_jpo (
    id_participant INTEGER NOT NULL,
    id_jpo INTEGER NOT NULL,
    PRIMARY KEY (id_participant, id_jpo),
    CONSTRAINT fk_participation_jpo_personnel FOREIGN KEY (id_participant) 
        REFERENCES personnel(id_personnel)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    CONSTRAINT fk_participation_jpo_event FOREIGN KEY (id_jpo) 
        REFERENCES journee_portes_ouvertes(id_jpo)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

-- Table PresidentCongres
CREATE TABLE president_congres (
    id_scientifique INTEGER NOT NULL,
    id_congres INTEGER NOT NULL,
    PRIMARY KEY (id_scientifique, id_congres),
    CONSTRAINT fk_president_scientifique FOREIGN KEY (id_scientifique) 
        REFERENCES scientifique(id_scientifique)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    CONSTRAINT fk_president_congres FOREIGN KEY (id_congres) 
        REFERENCES congres(id_congres)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

-- Table ParticipationAEPubli
CREATE TABLE participation_ae_publi (
    id_publication INTEGER NOT NULL,
    id_a_externe INTEGER NOT NULL,
    PRIMARY KEY (id_publication, id_a_externe),
    CONSTRAINT fk_participation_ae_publication FOREIGN KEY (id_publication) 
        REFERENCES publication(id_publication)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    CONSTRAINT fk_participation_ae_auteur FOREIGN KEY (id_a_externe) 
        REFERENCES auteur_externe(id_a_externe)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

-- Table ParticipationPersonelPubli
CREATE TABLE participation_personel_publi (
    id_publication INTEGER NOT NULL,
    id_personnel INTEGER NOT NULL,
    PRIMARY KEY (id_publication, id_personnel),
    CONSTRAINT fk_participation_perso_publication FOREIGN KEY (id_publication) 
        REFERENCES publication(id_publication)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    CONSTRAINT fk_participation_perso_personnel FOREIGN KEY (id_personnel) 
        REFERENCES personnel(id_personnel)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

-- Table Encadrer
CREATE TABLE encadrer (
    id_scientifique INTEGER NOT NULL,
    id_doc INTEGER NOT NULL,
    PRIMARY KEY (id_scientifique, id_doc),
    CONSTRAINT fk_encadrer_scientifique FOREIGN KEY (id_scientifique) 
        REFERENCES scientifique(id_scientifique)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    CONSTRAINT fk_encadrer_doctorant FOREIGN KEY (id_doc) 
        REFERENCES doctorant(id_doc)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

-- Table ParticipationProjetLAAS
CREATE TABLE participation_projet_laas (
    id_participant INTEGER NOT NULL,
    id_projet INTEGER NOT NULL,
    PRIMARY KEY (id_participant, id_projet),
    CONSTRAINT fk_participation_projet_scientifique FOREIGN KEY (id_participant) 
        REFERENCES scientifique(id_scientifique)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    CONSTRAINT fk_participation_projet_projet FOREIGN KEY (id_projet) 
        REFERENCES projets_laas(id_projet)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

-- Table SponsoringProjet
CREATE TABLE sponsoring_projet (
    id_sponsor INTEGER NOT NULL,
    id_projet INTEGER NOT NULL,
    PRIMARY KEY (id_sponsor, id_projet),
    CONSTRAINT fk_sponsoring_partenaire FOREIGN KEY (id_sponsor) 
        REFERENCES partenaire(id_partenaire)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    CONSTRAINT fk_sponsoring_projet FOREIGN KEY (id_projet) 
        REFERENCES projets_laas(id_projet)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

-- ============================================================================
-- INDICES POUR OPTIMISATION DES PERFORMANCES
-- ============================================================================

CREATE INDEX idx_personnel_nom ON personnel(nom);
CREATE INDEX idx_personnel_date_recrutement ON personnel(date_recrutement);
CREATE INDEX idx_evenement_dates ON evenement(date_debut, date_fin);
CREATE INDEX idx_scientifique_grade ON scientifique(grade);
CREATE INDEX idx_projet_porteur ON projets_laas(id_porteur);
CREATE INDEX idx_projet_annee ON projets_laas(annee_debut);
CREATE INDEX idx_publication_annee ON publication(annee);
CREATE INDEX idx_auteur_externe_lab ON auteur_externe(id_l_externe);

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
-- FIN DU CREATION DES TABLES
-- ============================================================================
