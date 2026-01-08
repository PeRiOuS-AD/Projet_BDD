-- ============================================================================
-- Script d'insertion de données pour la base de données LAAS
-- Système de Gestion de Base de Données : PostgreSQL
-- ============================================================================

-- Désactivation temporaire des contraintes de clés étrangères pour l'insertion
SET CONSTRAINTS ALL DEFERRED;

BEGIN;

-- ============================================================================
-- INSERTION DANS LES TABLES PRINCIPALES
-- ============================================================================

-- Insertion dans Personnel
INSERT INTO personnel (nom, prenom, date_de_naissance, adresse, date_recrutement) VALUES
('Dupont', 'Marie', '1985-03-15', '12 Rue de la République, 31000 Toulouse', '2010-09-01'),
('Martin', 'Jean', '1978-07-22', '45 Avenue Jean Jaurès, 31400 Toulouse', '2005-01-15'),
('Dubois', 'Sophie', '1990-11-30', '8 Boulevard Carnot, 31000 Toulouse', '2015-09-01'),
('Bernard', 'Pierre', '1982-05-18', '23 Rue Alsace Lorraine, 31000 Toulouse', '2008-03-01'),
('Petit', 'Claire', '1988-09-12', '67 Allée Jean Jaurès, 31000 Toulouse', '2012-09-01'),
('Moreau', 'Luc', '1975-02-28', '34 Rue de Metz, 31000 Toulouse', '2000-09-01'),
('Simon', 'Isabelle', '1983-12-05', '56 Avenue de Lyon, 31500 Toulouse', '2009-09-01'),
('Laurent', 'Thomas', '1991-04-20', '89 Rue Bayard, 31000 Toulouse', '2016-09-01'),
('Lefebvre', 'Anne', '1986-08-14', '12 Place du Capitole, 31000 Toulouse', '2011-09-01'),
('Roux', 'François', '1980-01-25', '78 Rue de la Pomme, 31000 Toulouse', '2007-09-01'),
('Fournier', 'Julie', '1992-06-18', '45 Avenue Étienne Billières, 31300 Toulouse', '2018-09-01'),
('Girard', 'Marc', '1984-10-09', '23 Rue Saint-Michel, 31400 Toulouse', '2010-01-15'),
('Bonnet', 'Élise', '1989-03-27', '67 Boulevard Lascrosses, 31000 Toulouse', '2014-09-01'),
('Leroy', 'David', '1977-12-11', '34 Allée de Brienne, 31000 Toulouse', '2003-09-01'),
('Garnier', 'Nathalie', '1987-05-22', '12 Rue Lafayette, 31000 Toulouse', '2013-09-01');

-- Insertion dans Etablissement
INSERT INTO etablissement (nom, acronyme, adresse) VALUES
('Institut National des Sciences Appliquées', 'INSA', '135 Avenue de Rangueil, 31077 Toulouse'),
('Université Paul Sabatier', 'UPS', '118 Route de Narbonne, 31062 Toulouse'),
('École Nationale Supérieure d''Électronique', 'ENSEEIHT', '2 Rue Charles Camichel, 31071 Toulouse'),
('Institut Supérieur de l''Aéronautique et de l''Espace', 'ISAE-SUPAERO', '10 Avenue Édouard Belin, 31055 Toulouse');

-- Insertion dans Evenement
INSERT INTO evenement (date_debut, date_fin) VALUES
('2024-03-15', '2024-03-15'),
('2024-05-20', '2024-05-24'),
('2024-10-10', '2024-10-10'),
('2024-11-05', '2024-11-08'),
('2025-02-12', '2025-02-12');

-- Insertion dans Journee_Portes_Ouvertes
INSERT INTO journee_portes_ouvertes (id_jpo) VALUES
(1),
(3),
(5);

-- Insertion dans Congres
INSERT INTO congres (id_congres, nb_inscris, classe) VALUES
(2, 250, 'A'),
(4, 180, 'B');

-- Insertion dans Scientifique
INSERT INTO scientifique (id_scientifique, grade) VALUES
(1, 'Maître de Conférences'),
(2, 'Professeur'),
(4, 'Chargé de Recherche CNRS'),
(5, 'Directeur de Recherche CNRS'),
(6, 'Professeur'),
(7, 'Maître de Conférences'),
(9, 'Chargé de Recherche CNRS'),
(10, 'Professeur'),
(12, 'Maître de Conférences'),
(14, 'Directeur de Recherche CNRS');

-- Insertion dans Doctorant
INSERT INTO doctorant (id_doc, date_debut_these, date_soutenance) VALUES
(3, '2015-10-01', '2019-12-15'),
(8, '2016-09-01', '2020-06-30'),
(11, '2018-09-01', '2022-11-25'),
(13, '2019-09-01', NULL),
(15, '2020-09-01', NULL);

