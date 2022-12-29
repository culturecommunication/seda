#####
SEDA - Version 0.2 | Standard d'Echange de Données pour l'Archivage
#####



Vous cherchez `une autre version du SEDA <../main/README.rst#3historique-des-versions>`_ ?






.. section-numbering::

-------------------------------------------------------------

.. contents::



-------------------------------------------------------------



Les caractéristiques du SEDA v0.2
===================================

Introduction au SEDA
---------------

Consulter `la page d'accueil
<../../tree/main/>`_



Genèse du SEDA 0.2
---------------

**La version 0.2** du Standard d'échanges de données pour l'archivage (SEDA) -publiée en **janvier 2010** sous l'égide du Service interministériel des Archives de France- comprend 18 schémas et une description du standard.



Note de version (changelog)
---------------
Les changements **par rapport à la version 0.1** sont exposés dans `la circulaire DGP_SIAF_2010_002 </doc/DGP_SIAF_2010_002.pdf>`_ du 15/02/2010.

Consulter la circulaire DGP_SIAF_2010_002 `sur le portail FranceArchives <https://francearchives.fr/fr/circulaire/DGP_SIAF_2010_002>`_.





Schémas XML
===================================
`Les schémas </schema/>`_ traduisent la forme des messages échangés au cours des transactions.



Documentation
===================================


Documentation générale
---------------

* `SEDA 0.2 | Description du standard </doc/seda-0.2-description_standard__v1-2_revision1.pdf>`_



Outils
===================================

Outils spécifiques à la version 0.2
---------------

Transformation
~~~~~~~~~~~~~~~~~~~~~~~~~~~

`SEDA 0.2 vers EAD2 </outils/transformation/SEDA_0.2_vers_EAD2/>`_

Transforme l'archive contenue dans un message de transfert ou de communication en un instrument de recherche en EAD. Le tableau de correspondances est proposé en annexes (seda2ead.pdf). 

`SEDA 0.2 vers HTML </outils/transformation/SEDA_0.2_vers_HTML/>`_

Transforme un message au format du SEDA (version 0.2) en une page web en HTML lisible par un utilisateur.


`SEDA 0.2 vers SEDA 1.0 </outils/transformation/SEDA_0.2_vers_SEDA_1.0/>`_

transferts_v02tov10.xsl transforme un message SEDA de transfert de la version 0.2 vers la version 1.0.


`SEDA 0.2 vers SEDA 2.0 </outils/transformation/SEDA_0.2_vers_SEDA_2.0/>`_

transferts_v02tov20 transforme un message SEDA de transfert de la version 0.2 vers la version 2.0.


`Profil Agape SEDA 0.2 vers SEDA 1.0  </outils/transformation/Profil_Agape_SEDA_0.2_vers_SEDA_1.0/>`_

profils_v02to10.xsl transforme un profil fait avec le logiciel Agape de la version 0.2 à la version 1.0 du SEDA.





Validation
~~~~~~~~~~~~~~~~~~~~~~~~~~~

`Validation par un schematron </outils/validation/schematron_SEDA_0.2/>`_

Certaines règles de conformité au standard d'échange, qui ne pouvaient pas être exprimées par des schémas XML, nous ont conduit à l'écriture d'un schematron. La validation d'un message de transfert par un ou plusieurs schematrons peut être effectuée par l'application de feuilles de styles XSLT que vous trouverez sur `schematron.com <http://www.schematron.com>`_.

seda_v02.sch est un schematron qui permet de compléter la validation d'un transfert avec les schémas XML par des règles procédurales hors de portée de la technologie XML-Schema. Les règles de ce schematron portent sur les dates extrêmes et les niveaux de description. 




Outils génériques
---------------

`Une palette d'outils <../../tree/outils/>`_ facilite le traitement de vos archives avec SEDA !



Téléchargement
===================================

`Télécharger l'ensemble du SEDA 0.2 <../../releases/tag/seda_v0.2/>`_ (schémas XML et documentation)


