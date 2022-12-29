#####
SEDA - Version 1.0 | Standard d'Echange de Données pour l'Archivage
#####



Vous cherchez `une autre version du SEDA <../main/README.rst#3historique-des-versions>`_ ?






.. section-numbering::

-------------------------------------------------------------

.. contents::



-------------------------------------------------------------



Les caractéristiques du SEDA v1.0
===================================

Introduction au SEDA
---------------

Consulter `la page d'accueil
<../../tree/main/>`_



Genèse du SEDA 1.0
---------------

**La version 1.0** du Standard d'échanges de données pour l'archivage (SEDA) -publiée en **septembre 2012** sous l'égide du Service interministériel des Archives de France- comprend 35 schémas et une description du standard.



Note de version (changelog)
---------------

Les changements **par rapport à la version 0.2** sont répertoriés dans le chapitre 1.5.2 de `la documentation générale </doc/seda-1.0-description_standard.pdf>`_.



Schémas XML
===================================
`Les schémas </schema/>`_ traduisent la forme des messages échangés au cours des transactions.



Documentation
===================================


Documentation générale
---------------

* `SEDA 1.0 | Description du standard </doc/seda-1.0-description_standard.pdf>`_


Documentation technique
---------------

* `SEDA 1.0 | Documentation HTML des schémas XML </doc/seda-1.0-XML-schema_documentation_HTML.zip>`_ ``[ZIP à télécharger]``
* `Consulter la documentation en ligne <https://francearchives.fr/seda/1.0/>`_ ``[Bientôt]``



Outils
===================================

Outils spécifiques à la version 1.0
---------------

Transformation
~~~~~~~~~~~~~~~~~~~~~~~~~~~

`SEDA 1.0 vers EAD2 </outils/transformation/SEDA_1.0_vers_EAD2/>`_

Transforme l'archive contenue dans un message de transfert ou de communication en un instrument de recherche en EAD. Le tableau de correspondances est proposé en annexes (seda1.0ToEad.pdf). 

`SEDA 1.0 vers HTML </outils/transformation/SEDA_1.0_vers_HTML/>`_

Transforme un message au format du SEDA (version 1.0) en une page web en HTML lisible par un utilisateur.



Validation
~~~~~~~~~~~~~~~~~~~~~~~~~~~

`Validation par un schematron </outils/validation/schematron_SEDA_1.0/>`_

Certaines règles de conformité au standard d'échange, qui ne pouvaient pas être exprimées par des schémas XML, nous ont conduit à l'écriture d'un schematron. La validation d'un message de transfert par un ou plusieurs schematrons peut être effectuée par l'application de feuilles de styles XSLT que vous trouverez sur `schematron.com <http://www.schematron.com>`_.

seda_v10.sch est un schematron qui permet de compléter la validation d'un transfert avec les schémas XML par des règles procédurales hors de portée de la technologie XML-Schema. Les règles de ce schematron portent sur les dates extrêmes et les niveaux de description. 

`SEDA ANT </outils/validation/seda_ant.zip/>`_

Pour faciliter la compréhension par les éditeurs ainsi que pour des services d'archives qui seraient complètement dépourvu d'outils de validation XML, nous mettons à disposition une application développée avec ant de la fondation Apache. Cette application "seda_ant.zip" en "ligne de commande" permet de faire de la validation XML (les schémas XML de la version 1.0 sont inclus dans l'application), de la validation de schematron (celui donné en exemple dans cette page est inclus dans l'application), de faire de la validation de schémas au format relaxng (comme les schémas de profils que produit l'application Agape) enfin de faire des transformations XSLT.

`SEDA Toolkit </outils/validation/seda_toolkit.zip/>`_

Un autre exemple de code java (corrigé et mis à jour pour la version 1.0 du SEDA) est donné par l'application "seda_toolkit.zip". Cette application permet de déclencher des contrôles de validité sur des fichiers XML (messages de au format du SEDA version 1.0). Il s'agit d'une application en mode "console", c'est-à-dire que l'interface graphique est réduite au minimum, à savoir un menu pour choisir le fichier XML sur lequel on souhaite faire porter les actions et un menu pour déclencher les actions. Le résultat des actions est directement écrit dans la fenêtre principale. Les actions peuvent porter sur la bonne formation XML du document, sa conformité aux schémas du SEDA, sa conformité à un schéma de profil, sa conformité à un schematron. Des actions ont été ajoutées pour contrôler la présence des pièces jointes et leurs empreintes (formats SHA-1, SHA-256 et SHA-512). Enfin une action permet d'appliquer une feuille de style xslt au document. Cette application n'est pas un produit fini mais juste un prototype dont on peut regarder le code et qu'on peut utiliser évidemment sans garantie.


Outils génériques
---------------

`Une palette d'outils <../../tree/outils/>`_ facilite le traitement de vos archives avec SEDA !


Téléchargement
===================================

`Télécharger l'ensemble du SEDA 1.0 <../../releases/tag/seda_v1.0/>`_ (schémas XML et documentation)