-- Insertion dans Enseignant_chercheur
INSERT INTO enseignant_chercheur (id_ec, echelon, id_etablissement) VALUES
(1, 'Classe normale - Échelon 6', 1),
(2, 'Première classe - Échelon 3', 2),
(6, 'Première classe - Échelon 2', 1),
(7, 'Classe normale - Échelon 5', 3),
(10, 'Classe exceptionnelle - Échelon 1', 4),
(12, 'Classe normale - Échelon 4', 2);

-- Insertion dans Chercheur
INSERT INTO chercheur (id_chercheur) VALUES
(4),
(5),
(9),
(14);

-- Insertion dans Partenaire
INSERT INTO partenaire (nom, pays) VALUES
('Airbus Defence and Space', 'France'),
('Thales Alenia Space', 'France'),
('Centre National d''Études Spatiales', 'France'),
('Siemens AG', 'Allemagne'),
('Nokia Bell Labs', 'États-Unis'),
('Samsung Electronics', 'Corée du Sud'),
('Huawei Technologies', 'Chine');

-- Insertion dans Projets_LAAS
INSERT INTO projets_laas (titre, acronyme, annee_debut, duree, cout_global, budget, id_porteur) VALUES
('Autonomous Navigation Systems for Space Exploration', 'ANSSE', 2020, 4, 1500000.00, 450000.00, 2),
('Quantum Computing for Cryptography', 'QCC', 2021, 3, 800000.00, 250000.00, 5),
('Machine Learning for Medical Imaging', 'MLMI', 2019, 5, 2000000.00, 600000.00, 6),
('Energy Harvesting in IoT Devices', 'EHIOT', 2022, 3, 600000.00, 180000.00, 4),
('5G Network Optimization', '5GNO', 2020, 4, 1200000.00, 400000.00, 10),
('Robotics for Industrial Automation', 'RIA', 2021, 3, 900000.00, 300000.00, 1),
('Artificial Intelligence for Climate Modeling', 'AICM', 2023, 4, 1800000.00, 550000.00, 14);

-- Insertion dans Lab_externe
INSERT INTO lab_externe (nom, pays) VALUES
('Massachusetts Institute of Technology - CSAIL', 'États-Unis'),
('ETH Zurich - Computer Science Department', 'Suisse'),
('University of Oxford - Department of Computer Science', 'Royaume-Uni'),
('Technical University of Munich - Institute of Robotics', 'Allemagne'),
('National University of Singapore - School of Computing', 'Singapour'),
('University of Tokyo - Graduate School of Information Science', 'Japon');

-- Insertion dans Auteur_externe
INSERT INTO auteur_externe (nom, prenom, adresse_mail, id_l_externe) VALUES
('Smith', 'John', 'j.smith@csail.mit.edu', 1),
('Johnson', 'Emily', 'e.johnson@csail.mit.edu', 1),
('Müller', 'Hans', 'h.mueller@ethz.ch', 2),
('Schmidt', 'Anna', 'a.schmidt@ethz.ch', 2),
('Brown', 'Robert', 'robert.brown@cs.ox.ac.uk', 3),
('Wilson', 'Sarah', 'sarah.wilson@cs.ox.ac.uk', 3),
('Fischer', 'Michael', 'm.fischer@tum.de', 4),
('Weber', 'Julia', 'j.weber@tum.de', 4),
('Tan', 'Wei', 'wei.tan@nus.edu.sg', 5),
('Lee', 'Min', 'min.lee@nus.edu.sg', 5),
('Tanaka', 'Yuki', 'y.tanaka@is.s.u-tokyo.ac.jp', 6),
('Sato', 'Hiro', 'h.sato@is.s.u-tokyo.ac.jp', 6);

-- Insertion dans Publication
INSERT INTO publication (titre, annee, nom_de_conference, classe, nb_pages) VALUES
('Advanced Algorithms for Autonomous Navigation in Unknown Environments', 2021, 'IEEE International Conference on Robotics and Automation', 'A', 8),
('Quantum Error Correction Codes for Practical Applications', 2022, 'ACM Symposium on Theory of Computing', 'A', 12),
('Deep Learning Approaches for Brain Tumor Detection', 2020, 'Medical Image Computing and Computer Assisted Intervention', 'A', 10),
('Energy-Efficient Protocols for Wireless Sensor Networks', 2022, 'IEEE International Conference on Communications', 'B', 6),
('Beamforming Techniques for Massive MIMO Systems', 2021, 'IEEE Global Communications Conference', 'A', 7),
('Vision-Based Grasp Planning for Robotic Manipulation', 2021, 'International Conference on Intelligent Robots and Systems', 'B', 8),
('Neural Network Models for Climate Prediction', 2023, 'International Conference on Machine Learning', 'A', 11),
('Security Analysis of Post-Quantum Cryptographic Schemes', 2022, 'Advances in Cryptology - CRYPTO', 'A', 15),
('Federated Learning for Privacy-Preserving Healthcare', 2023, 'Conference on Neural Information Processing Systems', 'A', 9),
('Swarm Robotics for Search and Rescue Operations', 2020, 'International Symposium on Distributed Autonomous Robotic Systems', 'B', 10);

