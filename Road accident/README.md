# Road Accident - Excel

## Dataset Source
[Road Accident](https://docs.google.com/spreadsheets/d/1R_uaoZL18nRbqC_MULVne90h3SdRbAyn/edit?rtpof=true&sd=true&pli=1&gid=1319047066#gid=1319047066)

## Objectif
Nous analysons les accidents de la route pour identifier les facteurs influençant leur occurrence, tels que les conditions météorologiques, l'état des infrastructures et les caractéristiques des véhicules.

---
## I.  Netoyage des données 

### 1. Suppression des Doublons
Supprimmer les enregistrements doubles
### 2. Transformation de colonne
 - Remplacer l' élément Fetal de la colonne Accident Severity par Fatal
 - Ajouter les colone month(mois) et year(année) en se basant sur la colonne accident date

 ### 3. Apperçu du Jeu de données néttoyé

![data sheet](road_accident_data_sheet.png)
 ## II. Tableaux croisés dynamiques 
 ### 1. Analyse des Revenus Moyens en Fonction des Décisions d'Achat

 ![TCD](avg_income_gender.png)

    L'image montre un tableau croisé dynamique qui présente les revenus moyens en fonction des décisions d'achat (Oui ou Non) et du sexe (Femme ou Homme). Les revenus moyens sont plus élevés pour les hommes que pour les femmes, que ce soit pour ceux qui ont pris la décision d'achat (Oui) ou non (Non). En moyenne, les revenus sont également plus élevés pour ceux qui ont pris la décision d'achat (Oui) par rapport à ceux qui ne l'ont pas prise (Non). Le tableau met en évidence des disparités de revenus basées sur le sexe et les décisions d'achat.

 ### 2. Analyse des Achats en Fonction des Distances Parcourues

 ![TCD](count_purchased_bike.png)


    Le tableau montre les résultats des décisions d'achat(positives ou négatives) en fonction des distances parcourues. Les résultats indiquent que les distances comprises entre 0-1 miles et 2-5 miles ont les taux d'achat les plus élevés.

 ### 3. Analyse des Achats de Vélos par Groupe d'Âge

 ![TCD](count_purchased_bike_1.png)

   Le tableau ci-dessous montre les résultats des décisions d'achat(positives ou négatives) de vélos en fonction des groupes d'âge (Jeune, Âge moyen, Âgé).Les résultats indiquent que les personnes d'âge moyen ont les taux d'achat les plus élevés, suivies par les les personnes âgées et sles jeunes.

 ## III. Tableau de bord 

 - Tableau de bord

 ![TCD](bike_dashbord.png)

 ce tableau de bord nous montre des graphiques qui confirment nos analyses sur les tableaux croisés dynamiques et nous offre des option de filtre sur le statut marital, la région et l'éducation des clients