DROP VIEW IF EXISTS publication_pas_que_A;
DROP VIEW IF EXISTS publication_par_pays;
DROP VIEW IF EXISTS Collaborateurs_internes_S001;
DROP VIEW IF EXISTS Collaborateurs_externes_S001;

 --1. Le nom et le grade des encadrants du doctorant dont l’identifiant est "d001".
SELECT p.nom, s.grade
FROM Encadrer e
INNER JOIN scientifique s ON e.id_scientifique = s.id_scientifique
INNER JOIN personnel   p ON s.id_scientifique = p.id_personnel
WHERE e.id_doc = '01';
-- --2. Le nom et le pays des auteurs collaborateurs (auteurs externes) du chercheur "Jean Azi" de 2016 à 2020.
SELECT DISTINCT ae.nom, le.pays
FROM Personnel p
INNER JOIN scientifique s ON p.id_personnel= s.id_scientifique
INNER JOIN participation_personel_publi ppp ON p.id_personnel   = ppp.id_personnel
INNER JOIN publication pub ON ppp.id_publication = pub.id_publication
INNER JOIN participation_ae_publi pae ON pub.id_publication = pae.id_publication
INNER JOIN auteur_externe ae ON pae.id_a_externe = ae.id_a_externe
INNER JOIN lab_externe le ON ae.id_l_externe = le.id_l_externe
WHERE p.nom = 'Azi' AND p.prenom = 'Jean' AND pub.annee BETWEEN 2016 AND 2020;

-- --3. Le nombre de collaborateurs total du chercheur d’identifiant "S001".
--On commence déjà par:
--3.1/faire sortir tous les collaborteur de table "personnels" à "S001" 

CREATE VIEW  Collaborateurs_internes_S001 AS
SELECT DISTINCT p2.id_personnel AS id_collaborateur_interne
FROM participation_personel_publi p2
WHERE p2.id_publication IN (
    SELECT id_publication
    FROM participation_personel_publi
    WHERE id_personnel = '01'
)
AND p2.id_personnel <> '01';

--3.2/faire sortir tous les collaborteur de table "auteurs externes" à "S001" 
CREATE VIEW Collaborateurs_externes_S001 AS
SELECT DISTINCT
    pae.id_a_externe AS id_collaborateur_externe
FROM participation_personel_publi p1
JOIN participation_ae_publi pae
  ON p1.id_publication = pae.id_publication
WHERE p1.id_personnel = '01';
--3.3/finalement on applique un union aux deux view préparés:
SELECT COUNT(*) AS nb_collaborateurs
FROM (SELECT id_collaborateur_interne AS id_collaborateur
FROM Collaborateurs_internes_S001
UNION SELECT id_collaborateur_externe AS id_collaborateur
FROM Collaborateurs_externes_S001) AS TousCollaborateurs_externes_internes;

-- --4. Le nombre de pays avec lesquels le LAAS a collaboré dans le cadre de publications de rang A (i.e. le nombre d’articles publiés dans des conférences de classe A).
SELECT COUNT(DISTINCT(pays)) FROM lab_externe WHERE id_l_externe IN 
	(SELECT id_l_externe FROM auteur_externe WHERE id_a_externe IN 
		(SELECT id_a_externe FROM participation_ae_publi WHERE id_publication IN 
			(SELECT id_publication FROM publication WHERE classe = 'A') 
			and id_publication IN 
			(SELECT id_publication FROM participation_personel_publi WHERE id_personnel IN
				(SELECT id_chercheur FROM chercheur))));

-- --5. Pour les doctorants, on souhaiterait récupérer le nombre de leurs publications. On veut retourner l’identifiant de chaque doctorant accompagné du nombre de ses publications.
SELECT id_personnel, count(id_personnel) FROM participation_personel_publi
GROUP by id_personnel
HAVING id_personnel IN
(SELECT id_doc FROM doctorant);
-- --6. Le nombre de doctorants du laboratoire ayant soutenu
SELECT COUNT(*) AS nb_doc_ayant_soutenu
FROM doctorant
WHERE date_soutenance IS NOT NULL;

-- 7. Le nom et le prénom des chercheurs qui n’ont jamais encadré.
SELECT p.nom, p.prenom
FROM personnel AS p, scientifique AS s
WHERE p.id_personnel = s.id_scientifique
AND s.id_scientifique NOT IN (SELECT id_scientifique FROM Encadrer);

-- 8. Le nom et le prénom des chercheurs qui n’ont jamais publié, ni encadré.
SELECT DISTINCT p.nom, p.prenom
FROM personnel AS p, scientifique AS s
WHERE p.id_personnel = s.id_scientifique
AND s.id_scientifique NOT IN (SELECT id_personnel FROM participation_personel_publi)
AND s.id_scientifique NOT IN (SELECT id_scientifique FROM encadrer);

-- 9. Le nom et prénom des chercheurs qui encadrent mais n’ont pas de doctorants ayant déjà
-- soutenu.
SELECT DISTINCT p.nom, p.prenom
FROM personnel AS p
JOIN scientifique AS s ON p.id_personnel = s.id_scientifique
JOIN encadrer AS e ON s.id_scientifique = e.id_scientifique
WHERE s.id_scientifique NOT IN (
    SELECT e2.id_scientifique
    FROM encadrer AS e2, doctorant AS d
    WHERE e2.id_doc = d.id_doc 
    AND d.date_soutenance IS NOT NULL
);

