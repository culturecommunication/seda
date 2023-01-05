#####
SEDA | Standard d'Echange de Données pour l'Archivage
#####



``Le standard d’échange de données pour l’archivage (SEDA) 
vise à faciliter l’interopérabilité 
entre le système d’information d’un service d’archives
et les systèmes d’information de ses partenaires 
dans le cadre de leurs échanges de données.``




.. section-numbering::
   
 
-------------------------------------------------------------

.. contents::


-------------------------------------------------------------



Introduction au SEDA
===================================
Qu'est-ce que le SEDA ?
---------------
Issu d’une collaboration lancée dès 2006 entre les Archives de France et l’ancienne Direction générale de la modernisation de l’État (DGME), le **standard d’échange de données pour l’archivage** (SEDA) vise à faciliter l’interopérabilité entre le système d’information d’un service d’archives et les systèmes d’information de ses partenaires dans le cadre de leurs échanges de données.

Le standard permet de modéliser les *transactions* entre différents *acteurs* dans le cadre de l’archivage. Il précise les types, l’ordre et la forme des *messages* échangés, définissant quelles métadonnées utiliser pour décrire, gérer et pérenniser l’information.

Le standard, qui est autant archivistique que technique, s’inspire de normes existantes et des habitudes archivistiques utilisées dans les procédures papier. Si la description archivistique à plusieurs niveaux du SEDA est issue des normes ISAD-G / EAD, son modèle organisationnel adopte celui de la norme ISO 14721 (OAIS) et la préservation des informations techniques qu’il transporte emprunte les définitions au modèle PREMIS. Le SEDA est techniquement structuré en XML.

Les principes du SEDA reprennent largement les concepts métier tels que l’usage des bordereaux *(versement, élimination)*, l’application du contrôle scientifique et technique *(transaction de demande d’autorisation)*, la définition des acteurs ou l’apposition de règles de gestion *(sorts finaux et communicabilité)*.


Transactions et acteurs
---------------
Le **standard d'échange de données pour l'archivage** modélise les différentes **transactions** qui peuvent avoir lieu entre des **acteurs** dans le cadre de l'archivage de données. Le SEDA modélise 7 transactions qui peuvent avoir lieu entre des acteurs dans le cadre de l'archivage de données :

#. Le transfert,

#. La demande de transfert, 

#. L'élimination,

#. La communication,

#. La demande d’autorisation,

#. La modification,

#. La restitution.


Ces transactions se déroulent entre les six acteurs suivants : 

#. Le service producteur, 

#. Le service versant,

#. Le service d'archives,

#. Le service de contrôle,

#. Le demandeur d'archives,

#. L'opérateur de versement (*depuis la v2.0*).



Formalisme
---------------

Le SEDA définit :

* Les ``transactions``, formalisées par des **scénarios** *(diagrammes de séquences en UML)* dans lesquels les acteurs s'échangent des messages ; 

* La forme des ``messages`` échangés au cours de ces transactions par des **schémas XML**.



Du standard aux normes
===================================

MEDONA
---------------

En 2012, le Service interministériel des Archives de France a engagé auprès de l’AFNOR une démarche de normalisation du SEDA à partir de la version 1.0. Cette démarche normative était souhaitée tant par les services d’archives publics que les prestataires de tiers-archivage que par d’autres communautés (banques, éditeurs de coffres-forts numériques). Les travaux de normalisation ont abouti à la publication en janvier 2014 de la **norme NF Z 44-022** *« Modélisation des Échanges de DONnées pour l’Archivage »* ou **MEDONA**. La version 2.0 du SEDA a permis de le rendre compatible à la norme MEDONA en décembre 2015.

`La norme NF Z 44-022 | MEDONA <https://www.boutique.afnor.org/fr-fr/norme/nf-z44022/medona-modelisation-des-echanges-de-donnees-pour-larchivage/fa179927/1417>`_


DEPIP
---------------
Le processus de normalisation s’est poursuivi avec le portage de la **norme MEDONA** auprès de l’Organisation internationale de normalisation (ISO), afin de lui conférer une portée internationale. Cette initiative avait aussi pour objectif d’élargir le domaine d’application des archives à toute entité chargée d’assurer à terme la pérennisation d’objets numériques (musées, bibliothèques) et au secteur privé (retrait des spécificités du secteur public). La **norme ISO 20614** *« Protocole d’échange de données pour l’interopérabilité et la préservation »* (dite **DEPIP** pour *Data exchange protocol for interoperability et preservation*) a été publiée en novembre 2017.

`La norme ISO 20614 | DEPIP <https://www.boutique.afnor.org/fr-fr/norme/nf-iso-20614/information-et-documentation-protocole-dechange-de-donnees-pour-linteropera/fa187971/1716>`_ 


Historique des versions
===================================



* `SEDA v2.2 <../../tree/seda-2.2/>`_ (Janvier 2022) ``Version actuelle``

* `SEDA v2.1 <../../tree/seda-2.1/>`_ (Juin 2018)

* `SEDA v2.0 <../../tree/seda-2.0/>`_ (Décembre 2015)

* `SEDA v1.0 <../../tree/seda-1.0/>`_ (Septembre 2012)

* `SEDA v0.2 <../../tree/seda-0.2/>`_ (Janvier 2010)

* `SEDA v0.1 <../../tree/seda-0.1/>`_ (Mars 2006)



Outils
===================================

`Une palette d'outils <../../tree/outils/>`_ facilite le traitement de vos archives avec le SEDA !



En savoir plus
===================================

* `La page SEDA de FranceArchives <https://francearchives.fr/fr/article/88482501>`_

* Claire Sibille-de Grimoüard, Baptiste Nichèle, `Le Standard d'échange de données pour l'archivage (SEDA), un outil structurant pour l'archivage. <https://www.persee.fr/doc/gazar_0016-5522_2015_num_240_4_5291>`_ In : La Gazette des archives, n°240, 2015-4, pp. 153-164.

* Claire Sibille-de Grimoüard, `D'un standard national d'échange de données pour l'archivage à un projet de norme ISO <https://siaf.hypotheses.org/806>`_, publié le 6 avril 2018 sur le carnet Modernisation et archives des Archives de France.




Organisation du dépôt Github SEDA
===================================
Le dépôt Github SEDA est organisé en ``branches`` :

* La branche ``MAIN`` constitue la *page d'accueil* du dépôt.
* La branche ``OUTILS`` propose une introduction aux principales applications tierces.
* Chaque ``version du SEDA`` dispose ensuite de sa propre branche : ``seda-0.2`` (...) ``seda-2.2``.

Pour naviguer d'une branche à l'autre, suivez simplement les liens proposés dans les pages... ou sélectionnez directement une branche grâce au bouton ``main`` situé en haut à gauche de la page :

.. image:: /img/Github_SEDA_Branches.jpg




Contact
===================================

Pour toute question, n'hésitez pas à contacter le *Bureau de l'expertise numérique et de la conservation durable* du **Service interministériel des Archives de France** : ``archivage.numerique.siaf@culture.gouv.fr``