-- ============================================================================
-- INSERTION DANS LES TABLES D'ASSOCIATIONS
-- ============================================================================

-- Insertion dans ParticipationPersoJPO
INSERT INTO participation_perso_jpo (id_participant, id_jpo) VALUES
(1, 1),
(2, 1),
(4, 1),
(6, 1),
(1, 3),
(5, 3),
(7, 3),
(10, 3),
(2, 5),
(6, 5),
(9, 5),
(12, 5);

-- Insertion dans PresidentCongres
INSERT INTO president_congres (id_scientifique, id_congres) VALUES
(2, 2),
(5, 2),
(6, 4),
(10, 4);

-- Insertion dans ParticipationAEPubli
INSERT INTO participation_ae_publi (id_publication, id_a_externe) VALUES
(1, 1),
(1, 7),
(2, 3),
(2, 4),
(3, 5),
(4, 9),
(5, 1),
(5, 2),
(6, 7),
(6, 8),
(7, 11),
(8, 3),
(9, 5),
(9, 6),
(10, 9),
(10, 10);

-- Insertion dans ParticipationPersonelPubli
INSERT INTO participation_personel_publi (id_publication, id_personnel) VALUES
(1, 2),
(1, 3),
(2, 5),
(2, 8),
(3, 6),
(3, 11),
(4, 4),
(4, 13),
(5, 10),
(5, 15),
(6, 1),
(6, 3),
(7, 14),
(8, 5),
(8, 9),
(9, 6),
(9, 13),
(10, 1),
(10, 4);

-- Insertion dans Encadrer
INSERT INTO encadrer (id_scientifique, id_doc) VALUES
(1, 3),
(2, 3),
(2, 8),
(5, 8),
(6, 11),
(10, 11),
(4, 13),
(9, 13),
(5, 15),
(14, 15);

-- Insertion dans ParticipationProjetLAAS
INSERT INTO participation_projet_laas (id_participant, id_projet) VALUES
(2, 1),
(1, 1),
(4, 1),
(5, 2),
(9, 2),
(6, 3),
(7, 3),
(12, 3),
(4, 4),
(9, 4),
(10, 5),
(12, 5),
(1, 6),
(2, 6),
(6, 6),
(14, 7),
(5, 7),
(9, 7);

-- Insertion dans SponsoringProjet
INSERT INTO sponsoring_projet (id_sponsor, id_projet) VALUES
(1, 1),
(3, 1),
(2, 2),
(4, 2),
(5, 3),
(6, 3),
(4, 4),
(7, 4),
(5, 5),
(6, 5),
(1, 6),
(4, 6),
(3, 7),
(7, 7);

COMMIT;

-- ============================================================================
-- VÉRIFICATION DES INSERTIONS
-- ============================================================================

-- Compte du nombre de lignes insérées dans chaque table
SELECT 'Personnel' AS table_name, COUNT(*) AS nb_lignes FROM personnel
UNION ALL
SELECT 'Etablissement', COUNT(*) FROM etablissement
UNION ALL
SELECT 'Evenement', COUNT(*) FROM evenement
UNION ALL
SELECT 'Journee_Portes_Ouvertes', COUNT(*) FROM Journee_Portes_Ouvertes
UNION ALL
SELECT 'Congres', COUNT(*) FROM congres
UNION ALL
SELECT 'Scientifique', COUNT(*) FROM scientifique
UNION ALL
SELECT 'Doctorant', COUNT(*) FROM doctorant
UNION ALL
SELECT 'Enseignant_chercheur', COUNT(*) FROM enseignant_chercheur
UNION ALL
SELECT 'Chercheur', COUNT(*) FROM chercheur
UNION ALL
SELECT 'Partenaire', COUNT(*) FROM partenaire
UNION ALL
SELECT 'Projets_LAAS', COUNT(*) FROM projets_LAAS
UNION ALL
SELECT 'Lab_externe', COUNT(*) FROM lab_externe
UNION ALL
SELECT 'Auteur_externe', COUNT(*) FROM auteur_externe
UNION ALL
SELECT 'Publication', COUNT(*) FROM publication
UNION ALL
SELECT 'ParticipationPersoJPO', COUNT(*) FROM participation_perso_jpo
UNION ALL
SELECT 'PresidentCongres', COUNT(*) FROM president_congres
UNION ALL
SELECT 'ParticipationAEPubli', COUNT(*) FROM participation_ae_publi
UNION ALL
SELECT 'ParticipationPersonelPubli', COUNT(*) FROM participation_personel_publi
UNION ALL
SELECT 'Encadrer', COUNT(*) FROM Encadrer
UNION ALL
SELECT 'ParticipationProjetLAAS', COUNT(*) FROM participation_projet_LAAS
UNION ALL
SELECT 'SponsoringProjet', COUNT(*) FROM sponsoring_projet;

-- ============================================================================
-- FIN DU SCRIPT D'INSERTION
-- ============================================================================
