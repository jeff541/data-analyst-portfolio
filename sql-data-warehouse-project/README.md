# Datawarehouse - SQL SERVER

## Source de données
[CRM](/sql-data-warehouse-project/datasets/source_crm.rar)
[ERP](/sql-data-warehouse-project/datasets/source_erp.rar)

## Problématique métier
Une entreprise souhaite mettre en place un datawarehouse pour la gestion de ses ventes

## Objectif
Mettre en place un datawarehouse avec l'architecture medaillon

---
### 1.  Etapes du projet

 ![Plan](/sql-data-warehouse-project/docs/plan.png)

 ### 2.  Analyse des besoins

 L'entreprise a besoins d'un datawarehouse optimisé pour  avec des vues optimisées 
 pour les requêtes sur les ventes

 ### 3.  Architecture de données

 ![Plan](/sql-data-warehouse-project/docs/architecture.png)

 Couche Bronze : Les Données Brutes À cette première étape, nous stockons les données dans leur format initial. Ici, pas de transformation ni de modélisation ! On se contente d’un chargement par lots ou complet (Tronquer & Insérer) pour garantir une réception fidèle de l’ensemble des informations.

Couche Argent : Données Nettoyées et Standardisées La seconde couche est dédiée à l’enrichissement de nos données. Un nettoyage minutieux, une standardisation, une normalisation, et l’ajout de colonnes dérivées nous permettent de créer une base fiable pour des analyses de qualité. Ce traitement par lots nous assure de disposer d’un jeu de données cohérent, même en cas de volumes importants.

Couche Or : Données Prêtes pour l’Entreprise Enfin, la couche la plus aboutie offre aux utilisateurs finaux – qu’il s’agisse de professionnels de la BI, d’experts en visualisation ou d’analystes SQL – des vues intégrées. Grâce à des agrégations et des logiques métiers adaptées, nous pouvons proposer des schémas en étoile, des tables plates ou des tableaux agrégés pour répondre aux exigences stratégiques de l’entreprise.

### 4.  Couche de Bronze
  
- Creation de la Base de Données
    [Télécharger le fichier](/sql-data-warehouse-project/scripts/1_création_bd_et_shemas.sql)

- Creation des tables de bronzes
    [Télécharger le fichier](/sql-data-warehouse-project/scripts/bronze/2_création_des_tables.sql)

- Insertion des données
    [Télécharger le fichier](/sql-data-warehouse-project/scripts/bronze/3_procedure_stoquee.sql)

### 5.  Couche d'Argent

- Creation des tables d'argents
[Télécharger le fichier](/sql-data-warehouse-project/scripts/silver/4_création_des_tables.sql)

- Insertion des données
[Télécharger le fichier](/sql-data-warehouse-project/scripts/silver/5_procedure_stoquee.sql)

- Validation des données
[Télécharger le fichier](/sql-data-warehouse-project/tests/test_argent.sql)

### 6.  Couche d'Or

- Modélisation

![Model](/sql-data-warehouse-project/docs/data_mart.png)

- Integration

![Model](/sql-data-warehouse-project/docs/gold_integration.png)

- Creation des vues et insertion des données
[Télécharger le fichier](/sql-data-warehouse-project/scripts/gold/6_creation_des_vues.sql)

- Validation des données
[Télécharger le fichier](/sql-data-warehouse-project/tests/test_argent.sql)

### Conclusion 

En résumé, la mise en place de ce datawarehouse en architecture médaillon permet une gestion structurée et progressive des données issues du CRM et de l’ERP.
Chaque couche joue un rôle clé : la Bronze stocke les données brutes, l’Argent les nettoie et les structure, et l’Or les rend exploitables pour l’analyse.
Cette approche assure la qualité, la cohérence et la fiabilité des données pour une prise de décision efficace.
Elle constitue une base solide pour les besoins futurs en reporting et business intelligence.