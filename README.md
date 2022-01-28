# Standard d'échange de données pour l'archivage (SEDA)
Schémas de la version 2.2 publiée en janvier 2022 sous l'égide du Service interministériel des Archives de France.
Le SEDA modélise 6 transactions qui peuvent avoir lieu entre des acteurs dans le cadre de l'archivage de données :
le transfert, la demande de transfert, la modification, l'élimination, la communication et la restitution.
Les présents schémas traduisent formellement la forme des messages échangés au cours des transactions.
Les principaux changements par rapport à la version 2.1 publiée en juin 2018 sur https://francearchives.fr/seda/
sont :
- Modification de AgentType générique dans l’ontologie;
- Ajout de HoldRule dans les métadonnées de gestion;
- Ajout de OriginatingSystemIdReplyToGroup et de TextContent (pour les mails);
- Ajout de LinkingAgentIdentifierType dans les Event;
- Ajout de DataObjectProfile dans les métadonnées techniques;
- Ajout de DateLitteral dans l’ontologie.
