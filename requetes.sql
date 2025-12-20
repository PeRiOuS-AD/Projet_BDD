-- --1. Le nom et le grade des encadrants du doctorant dont l’identifiant est "d001".
-- --2. Le nom et le pays des auteurs collaborateurs (auteurs externes) du chercheur "Jean Azi" de 2016 à 2020.
-- --3. Le nombre de collaborateurs total du chercheur d’identifiant "S001".
-- --4. Le nombre de pays avec lesquels le LAAS a collaboré dans le cadre de publications de rang A (i.e. le nombre d’articles publiés dans des conférences de classe A).
-- --5. Pour les doctorants, on souhaiterait récupérer le nombre de leurs publications. On veut retourner l’identifiant de chaque doctorant accompagné du nombre de ses publications.

-- --6. Le nombre de doctorants du laboratoire ayant soutenu
SELECT COUNT(*) AS nb_doc_ayant_soutenu
FROM Doctorant
WHERE date_soutenance IS NOT NULL;

-- 7. Le nom et le prénom des chercheurs qui n’ont jamais encadré.
SELECT p.nom, p.prenom
FROM Personnel AS p, Scientifique AS s
WHERE p.id_personnel = s.id_scientifique
AND s.id_scientifique NOT IN (SELECT id_scientifique FROM Encadrer);

-- 8. Le nom et le prénom des chercheurs qui n’ont jamais publié, ni encadré.
SELECT DISTINCT p.nom, p.prenom
FROM Personnel p, Scientifique s
WHERE p.id_personnel = s.id_scientifique
AND s.id_scientifique NOT IN (SELECT id_personnel FROM ParticipationPersonelPubli)
AND s.id_scientifique NOT IN (SELECT id_scientifique FROM Encadrer);

-- 9. Le nom et prénom des chercheurs qui encadrent mais n’ont pas de doctorants ayant déjà
-- soutenu.
SELECT DISTINCT p.nom, p.prenom
FROM Personnel AS p
JOIN Scientifique AS s ON p.id_personnel = s.id_scientifique
JOIN Encadrer AS e ON s.id_scientifique = e.id_scientifique
WHERE s.id_scientifique NOT IN (
    SELECT e2.id_scientifique
    FROM Encadrer AS e2, Doctorant AS d
    WHERE e2.id_doc = d.id_doc 
    AND d.date_soutenance IS NOT NULL
);

-- 10. L’identifiant, nom et prénom des doctorants qui ont un seul encadrant.
-- 11. Les chercheurs qui ont plus de 4 doctorants en cours. Pour chaque chercheur, on veut afficher
-- son identifiant, son nom, son prenom, et son nombre de doctorants.
-- 12. L’identifiant des chercheurs qui n’ont publié que dans des conférences de classe A.
-- 13. Nom, prénom et identifiant des chercheurs qui ont encadré tous les doctorants.
-- 14. Le nombre de publications du laboratoire par année.
-- 15. Le nombre d’enseignants chercheurs par établissement d’enseignement.
-- 16. Le(s) pays avec lequel le laboratoire a le plus de publications.
-- 17. Les scientifiques qui ont un seul projet.
-- 18. Les scientifiques qui ont participé à tous les projets.
-- 19. Les établissements d’enseignements ayant plus de 50 enseignants-chercheurs appartenant au
-- LAAS.
-- 20. Les scientifiques qui ont le plus de projets.
-- 21. Les pays qui sont impliqués dans tous les projets.