-- 10. L’identifiant, nom et prénom des doctorants qui ont un seul encadrant.
SELECT d.id_doc, p.nom, p.prenom
FROM doctorant AS d
INNER JOIN personnel AS p ON d.id_doc = p.id_personnel
WHERE 1 = (
	SELECT COUNT(*)
	FROM encadrer AS e
	WHERE d.id_doc = e.id_doc
);
-- 11. Les chercheurs qui ont plus de 4 doctorants en cours. Pour chaque chercheur, on veut afficher
-- son identifiant, son nom, son prenom, et son nombre de doctorants.

SELECT p.id_personnel, p.nom, p.prenom, COUNT(e.id_doc) AS nb_doctorants
FROM personnel p
INNER JOIN scientifique s ON p.id_personnel = s.id_scientifique
INNER JOIN chercheur c ON s.id_scientifique = c.id_chercheur
INNER JOIN encadrer e ON c.id_chercheur = e.id_scientifique
INNER JOIN doctorant d ON e.id_doc = d.id_doc
--WHERE d.date_soutenance IS NULL OR d.date_soutenance > CURRENT_DATE
GROUP BY p.id_personnel, p.nom, p.prenom
HAVING COUNT(e.id_doc) > 4;

-- 12. L’identifiant des chercheurs qui n’ont publié que dans des conférences de classe A.

CREATE VIEW publication_pas_que_A AS
SELECT ppp.id_personnel
FROM participation_personel_publi ppp
INNER JOIN publication p ON ppp.id_publication = p.id_publication
WHERE p.classe <> 'A';

SELECT DISTINCT pp.id_personnel
FROM participation_personel_publi pp
INNER JOIN publication pub ON pp.id_publication = pub.id_publication
INNER JOIN scientifique s ON pp.id_personnel = s.id_scientifique
WHERE pub.classe = 'A' AND pp.id_personnel NOT IN (SELECT id_personnel FROM publication_pas_que_A);

-- 13. Nom, prénom et identifiant des chercheurs qui ont encadré tous les doctorants.

SELECT 
    s.id_scientifique, 
    p.nom, 
    p.prenom
FROM scientifique s
INNER JOIN personnel P ON s.id_scientifique = p.id_personnel
INNER JOIN encadrer e ON s.id_scientifique = e.id_scientifique
GROUP BY s.id_scientifique, p.nom, p.prenom
HAVING COUNT(DISTINCT e.id_doc) = (
    SELECT COUNT(*) FROM doctorant   -- Nombre total de doctorants dans la base
);

-- 14. Le nombre de publications du laboratoire par année.

SELECT annee, COUNT(id_publication) AS nb_pub
FROM publication
GROUP BY annee
ORDER BY annee ;

-- 15. Le nombre d’enseignants chercheurs par établissement d’enseignement.

SELECT et.nom, COUNT(ec.id_ec) AS nb_enseignants_chercheurs
FROM etablissement et
INNER JOIN enseignant_chercheur ec ON et.id_etablissement = ec.id_etablissement
GROUP BY et.id_etablissement, et.nom;

--Q16:Les pays avec lequel le laboratoire a le plus de publications

CREATE VIEW publication_par_pays AS
SELECT l.pays,COUNT(p.id_publication) AS nb_pubs
FROM publication p
INNER JOIN participation_ae_publi pae ON p.id_publication = pae.id_publication
INNER JOIN auteur_externe ae ON pae.id_a_externe = ae.id_a_externe
INNER JOIN lab_externe l ON ae.id_l_externe = l.id_l_externe
GROUP BY l.pays;

SELECT pays, nb_pubs
FROM publication_par_pays
WHERE nb_pubs >= (SELECT MAX(nb_pubs) FROM publication_par_pays);

--17. Les scientifiques qui ont un seul projet.
SELECT *
FROM Scientifique s
WHERE s.id_scientifique IN (
    SELECT id_participant 
    FROM participation_projet_laas 
    GROUP BY id_participant 
    HAVING COUNT(DISTINCT id_projet) = 1
);

--18. Les scientifiques qui ont participé à tous les projets.
SELECT *
FROM scientifique s
WHERE s.id_scientifique IN (
    SELECT r1.id_participant
    FROM participation_projet_LAAS r1
    WHERE NOT EXISTS (
        SELECT *
        FROM projets_laas p
        WHERE NOT EXISTS (
            SELECT * 
            FROM participation_projet_laas r2
            WHERE r1.id_participant = r2.id_participant
            AND p.id_projet = r2.id_projet
        )
    )
);

--19. Les établissements d’enseignements ayant plus de 50 enseignants-chercheurs appartenant au LAAS.
SELECT *
FROM etablissement e
WHERE e.id_etablissement IN (
    SELECT ec.id_etablissement
    FROM enseignant_chercheur ec
    WHERE EXISTS (
        SELECT *
        FROM participation_projet_laas ppl
        WHERE ppl.id_participant = ec.id_ec
    )
    GROUP BY ec.id_etablissement
    HAVING COUNT(*) > 50
);

--20. Les scientifiques qui ont le plus de projets.
SELECT *
FROM scientifique s
WHERE (SELECT COUNT(DISTINCT id_projet) 
       FROM participation_projet_laas 
       WHERE id_participant = s.id_scientifique) = (
    SELECT MAX(nb)
    FROM (
        SELECT COUNT(DISTINCT id_projet) AS nb
        FROM participation_projet_laas
        GROUP BY id_participant
    ) AS max_table 
);


--21. Les pays qui sont impliqués dans tous les projets.

SELECT DISTINCT pt.pays
FROM Partenaire pt
WHERE NOT EXISTS (
    SELECT *
    FROM projets_laas pr
    WHERE NOT EXISTS (
        SELECT *
        FROM sponsoring_projet sp
        WHERE sp.id_sponsor IN (
            SELECT p.id_partenaire
            FROM partenaire p
            WHERE p.pays = pt.pays
        )
        AND sp.id_projet = pr.id_projet
    )
);
