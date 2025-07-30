A LIRE EN ENTIER AVANT DE COMMENCER :)

Juillet 2024 : Reprise du travail effectué par Nathan Viltard fin 2020

1.Création d'une base contenant les résultats des élections présidentielles de 1981 à 2022 au niveau des communes, au format "wide" (en largeur = 1 ligne par commune)

2.Création d'une base contenant les résultats des élections législatives sur cette période (pas les mêmes années exactement) au niveau des communes, au format "wide" (en largeur = 1 ligne par commune)

3.Création d'une base contenant les résultats des élections municipales sur cette période (pas les mêmes années exactement) au niveau des communes, au format "wide" (en largeur = 1 ligne par commune)

-----------------------

To do : 

------------------------------------

1. Prendre connaissance, sans forcément entrer dans les détails à ce stade, de ce qui a été fait par Nathan. Notamment pour savoir où chercher les infos par la suite.

- regarder le doc "notes_donnees_elections" qui donne quelques infos

- Regarder les bases déjà crées par Nathan dans le fichier "output". Est-ce qu'il manque certaines années ? (NB: Certaines communes ont des points manquant, il s'agit des communes de moins de 9000 ou 3500 habitants selon les années.)
Il manque probablement les années récentes.

- Tu peux regarder les do-files associés, mais ils sont peut-être incomplets (notamment le "12_data_elections_munic_Nathan_20201008" ne génère pas de fichier .dta en sortie je pense).

- Note qu'il n'y a pas de fichiers en input, mais si besoin de les re-télécharger pour refaire tourner des codes, les liens vers les fichiers à télécharger sont dans "Source de données_Nathan_20200913.txt"

------------------------------------------

2. Entre temps, Cagé et Piketty ont fait cet énorme travail. Autant s'en servir :

- télécharger les bases Cagé-Piketty (CP) sur le site de leur livre (n'oublie pas de mettre l'url dans le document "Source de données_Nathan_20200913.txt" que tu pourras ensuite sauvegarder avec ton nom et la date par exemple).

- A-t-on toutes les élections depuis les présidentielles de 1981 ? 
- Les bases sont-elles au format wide ?
- En regardant les do-files de Nathan pour les présidentielles, est-ce que la classification des candidats diffère de celle de CP ?

=> Note bien toutes tes observations dans un document (j'en ai crée un : Notes_FOLAN.doc). Observations, questions, remarques, problèmes rencontrés… A tout moment du process.

- Si leurs bases ne sont pas en "wide", un premier travail sera de les mettre dans ce format (tu peux t'aider des do-files de Nathan je pense). Dans ce cas, pense à mettre un suffixe "_cp" aux variables des partis (par exemple, si une variable s'appelle "extreme_droite", renomme la "extreme_droite_cp". Ainsi, si on veut fusionner leurs bases avec celles qu'on avait auparavant, on saura tout de suite de quelle classification il s'agit.

- Est-ce qu'un taux d'abstention est calculé dans ces bases ? Si non, le calculer (vérifier la définition, mais ça doit être (nb votants - nb inscrits)/ (nb inscrits). 

Je me répète, mais note bien tout ce que tu fais dans le doc "Notes_FOLAN", ça me permettra de suivre et de m'y retrouver.

--------------------------------

3. Entre le travail déjà effectué par Nathan et celui de CP, que manque-t-il ? certaines années ? certains tours (1er tour) ? certaines élections (municipales) ? 

-> est-ce que tu arrives à trouver l'info (année, élection...) manquante en ligne (data gouv) ?
-> si oui, compléter les bases existantes avec les infos manquantes


--------------------------------

A mon avis, avec tout ça, tu tiens un petit moment. Envoie-moi un WhatsApp si tu termines avant tes vacances, on fera un point.

Un immense merci ! 










