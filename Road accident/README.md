# Road Accident - Excel

## Dataset Source
[Road Accident](https://www.youtube.com/redirect?event=video_description&redir_token=QUFFLUhqbG40QXp5WmJsOWVwblNKelhjMjM4RF9mdEt1QXxBQ3Jtc0tsTnNNcDNIcWhZLVJHbGc5OU55akF5WFNacnhGMVVqVUZobXYtcVo1WURCRU9jcTllQ2UzTjVsa20yWEtkZWprVl9XeWdqaXpEX2l6cGt0ZHVsdjVvNTZ4OFhKdHZibFEwZld3a1d1REtJa3dOcVlFUQ&q=https%3A%2F%2Fdocs.google.com%2Fspreadsheets%2Fd%2F1R_uaoZL18nRbqC_MULVne90h3SdRbAyn%2Fedit%3Fusp%3Dsharing%26ouid%3D116890999875311477003%26rtpof%3Dtrue%26sd%3Dtrue&v=XeWfLNe3moM)


## Objectif
Nous analysons les accidents de la route pour identifier les facteurs influençant leur occurrence, tels que les conditions météorologiques, l'état des infrastructures et les caractéristiques des véhicules.

---
## I.  Netoyage des données 

### 1. Suppression des Doublons
Supprimmer les enregistrements doubles
### 2. Transformation de colonne
 - Remplacer les éléments M et F de la colonne Gender respectivement en Male et Female
 - Remplacer les éléments 10+ de la colonne Commute en More than 10
 - Ajout de la colonne Age Bracket pour catégoriser les clients en fonction de leur Age 'Young' pour les clients de moins de 31 ans, 'Middle Age' pour les clients de plus de 31 ans et de moins de 51 ans et enfin 'Old' pour les plus de 51 ans
 ### 3. Apperçu du Jeu de données néttoyé

![data sheet](bike_data_sheet.png)
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