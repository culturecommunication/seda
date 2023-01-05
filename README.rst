#####
SEDA - Version 2.2 | Standard d'Echange de Données pour l'Archivage
#####



Vous cherchez `une autre version du SEDA <../main/README.rst#3historique-des-versions>`_ ?






.. section-numbering::

-------------------------------------------------------------

.. contents::



-------------------------------------------------------------



Les caractéristiques du SEDA v2.2
===================================

Introduction au SEDA
---------------

Consulter `la page d'accueil
<../../tree/main/>`_


Consulter `la page de présentation du SEDA 2.0
<../../tree/seda-2.0/>`_


Consulter `la page de présentation du SEDA 2.1
<../../tree/seda-2.1/>`_


Genèse du SEDA 2.2
---------------

**La version 2.2** du Standard d'échanges de données pour l'archivage (SEDA) -publiée en **janvier 2022** sous l'égide du Service interministériel des Archives de France- comprend six schémas et un dictionnaire. Une mise à jour mineure a été publiée en **décembre 2022** pour actualiser la balise ``TextContent`` (voir plus loin).

Les schémas sont le fruit du travail mené en 2020-2021 par le Comité de pilotage du SEDA, qui rassemble des acteurs œuvrant pour l’utilisation de ce standard d'échange dans les services publics d’archives, chez les tiers-archiveurs, les éditeurs de logiciels d’archivage électronique ou encore les cabinets spécialisés dans l'accompagnement de projets d'archivage électronique.

Les comités de pilotage du SEDA se sont interrompus en 2018 après la publication de la version 2.1, qui correspondait à une mise à jour significative de la deuxième génération du standard. En 2019, les utilisations opérationnelles du SEDA ont fait émerger des points d’amélioration à cette version 2.1. La reprise des travaux en 2020 avait donc pour objet de faire évoluer le standard, pour répondre aux besoins exprimés par l'ensemble des membres du comité de pilotage lors de la séance du 7 janvier 2020.

Les travaux menés collectivement en 2020-2021 ont abouti à la publication de la version 2.2 en janvier 2022. Ils ont permis de traiter les besoins prioritaires en matière d’évolution de balises, tout en gardant intacte l’économie générale de la version précédente 2.1. 

En 2023, les travaux du comité de pilotage s’attacheront notamment à compléter la documentation et les informations sur cette dernière version, et à mener des études prospectives.


Note de version (changelog)
---------------
Les principaux changements **par rapport à la version 2.1** sont:

* Modification de ``AgentType`` générique dans l’ontologie ;
* Dépréciation de ``AgentAbstract`` ; 
* Ajout d'une nouvelle règle de gestion ``HoldRule`` dans les métadonnées de gestion ;
* Ajout de ``HoldRuleCodeListVersion`` ;
* Ajout de ``OriginatingSystemIdReplyToGroup`` et de ``TextContent`` (pour les courriels) ;
* Ajout de ``LinkingAgentIdentifierType`` dans les ``Event`` ;
* Ajout de ``DataObjectProfile`` dans les métadonnées techniques ;
* Ajout de ``DateLitteral`` dans l’ontologie ;
* Modification du type de ``MessageIdentifier`` (devient ``NonEmptyToken``).

|
| **Attention**
| La balise ``TextContent`` a fait l'objet d'une modification mineure en **décembre 2022** *(postérieure à la publication initiale des schémas en janvier 2022)*. Sa cardinalité a été modifiée afin de rendre la balise répétable.
| 

Schémas XML
===================================
`Les schémas </schema/>`_ traduisent la forme des messages échangés au cours des transactions.
Ils ont été réalisés par le Cabinet Mintika à partir des principes définis en Comité de pilotage.


Documentation
===================================


Documentation générale
---------------

* SEDA 2.2 | Description du standard ``[à paraître en 2023]``

* `SEDA 2.2 | Dictionnaire des balises </doc/seda-2.2-dictionnaire_[DocumentDeTravail-2022-01-31].pdf>`_

Le **document de description du standard** sera publiée en 2023. Le **dictionnaire des balises SEDA** est proposé dans une version de travail. Il synthétise par grands ensembles de métadonnées (gestion, description, technique, transport et typologie de messages) les éléments présents dans les schémas du standard. 

Documentation technique
---------------

* `SEDA 2.2 | Documentation HTML des schémas XML </doc/seda-2.2-XML-schema_documentation_HTML.zip>`_ ``[ZIP à télécharger]``
* `SEDA 2.2 | Diagrammes SVG des schémas XML </doc/seda-2.2-XML-schema_documentation_SVG.zip>`_  ``[ZIP à télécharger]``
* `Consulter la documentation en ligne <https://francearchives.fr/seda/2.2/>`_ ``[Bientôt]``



Comparaison entre SEDA 2.2, SEDA 2.1 et SEDA 2.0
===================================

`Différences entre les versions 2.1 et 2.0
<../../tree/seda-2.1/#note-de-version-changelog>`_

`Différences entre les versions 2.2 et 2.1
<#note-de-version-changelog>`_



Outils
===================================

Outils spécifiques à la version 2.2
---------------

``[Bientôt]``


Outils génériques
---------------

`Une palette d'outils <../../tree/outils/>`_ facilite le traitement de vos archives avec le SEDA !



Téléchargement
===================================

`Télécharger l'ensemble du SEDA 2.2 <../../releases/tag/seda_v2.2/>`_ (schémas XML et documentation)


