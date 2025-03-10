# PLANT.CO SALES - Power BI

## Source de données
[Sales](Plant_DTS.xls)


## Objectif
Ce projet vise à analyser les performances de ventes de la société Plant.Co . Grâce aux données visuelles, nous identifions les variations de ventes par pays, par mois et par type de produit.

---
## I.  Netoyage des données 

### 1. Suppression des Doublons
Supprimmer les enregistrements doubles
### 2. Transformation des données
- Ajout d'une table Dim_Date qui nous servira de calendrier: 
  ```dax
    Dim_Date = CALENDAR( DATE(2022, 1, 1), DATE(2024, 12,31))
    ```
  nos données de ventes vont de l'année 2022 à 2024 donc notre calendrier ira du 01/01/2022 au 31/12/2024 

- Ajout de la colonne Inpast dans la table Dim_Date
  ```dax
    Inpast = VAR lastsalesdate = Max(Fact_Sale[Date_Time]) VAR lastsalesdatePY = EDATE(lastsalesdate, -12) RETURN Dim_Date[Date] <= lastsalesdatePY
    ```
     nous récupérons toutes les dates de ventes dans la variables lastsalesdate, ensuite dans la variable lastsalesdatePY nous mettons chaque date de la variable lastsalesdate mais avec 12 mois de Moins, enfin nous vérifions si les dates de lastsalesdate sont disponible dans notre calendrier

     cette variable nous permetra de comparer les performances d'un mois avec celles du même mois de l'année antérieur
- Création de la table slc_values avec la colonne Values( Sales Gross Profit Quantity)

 ### 3. Mesures

- Total des ventes
 ```dax
    Sales = Sum(Fact_Sale[Sales_USD])
 ```
 somme des montants de ventes
- Quantités Vendues
 ```dax
    Quantity = Sum(Fact_Sale[quantity])
 ``` 
 somme des quantités vendues
- Profit Brut
 ```dax
    Gross Profit = [Sales] - [COGs]
 ``` 
 le profit brut représente la différence entre le montant des ventes et le montant des dépences
 - Marge Bénéficiaire
 ```dax
    GP% = DIVIDE([Gross Profit],[Sales])
 ``` 
 Montre la rentabilité de l'entreprise
 - Chiffre d'Affaires Cumulé
 ```dax
   YTD_Sales = TOTALYTD([Sales], Fact_Sale[Date_Time])
 ``` 
 Cette mesure calcule le chiffre d'affaires cumulé depuis le début de l'année jusqu'à la date actuelle

 - Chiffre d'Affaires Cumulé de l'an passé à la même période
 ```dax
   PYTD_Sales = 
CALCULATE(
    [Sales], 
    SAMEPERIODLASTYEAR(Dim_Date[Date]), 
    Dim_Date[Inpast] = TRUE
)

 ``` 
cette mesure vérifie si la période actuelle - 12 mois existe dans notre calendrier grace à  Dim_Date[Inpast] = TRUE et calcule le chiffre d'affaires cumulé à cette période 
 
  - Quantité Cumulé
 ```dax
   YTD_Quantities = TOTALYTD([Quantity],Fact_Sale[Date_Time])
 ``` 
 Cette mesure calcule la quantité vendue cumulé depuis le début de l'année jusqu'à la date actuelle

  - Quantité Cumulé de l'an passé à la même période
 ```dax
   PYTD_Quantities = 
CALCULATE(
    [Quantity], 
    SAMEPERIODLASTYEAR(Dim_Date[Date]), 
    Dim_Date[Inpast] = TRUE
)

 ``` 
cette mesure vérifie si la période actuelle - 12 mois existe dans notre calendrier grace à  Dim_Date[Inpast] = TRUE et calcule la quantité vendu cumulé à cette période 

  - Profit Brut Cumulé
 ```dax
   YTD_GrossProfit = TOTALYTD([Gross Profit],Fact_Sale[Date_Time])
 ``` 
Elle calcule le profit brut cumulé (Gross Profit Year-To-Date) en additionnant toutes les valeurs de [Gross Profit] depuis le 1er janvier jusqu'à la date en cours 
 - Quantité Cumulé de l'an passé à la même période
 ```dax
   PYTD_Gross_Profit = 
CALCULATE(
    [Gross Profit], 
    SAMEPERIODLASTYEAR(Dim_Date[Date]), 
    Dim_Date[Inpast] = TRUE
)

 ``` 
cette mesure vérifie si la période actuelle - 12 mois existe dans notre calendrier grace à  Dim_Date[Inpast] = TRUE et calcule le profit brut cumulé à cette période 
 s
 

 
![data sheet](data_survey.png) 
### 4. Model de données

![data sheet](data_survey_model.png)

 ## II. Graphiques 

 ### 1. Nombres de participants à l'enquête
![TCD](survey_takers.png)

 ### 2. Moyenne d'age 
![TCD](average_age_of_survey_takers.png)

 ### 3. Pays des participants
![TCD](country_of_survey_takers.png)

- 41,43% des participants viennent des USA
- 35,56% des participants viennent des Pays non répertoriés
- 11,59% des participants viennent de l'inde
- 6,35% des participants viennent des Royaume-Uni
- 5,08% des participants viennent du Canada

 ### 4. Moyenne des salaires par rôle
![TCD](average_salary_by_job_title.png)

le Top 3 des métiers les mieux payés: Data Scientist, Data Architect, Data Engineer.

 ### 5. Langages les plus utilisés
![TCD](favorite_programming_language.png)

Le language le plus utilisés est python et une grande partie des utilisateurs sont des analystes de données

 ### 6 Difficulté pour entrer dans le monde de la data. 
![TCD](difficulty_to_brake_into_data.png)

- 42,7% des participants  trouvent le domaine de la data ni facile ni difficile
- 24,76% des participants trouvent ce domaine difficile
- 21,27% des participants trouvent ce domaine facile
- 6,98% des participants trouvent ce domaine très difficile
- 4,29% des participants trouvent ce domaine très facile

 ### 7. Satisfaction Salariale
![TCD](hapiness_salary.png)

Il s'agit de la valeur actuelle de satisfaction salariale sur une échelle de 0 à 10 et 4,27 représente la valeure centrale.

 ### 8. Satisfaction Dans Le Travail
![TCD](hapiness_work.png)

Il s'agit de la valeur actuelle de satisfaction dans le travail sur une échelle de 0 à 10 et 5,74 représente la valeure centrale.


 ## III. Rapport Final

 ![TCD](Repport.png)