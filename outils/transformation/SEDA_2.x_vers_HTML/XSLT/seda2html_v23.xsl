<?xml version="1.0" encoding="ISO-8859-1" ?>
<!-- ======================================================== -->
<!-- =====                                              ===== -->
<!--               XSLT SEDA 2.3 HTML SIAF                    -->
<!--               		2024                   			-->
<!-- =====                                              ===== -->
<!-- ======================================================== -->

<xsl:stylesheet version="2.0" xmlns:seda="fr:gouv:culture:archivesdefrance:seda:v2.3" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:ccts="urn:un:unece:uncefact:documentation:standard:CoreComponentsTechnicalSpecification:2" exclude-result-prefixes="seda xsl xsd ccts">
	<xsl:output indent="yes" media-type="text/html" encoding="UTF-8"/>
	
	<xsl:key name="BinaryData" match="seda:BinaryDataObject" use="@id"/>
	<xsl:key name="PhysicalData" match="seda:PhysicalDataObject" use="@id"/>
	<xsl:key name="DataGroup" match="seda:DataObjectGroup" use="@id"/>
	
	<xsl:key name="BinaryDataGroupId" match="seda:BinaryDataObject/seda:DataObjectGroupId" use="."/>
	<xsl:key name="PhysicalDataGroupId" match="seda:PhysicalDataObject/seda:DataObjectGroupId" use="."/>

	<xsl:template match="/">
		<html>
			<head>
				<link rel='stylesheet' href='codes/styles.css' type='text/css' media='all' />
				<script type="text/javascript" src="codes/toggle.js"></script>
				<title>Standard d'Echange de Données pour l'Archivage (SEDA)</title>
			</head>
			<body>
				<xsl:apply-templates />
			</body>
		</html>
	</xsl:template>
	
<!--
************************************
**** Les messages de Transfert
************************************
-->
	<xsl:template match="seda:ArchiveTransfer">
		<h2>
			Message de <xsl:call-template name="traduction"><xsl:with-param name="term" select="local-name()"/></xsl:call-template>
			<xsl:text> </xsl:text><xsl:apply-templates select="@*"/>
		</h2>
		<fieldset>
			<legend onclick="mytoggle('entete')">En-tête</legend>
			<div id="entete">
				<div class="info-generales">
					<xsl:apply-templates select="seda:Comment"/>
					<xsl:apply-templates select="seda:Date"/>
					<xsl:apply-templates select="seda:RelatedTransferReference"/>
					<xsl:apply-templates select="seda:MessageIdentifier"/>
					<xsl:apply-templates select="seda:TransferRequestReplyIdentifier"/>
					<xsl:apply-templates select="seda:DataObjectPackage/seda:ManagementMetadata/seda:AcquisitionInformation"/>
					<xsl:apply-templates select="seda:DataObjectPackage/seda:ManagementMetadata/seda:LegalStatus"/>
					<xsl:apply-templates select="seda:DataObjectPackage/seda:ManagementMetadata/seda:OriginatingAgencyIdentifier"/>
					<xsl:apply-templates select="seda:DataObjectPackage/seda:ManagementMetadata/seda:SubmissionAgencyIdentifier"/>
				</div>
				<div class="acteurs">
					<div class="acteur"><xsl:apply-templates select="seda:TransferringAgency"/></div>
					<div class="acteur"><xsl:apply-templates select="seda:ArchivalAgency"/></div>
				</div>
				<div class="gestionRules">
					<div class="gestion"><xsl:apply-templates select="seda:DataObjectPackage/seda:ManagementMetadata/seda:AccessRule"/></div>
					<div class="gestion"><xsl:apply-templates select="seda:DataObjectPackage/seda:ManagementMetadata/seda:AppraisalRule"/></div>
					<div class="gestion"><xsl:apply-templates select="seda:DataObjectPackage/seda:ManagementMetadata/seda:DisseminationRule"/></div>
					<div class="gestion"><xsl:apply-templates select="seda:DataObjectPackage/seda:ManagementMetadata/seda:ReuseRule"/></div>
					<div class="gestion"><xsl:apply-templates select="seda:DataObjectPackage/seda:ManagementMetadata/seda:StorageRule"/></div>
					<div class="gestion"><xsl:apply-templates select="seda:DataObjectPackage/seda:ManagementMetadata/seda:ClassificationRule"/></div>
					<div class="gestion"><xsl:apply-templates select="seda:DataObjectPackage/seda:ManagementMetadata/seda:HoldRule"/></div>
				</div>
			</div>
		</fieldset>
		<fieldset>
			<legend onclick="mytoggle('content')">Contenu</legend>
			<div id="content">
				<div id="commands">
					<span>
						<a href="javascript:expandAll(true)">tout ouvrir</a> | <a href="javascript:expandAll(false)">tout fermer</a>
					</span>
				</div>
				<xsl:apply-templates select="seda:DataObjectPackage/seda:DescriptiveMetadata/seda:ArchiveUnit"/>
			</div>
		</fieldset>
	</xsl:template>
	<xsl:template match="seda:ArchiveTransferReply">
		<h2>
			Message de <xsl:call-template name="traduction"><xsl:with-param name="term" select="local-name()"/></xsl:call-template>
			<xsl:text> </xsl:text><xsl:apply-templates select="@*"/>
		</h2>
		<fieldset>
			<legend onclick="mytoggle('entete')">En-tête</legend>
			<div id="entete">
				<div class="info-generales">
					<xsl:apply-templates select="seda:Comment"/>
					<xsl:apply-templates select="seda:Date"/>
					<xsl:apply-templates select="seda:GrantDate"/>
					<xsl:apply-templates select="seda:ReplyCode"/>
					<xsl:apply-templates select="seda:MessageIdentifier"/>
					<xsl:apply-templates select="seda:TransferReplyIdentifier"/>
				</div>
				<div class="acteurs">
					<div class="acteur"><xsl:apply-templates select="seda:TransferringAgency"/></div>
					<div class="acteur"><xsl:apply-templates select="seda:ArchivalAgency"/></div>
				</div>
			</div>
		</fieldset>
	</xsl:template>
<!--
************************************
**** Le message d'accusé réception
************************************
-->
	<xsl:template match="seda:Acknowledgement">
		<h2>
			Message de <xsl:call-template name="traduction"><xsl:with-param name="term" select="local-name()"/></xsl:call-template>
			<xsl:text> </xsl:text><xsl:apply-templates select="@*"/>
		</h2>
		<fieldset>
			<legend onclick="mytoggle('entete')">En-tête</legend>
			<div id="entete">
				<div class="info-generales">
					<xsl:apply-templates select="seda:Comment"/>
					<xsl:apply-templates select="seda:Date"/>
					<xsl:apply-templates select="seda:AcknowledgementIdentifier"/>
					<xsl:apply-templates select="seda:MessageReceivedIdentifier"/>
				</div>
				<div class="acteurs">
					<div class="acteur"><xsl:apply-templates select="seda:Receiver"/></div>
					<div class="acteur"><xsl:apply-templates select="seda:Sender"/></div>
				</div>
			</div>
		</fieldset>
	</xsl:template>
<!--
************************************
**** Les messages de Communication
************************************
-->
	<xsl:template match="seda:ArchiveDeliveryRequest">
		<h2>
			Message de <xsl:call-template name="traduction"><xsl:with-param name="term" select="local-name()"/></xsl:call-template>
			<xsl:text> </xsl:text><xsl:apply-templates select="@*"/>
		</h2>
		<fieldset>
			<legend onclick="mytoggle('entete')">En-tête</legend>
			<div id="entete">
				<div class="info-generales">
					<xsl:apply-templates select="seda:Comment"/>
					<xsl:apply-templates select="seda:Date"/>
					<xsl:apply-templates select="seda:DeliveryRequestIdentifier"/>
					<xsl:apply-templates select="seda:Derogation"/>
					<xsl:apply-templates select="seda:UnitIdentifier"/>
				</div>
				<div class="acteurs">
					<div class="acteur"><xsl:apply-templates select="seda:Requester"/></div>
					<div class="acteur"><xsl:apply-templates select="seda:ArchivalAgency"/></div>
				</div>
			</div>
		</fieldset>
	</xsl:template>
	<xsl:template match="seda:ArchiveDeliveryRequestReply">
		<h2>
			Message de <xsl:call-template name="traduction"><xsl:with-param name="term" select="local-name()"/></xsl:call-template>
			<xsl:text> </xsl:text><xsl:apply-templates select="@*"/>
		</h2>
		<fieldset>
			<legend onclick="mytoggle('entete')">En-tête</legend>
			<div id="entete">
				<div class="info-generales">
					<xsl:apply-templates select="seda:Comment"/>
					<xsl:apply-templates select="seda:Date"/>
					<xsl:apply-templates select="seda:AuthorizationRequestReplyIdentifier"/>
					<xsl:apply-templates select="seda:DeliveryRequestIdentifier"/>
					<xsl:apply-templates select="seda:DeliveryRequestReplyIdentifier"/>
					<xsl:apply-templates select="seda:ReplyCode"/>
					<xsl:apply-templates select="seda:UnitIdentifier"/>
				</div>
				<div class="acteurs">
					<div class="acteur"><xsl:apply-templates select="seda:Requester"/></div>
					<div class="acteur"><xsl:apply-templates select="seda:ArchivalAgency"/></div>
				</div>
			</div>
		</fieldset>
		<fieldset>
			<legend onclick="mytoggle('content')">Contenu</legend>
			<div id="content">
				<div id="commands">
					<span>
						<a href="javascript:expandAll(true)">tout ouvrir</a> | <a href="javascript:expandAll(false)">tout fermer</a>
					</span>
				</div>
				<xsl:apply-templates select="seda:ArchiveUnit"/>
			</div>
		</fieldset>
	</xsl:template>

<!-- ArchiveUnit racine -->
	<xsl:template match="seda:DataObjectPackage/seda:DescriptiveMetadata/seda:ArchiveUnit">
		<div>
			<p class="Archive-name">
				<xsl:call-template name="name">
					<xsl:with-param name="nom" select="seda:Content/seda:Title"/>
				</xsl:call-template>
			</p>
			<div>
				<xsl:apply-templates select="@*"/>
				<xsl:if test="seda:Management/seda:AppraisalRule|seda:Management/seda:AccessRule|seda:Management/seda:DisseminationRule|seda:Management/seda:ReuseRule|seda:Management/seda:StorageRule|seda:Management/seda:ClassificationRule|seda:Management/seda:HoldRule">
					<div class="Management">
						<xsl:apply-templates select="seda:Management/seda:AppraisalRule"/>
						<xsl:apply-templates select="seda:Management/seda:AccessRule"/>
						<xsl:apply-templates select="seda:Management/seda:DisseminationRule"/>
						<xsl:apply-templates select="seda:Management/seda:ReuseRule"/>
						<xsl:apply-templates select="seda:Management/seda:StorageRule"/>
						<xsl:apply-templates select="seda:Management/seda:ClassificationRule"/>
						<xsl:apply-templates select="seda:Management/seda:HoldRule"/>
					</div>
				</xsl:if>
				<xsl:apply-templates select="seda:Content"/>
				<xsl:if test="seda:ArchiveUnit">
					<ul>
						<xsl:for-each select="seda:ArchiveUnit">
							<li class="expandable" onclick="toggle(event, this)">
								<xsl:apply-templates select="."/>
							</li>
						</xsl:for-each>
					</ul>
				</xsl:if>
				<xsl:if test="seda:DataObjectReference">
					<ul>
						<xsl:for-each select="seda:DataObjectReference">
							<li class="expandable" onclick="toggle(event, this)">
								<xsl:apply-templates select="."/>
							</li>
						</xsl:for-each>
					</ul>
				</xsl:if>
			</div>
		</div>
	</xsl:template>	

<!-- ArchiveUnit filles -->	
	<xsl:template  match="seda:ArchiveUnit">
		<p class="ArchiveUnit-name" onclick="toggle(event, this)">
			<xsl:call-template name="name">
				<xsl:with-param name="nom" select="seda:Content/seda:Title"/>
			</xsl:call-template>
		</p>
		<div class="ArchiveUnit" onclick="toggle(event, this)">
			<xsl:apply-templates select="@*"/>
			<xsl:if test="seda:Management/seda:AppraisalRule|seda:Management/seda:AccessRule|seda:Management/seda:DisseminationRule|seda:Management/seda:ReuseRule|seda:Management/seda:StorageRule|seda:Management/seda:ClassificationRule|seda:Management/seda:HoldRule">
				<div class="Management">
					<xsl:apply-templates select="seda:Management/seda:AppraisalRule"/>
					<xsl:apply-templates select="seda:Management/seda:AccessRule"/>
					<xsl:apply-templates select="seda:Management/seda:DisseminationRule"/>
					<xsl:apply-templates select="seda:Management/seda:ReuseRule"/>
					<xsl:apply-templates select="seda:Management/seda:StorageRule"/>
					<xsl:apply-templates select="seda:Management/seda:ClassificationRule"/>
					<xsl:apply-templates select="seda:Management/seda:HoldRule"/>
				</div>
			</xsl:if>
			<xsl:apply-templates select="seda:Content"/>
			<xsl:if test="seda:ArchiveUnit">
				<ul>
					<xsl:for-each select="seda:ArchiveUnit">
						<li class="expandable" onclick="toggle(event, this)">
							<xsl:apply-templates select="."/>
						</li>
					</xsl:for-each>
				</ul>
			</xsl:if>
			<xsl:if test="seda:DataObjectReference">
				<ul>
					<xsl:for-each select="seda:DataObjectReference">
						<li class="expandable" onclick="toggle(event, this)">
							<xsl:apply-templates select="."/>
						</li>
					</xsl:for-each>
				</ul>
			</xsl:if>
		</div>
	</xsl:template>
	
<!-- DataObjectReference -->
	<xsl:template match="seda:DataObjectReference">
		<p onclick="toggle(event, this)" class="Document-name">
			<xsl:if test="key('BinaryData', seda:DataObjectReferenceId)/seda:MessageDigest | key('DataGroup', seda:DataObjectGroupReferenceId)/seda:BinaryDataObject/seda:MessageDigest | key('BinaryDataGroupId', seda:DataObjectGroupReferenceId)/following::seda:MessageDigest">
				Objet de données numériques
			</xsl:if>
			<xsl:if test="key('PhysicalData', seda:DataObjectReferenceId)/seda:PhysicalId | key('PhysicalDataGroupId', seda:DataObjectGroupReferenceId)/following::seda:PhysicalId">
				Objet de données physiques
			</xsl:if>
		</p>
		<xsl:for-each select="key('DataGroup', seda:DataObjectGroupReferenceId)/seda:BinaryDataObject|key('BinaryDataGroupId', seda:DataObjectGroupReferenceId)|key('BinaryData', seda:DataObjectReferenceId)|key('PhysicalData', seda:DataObjectReferenceId) | key('PhysicalDataGroupId', seda:DataObjectGroupReferenceId)">
		<div class="Document" onclick="toggle(event, this)">
			<xsl:apply-templates select="@*"/>
			
			<xsl:apply-templates select="seda:FileName|following-sibling::seda:FileInfo/seda:Filename"/>
			<xsl:apply-templates select="seda:Uri|following-sibling::seda:Uri"/>
			<xsl:apply-templates select="seda:Attachment|following-sibling::seda:Attachment"/>
			<xsl:apply-templates select="seda:MessageDigest|following-sibling::seda:MessageDigest"/>
			<xsl:apply-templates select="seda:Size|following-sibling::seda:Size"/>
			<xsl:apply-templates select="seda:FormatIdentification/seda:FormatLitteral|following-sibling::seda:FormatIdentification/seda:FormatLitteral"/>
			<xsl:apply-templates select="seda:FormatIdentification/seda:MimeType|following-sibling::seda:FormatIdentification/seda:MimeType"/>
			<xsl:apply-templates select="seda:FormatIdentification/seda:FormatId|following-sibling::seda:FormatIdentification/seda:FormatId"/>
			<xsl:apply-templates select="seda:FileInfo/seda:LastModified|following-sibling::seda:FileInfo/seda:LastModified"/>
			<xsl:apply-templates select="seda:DataObjectProfile|following-sibling::seda:DataObjectProfile"/>
			<xsl:apply-templates select="seda:DataObjectVersion|following-sibling::seda:DataObjectVersion"/>
			<xsl:apply-templates select="seda:DataObjectNumber|following-sibling::seda:DataObjectNumber"/>
			<xsl:apply-templates select="seda:Compressed|following-sibling::seda:Compressed"/>
			<xsl:apply-templates select="seda:Encoding|following-sibling::seda:Encoding"/>
			<xsl:apply-templates select="seda:Metadata|following-sibling::seda:Metadata"/>
			<xsl:apply-templates select="seda:OtherMetadata|following-sibling::seda:OtherMetadata"/>
			<xsl:apply-templates select="seda:CreatingApplicationName|following-sibling::seda:CreatingApplicationName"/>
			<xsl:apply-templates select="seda:CreatingApplicationVersion|following-sibling::seda:CreatingApplicationVersion"/>
			<xsl:apply-templates select="seda:DateCreatedByApplication|following-sibling::seda:DateCreatedByApplication"/>
			<xsl:apply-templates select="seda:CreatingOs|following-sibling::seda:CreatingOs"/>
			<xsl:apply-templates select="seda:CreatingOsVersion|following-sibling::seda:CreatingOsVersion"/>
			<xsl:apply-templates select="seda:PhysicalId|following-sibling::seda:PhysicalId"/>
			<xsl:apply-templates select="seda:PhysicalDimensions|following-sibling::seda:PhysicalDimensions"/>
		</div>
		</xsl:for-each>
	</xsl:template>
	
<!-- Attachment -->
	<!-- on n'affiche pas le contenu qui peut être en base64Binary -->
	<xsl:template match="seda:Attachment">
		<div class="Attachment">
			<label><xsl:call-template name="traduction"><xsl:with-param name="term" select="local-name()"/></xsl:call-template>: </label>
			<xsl:apply-templates select="seda:Attachment/@filename"/>
		</div>
	</xsl:template>

<!-- Content description -->
	<xsl:template match="seda:Content">
		<div class="ContentDescription">
			<div class="collapsed-content">
				<!--<label><xsl:call-template name="traduction"><xsl:with-param name="term" select="local-name()"/></xsl:call-template>: </label>-->
				<xsl:apply-templates select="seda:OriginatingAgency"/>
				<xsl:apply-templates select="seda:SubmissionAgency"/>
				<xsl:apply-templates select="seda:OriginatingSystemId"/>
				<xsl:apply-templates select="seda:CustodialHistory"/>
				<xsl:apply-templates select="seda:Description"/>
				<xsl:apply-templates select="seda:DescriptionLanguage"/>
				<xsl:call-template name="dates_extremes"><xsl:with-param name="lang" select="'fr'"/></xsl:call-template>
				<xsl:apply-templates select="seda:DescriptionLevel"/>
				<xsl:apply-templates select="seda:FilePlanPosition"/>
				<xsl:apply-templates select="seda:RelatedObjectReference"/>
				<xsl:apply-templates select="seda:Keyword"/>
				<xsl:apply-templates select="seda:Tag"/>
				<xsl:apply-templates select="seda:Language"/>
				<xsl:apply-templates select="seda:ArchivalAgencyArchiveUnitIdentifier"/>
				<xsl:apply-templates select="seda:TransferringAgencyArchiveUnitIdentifier"/>
				<xsl:apply-templates select="seda:OriginatingAgencyArchiveUnitIdentifier"/>
				<xsl:apply-templates select="seda:DescriptionLanguage"/>
				<xsl:apply-templates select="seda:Agent"/>
				<xsl:apply-templates select="seda:AuthorizedAgent"/>
				<xsl:apply-templates select="seda:Writer"/>
				<xsl:apply-templates select="seda:Addressee"/>
				<xsl:apply-templates select="seda:Recipient"/>
				<xsl:apply-templates select="seda:Transmitter"/>
				<xsl:apply-templates select="seda:Sender"/>
				<xsl:apply-templates select="seda:Event"/>
				<xsl:apply-templates select="seda:Gps"/>
				<xsl:apply-templates select="seda:Source"/>
				<xsl:apply-templates select="seda:AcquiredDate"/>
				<xsl:apply-templates select="seda:ReceivedDate"/>
				<xsl:apply-templates select="seda:RegisteredDate"/>
				<xsl:apply-templates select="seda:TransactedDate"/>
				<xsl:apply-templates select="seda:CreatedDate"/>
				<xsl:apply-templates select="seda:SentDate"/>
				<xsl:apply-templates select="seda:Date"/>
				<xsl:apply-templates select="seda:Name"/>
				<xsl:apply-templates select="seda:Status"/>
				<xsl:apply-templates select="seda:Version"/>
				<xsl:apply-templates select="seda:Coverage"/>
				<xsl:apply-templates select="seda:Type"/>
				<xsl:apply-templates select="seda:DocumentType"/>
				<xsl:apply-templates select="seda:SigningInformation"/>
				<xsl:apply-templates select="seda:OriginatingSystemIdReplyToGroup"/>
				<xsl:apply-templates select="seda:TextContent"/>
				<xsl:apply-templates select="seda:PersistentIdentifier"/>
			</div>
		</div>
	</xsl:template>

<!-- Keyword -->
	<xsl:template match="seda:Keyword[1]">
		<div class="{local-name()}">
			<label><xsl:call-template name="traduction"><xsl:with-param name="term">Indexation</xsl:with-param></xsl:call-template>: </label>
			<xsl:apply-templates select="@*"/>
			<div class="code-value">
				<xsl:apply-templates select="seda:KeywordContent"/>
				<div class="code-value">
					<xsl:apply-templates select="seda:KeywordReference"/>
					<xsl:apply-templates select="seda:KeywordType"/>
					<xsl:apply-templates select="seda:AccessRestrictionRule"/>
				</div>
			</div>
		</div>
	</xsl:template>
	<xsl:template match="seda:Keyword">
		<div class="{local-name()}">
			<xsl:apply-templates select="@*"/>
			<div class="code-value">
				<xsl:apply-templates select="seda:KeywordContent"/>
				<div class="code-value">
					<xsl:apply-templates select="seda:KeywordReference"/>
					<xsl:apply-templates select="seda:KeywordType"/>
					<xsl:apply-templates select="seda:AccessRestrictionRule"/>
				</div>
			</div>
		</div>
	</xsl:template>
	
<!-- Regles -->
	<xsl:template match="seda:AccessRule|seda:AppraisalRule|seda:StorageRule|seda:ClassificationRule|seda:HoldRule|seda:ReuseRule|seda:DisseminationRule">
		<xsl:call-template name="RulesType"/>
	</xsl:template>
	
<!-- Organisations (services d'archives, service versant, service producteur) -->
	<xsl:template match="seda:TransferringAgency|seda:ArchivalAgency|seda:OriginatingAgency|seda:Repository|seda:Requester|seda:Receiver|seda:Sender">
		<xsl:variable name="myid" select="generate-id()"/>
		<fieldset class="Organisation">
			<legend onclick="mytoggle('{$myid}')"><xsl:call-template name="traduction"><xsl:with-param name="term" select="local-name()"/></xsl:call-template></legend>
			<div id="{$myid}">
				<xsl:apply-templates select="*"/>
			</div>
		</fieldset>
	</xsl:template>
	
<!-- Blocs dont l'ordre n'a pas besoin d'etre reorganise -->
	<xsl:template match="seda:CustodialHistory|seda:RelatedObjectReference|seda:Agent|seda:Event|seda:SigningInformation|seda:PersistentIdentifier|seda:Gps|seda:Coverage">
		<div class="{local-name()}">
			<label><xsl:call-template name="traduction"><xsl:with-param name="term" select="local-name()"/></xsl:call-template>: </label>
			<div class="code-value">
				<xsl:apply-templates select="*"/>
			</div>
		</div>
	</xsl:template>	

<!-- Divers: etiquettes qui ne contienent pas d'autre sous-etiquettes  -->
	<xsl:template match="seda:*[count(.//seda:*) = 0][(. != '') or (@* !='')]">
		<div class="{local-name()}">
			<label><xsl:call-template name="traduction"><xsl:with-param name="term" select="local-name()"/></xsl:call-template>: </label>
			<xsl:apply-templates select="@*"/>
			<xsl:apply-templates/>
		</div>
	</xsl:template>

<!-- cas particuliers -->
	<xsl:template match="seda:ReplyCode/text()">
		<xsl:value-of select="."/>
	</xsl:template>
	<xsl:template match="seda:DescriptionLanguage/text()|seda:Language/text()">
		<xsl:value-of select="."/>
	</xsl:template>
	<xsl:template match="seda:KeywordType/text()">
		<xsl:variable name="value" select="."/>
		<xsl:variable name="table">codes/seda_v1-0_keywordtype_code.xsd</xsl:variable>
		<xsl:value-of select="document($table)//xsd:enumeration[@value=$value]//xsd:annotation/xsd:documentation"/>
	</xsl:template>
	

<!-- Regle par défaut pour mettre en rouge tout ce qui a été oublié -->
	<xsl:template match="*">
		<span style="background-color:red">
			<xsl:apply-templates/>
		</span>
	</xsl:template>

<!-- Formatage des Attributs -->
	<xsl:template match="@*[1]">
		<xsl:if test=". != ''">
			<a href="javascript:void(0)" class="info">
				<span>
					<xsl:for-each select="../@*[.!='']">
						<span class="nonexpandable">
							<xsl:if test="local-name()!='filename'">
								<label><xsl:value-of select="local-name()"/></label> = "<xsl:value-of select="."/>"
							</xsl:if>
						</span>
					</xsl:for-each>
				</span>
			</a>
			<xsl:text> </xsl:text>
		</xsl:if>
	</xsl:template>
	<xsl:template match="@*"/>

<!-- Formatage des href pour le pieces attachées -->
	<xsl:template match="seda:Attachment/@filename">
		<a>
			<xsl:attribute name="href">
				<xsl:value-of select="."/>
			</xsl:attribute>
			<xsl:value-of select="."/>
		</a>
	</xsl:template>

	<xsl:template name="RulesType">
			<div class="{local-name()}">
				<label><xsl:call-template name="traduction"><xsl:with-param name="term" select="local-name()"/></xsl:call-template>: </label>
				<xsl:apply-templates select="@*"/>
				<div class="code-value">
					<xsl:apply-templates select="seda:Rule"/>
					<xsl:apply-templates select="seda:StartDate"/>
					<xsl:apply-templates select="seda:FinalAction"/>
					<xsl:apply-templates select="seda:ClassificationLevel"/>
					<xsl:apply-templates select="seda:ClassificationOwner"/>
					<xsl:apply-templates select="seda:ClassificationReassessingDate"/>
					<xsl:apply-templates select="seda:HoldEndDate"/>
					<xsl:apply-templates select="seda:HoldOwner"/>
					<xsl:apply-templates select="seda:HoldReassessingDate"/>
					<xsl:apply-templates select="seda:HoldReason"/>
				</div>
			</div>
	</xsl:template>
	
	<!-- Formatage des dates extremes -->
	<xsl:template name="dates_extremes">
		<xsl:param name="lang"></xsl:param>
		<xsl:if test="(seda:StartDate != '') or (seda:EndDate != '')">
			<div>
				<xsl:choose>
					<xsl:when test="($lang = 'fr')">
						<label>Dates extrêmes : </label>
						<xsl:apply-templates select="seda:StartDate"/>
						<label> au </label>
						<xsl:apply-templates select="seda:EndDate"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:apply-templates/>
					</xsl:otherwise>
				</xsl:choose>
			</div>
		</xsl:if>
	</xsl:template>

	<!-- Formatage des noms -->
	<xsl:template name="name">
		<xsl:param name="nom"></xsl:param>
		<xsl:choose>
			<xsl:when test="($nom != '')"><xsl:value-of select="$nom"/></xsl:when>
			<xsl:otherwise>NO_NAME</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template match="seda:EndDate|seda:StartDate|seda:Date/text()|seda:AcquiredDate/text()|seda:ReceivedDate/text()|seda:Submission/text()|seda:RegisteredDate/text()|seda:SentDate/text()|seda:TransactedDate/text()|seda:CreatedDate/text()" priority="1">
		<xsl:call-template name="date"><xsl:with-param name="date"  select="."/></xsl:call-template>
	</xsl:template>

	<!-- Formatage d'une date -->
	<xsl:template name="date">
		<xsl:param name="date"></xsl:param>
		<xsl:variable name="year">
			<xsl:value-of select="substring($date, 1, 4)"/>
		</xsl:variable>
		<xsl:variable name="mm">
			<xsl:value-of select="substring($date, 6, 2)"/>
		</xsl:variable>
		<xsl:variable name="month">
			<xsl:choose>
				<xsl:when test="$mm='01'">janvier</xsl:when>
				<xsl:when test="$mm='02'">février</xsl:when>
				<xsl:when test="$mm='03'">mars</xsl:when>
				<xsl:when test="$mm='04'">avril</xsl:when>
				<xsl:when test="$mm='05'">mai</xsl:when>
				<xsl:when test="$mm='06'">juin</xsl:when>
				<xsl:when test="$mm='07'">juillet</xsl:when>
				<xsl:when test="$mm='08'">Août</xsl:when>
				<xsl:when test="$mm='09'">septembre</xsl:when>
				<xsl:when test="$mm='10'">octobre</xsl:when>
				<xsl:when test="$mm='11'">novembre</xsl:when>
				<xsl:when test="$mm='12'">décembre</xsl:when>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="day">
			<xsl:value-of select="substring($date, 9, 2)"/>
		</xsl:variable>
		<xsl:value-of select="$day"/>
		<xsl:text> </xsl:text>
		<xsl:value-of select="$month"/>
		<xsl:text> </xsl:text>
		<xsl:value-of select="$year"/>
	</xsl:template>

<!-- Traduction de termes en français -->
	<xsl:template name="traduction">
		<xsl:param name="term"></xsl:param>
		<xsl:choose>
			<!-- ArchiveTransfer -->
			<xsl:when test="($term = 'ArchiveTransfer')">Transfert</xsl:when>
			<xsl:when test="($term = 'Comment')">Commentaire</xsl:when>
			<xsl:when test="($term = 'Date')">Date</xsl:when>
			<xsl:when test="($term = 'RelatedTransferReference')">Référence à un autre transfert</xsl:when>
			<xsl:when test="($term = 'TransferIdentifier')">Identifiant du transfert</xsl:when>
			<xsl:when test="($term = 'TransferRequestReplyIdentifier')">Identifiant de la réponse à la demande de transfert</xsl:when>
			<xsl:when test="($term = 'ArchivalAgency')">Service d'archives</xsl:when>
			<xsl:when test="($term = 'TransferringAgency')">Service versant</xsl:when>
			<!-- ArchiveUnit/Content -->
			<xsl:when test="($term = 'OriginatingSystemId')">Identifiant technique du service producteur</xsl:when>
			<xsl:when test="($term = 'ArchivalAgencyArchiveUnitIdentifier')">Identifiant du service d'archive</xsl:when>
			<xsl:when test="($term = 'OriginatingAgencyArchiveUnitIdentifier')">Identifiant du service producteur</xsl:when>
			<xsl:when test="($term = 'TransferringAgencyArchiveUnitIdentifier')">Identifiant service versant</xsl:when>
			
			<xsl:when test="($term = 'DescriptionLanguage')">Langue de la description</xsl:when>
			<xsl:when test="($term = 'DescriptionLevel')">Niveau de description</xsl:when>
			<xsl:when test="($term = 'Description')">Description</xsl:when>
			<xsl:when test="($term = 'CustodialHistory')">Historique de conservation</xsl:when>
			<xsl:when test="($term = 'CustodialHistoryItem')">Evénement</xsl:when>
			
			<xsl:when test="($term = 'Keyword')">Mot-clé</xsl:when>
			<xsl:when test="($term = 'Language')">Langue du contenu</xsl:when>
			<xsl:when test="($term = 'FilePlanPosition')">Position dans le plan de classement</xsl:when>
			
			<xsl:when test="($term = 'Tag')">Mot-clé</xsl:when>
			<xsl:when test="($term = 'KeywordContent')">Mot-clé</xsl:when>
			<xsl:when test="($term = 'KeywordReference')">Identifiant dans le référentiel associé</xsl:when>
			<xsl:when test="($term = 'KeywordType')">Type</xsl:when>
			
			<xsl:when test="($term = 'AcquiredDate')">Date d'acquisition</xsl:when>
			<xsl:when test="($term = 'EndDate')">Date de fin</xsl:when>
			<xsl:when test="($term = 'StartDate')">Date de départ</xsl:when>
			<xsl:when test="($term = 'ReceivedDate')">Date de réception</xsl:when>
			<xsl:when test="($term = 'RegisteredDate')">Date d'enregistrement</xsl:when>
			<xsl:when test="($term = 'Date')">Date</xsl:when>
			<xsl:when test="($term = 'DateLitteral')">Date littéral</xsl:when>
			
			<xsl:when test="($term = 'Name')">Nom</xsl:when>
			<xsl:when test="($term = 'OriginatingAgency')">Service producteur</xsl:when>
			<xsl:when test="($term = 'Type')">Type au sens OAIS</xsl:when>
			<xsl:when test="($term = 'DocumentType')">Type de document</xsl:when>
			
			<xsl:when test="($term = 'RelatedObjectReference')">Données liées</xsl:when>
			<xsl:when test="($term = 'Gender')">Genre</xsl:when>
			<xsl:when test="($term = 'GivenName')">Nom d'usage</xsl:when>
			<xsl:when test="($term = 'FullName')">Nom complet</xsl:when>
			<xsl:when test="($term = 'FirstName')">Prénom</xsl:when>
			<xsl:when test="($term = 'BirthName')">Nom de naissance</xsl:when>
			<xsl:when test="($term = 'BirthPlace')">Lieu de naissance</xsl:when>
			<xsl:when test="($term = 'DeathDate')">Lieu de mort</xsl:when>
			<xsl:when test="($term = 'Function')">Fonction de l'agent</xsl:when>
			<xsl:when test="($term = 'Activity')">Activité de l'agent</xsl:when>
			<xsl:when test="($term = 'Identifier')">Identifiant de l'agent</xsl:when>
			<xsl:when test="($term = 'Mandate')">Mandat de l'agent</xsl:when>
			<xsl:when test="($term = 'Nationality')">Nationnalité de l'agent</xsl:when>
			<xsl:when test="($term = 'Position')">Intitulé du poste</xsl:when>
			<xsl:when test="($term = 'Role')">Role</xsl:when>
			
			<xsl:when test="($term = 'OriginatingSystemIdReplyToGroup')">Référence du message auquel on répond</xsl:when>
			<xsl:when test="($term = 'TextContent')">Contenu du message électronique</xsl:when>
			<xsl:when test="($term = 'PersistentIdentifier')">Identifiants pérennes</xsl:when>
			<xsl:when test="($term = 'PersistentIdentifierType')">Type d'identifiant pérenne</xsl:when>
			<xsl:when test="($term = 'PersistentIdentifierOrigin')">Origine d'identifiant pérenne</xsl:when>
			<xsl:when test="($term = 'PersistentIdentifierReference')">Référence d'identifiant pérenne</xsl:when>
			<xsl:when test="($term = 'PersistentIdentifierContent')">valeur de l'identifiant pérenne</xsl:when>
			
			<xsl:when test="($term = 'Event')">Evènement</xsl:when>
			<xsl:when test="($term = 'EventDateTime')">Date de l'évènement</xsl:when>
			<xsl:when test="($term = 'EventIdentifier')">Identifiant de l'évènement</xsl:when>
			<xsl:when test="($term = 'EventType')">Type de l'évènement</xsl:when>
			<xsl:when test="($term = 'EventTypeCode')">Code du type d'événement</xsl:when>
			<xsl:when test="($term = 'EventDetailData')">Message technique de l'évènement</xsl:when>
			<xsl:when test="($term = 'EventDetail')">Détail de l'évènement</xsl:when>
			<xsl:when test="($term = 'EventAbstract')">Extension de nouveaux types d'évenéments</xsl:when>
			<xsl:when test="($term = 'Outcome')">Résultat</xsl:when>
			<xsl:when test="($term = 'OutcomeDetail')">Détail du résultat</xsl:when>
			<xsl:when test="($term = 'OutcomeDetailMessage')">Message de détail du résultat</xsl:when>
			<xsl:when test="($term = 'LinkingAgentIdentifier')">Agents répertoriés dans des évènements</xsl:when>
			<xsl:when test="($term = 'LinkingAgentIdentifierType')">Identifiant d'un agent répertorié dans des évènements</xsl:when>
			<xsl:when test="($term = 'LinkingAgentIdentifierValue')">Mention d'un agent répertorié dans des évènements</xsl:when>
			<xsl:when test="($term = 'LinkingAgentRole')">Fonction d'un agent répertorié dans des évènements</xsl:when>
			
			<xsl:when test="($term = 'SigningInformation')">Informations sur la signature</xsl:when>
			<xsl:when test="($term = 'SigningRole')">Etiquette de signature</xsl:when>
			<xsl:when test="($term = 'DetachedSigningRole')">Unité d'archives encapsulée</xsl:when>
			<xsl:when test="($term = 'SignedDocumentReferenceId')">Relation technique à l'unité d'archives racine</xsl:when>
			<xsl:when test="($term = 'SignatureDescription')">Description de la signature</xsl:when>
			<xsl:when test="($term = 'TimestampingInformation')">Informations d'horodatage</xsl:when>
			<xsl:when test="($term = 'AdditionalProof')">Preuves complémentaires</xsl:when>
			<xsl:when test="($term = 'Extended')">Informations libres sur la signature</xsl:when>
			<xsl:when test="($term = 'Signer')">Signataire</xsl:when>
			<xsl:when test="($term = 'Validator')">Validateur</xsl:when>
			<xsl:when test="($term = 'SigningType')">Type de signature</xsl:when>
			<xsl:when test="($term = 'SigningTime')">Date de signature</xsl:when>
			<xsl:when test="($term = 'ValidationTime')">Date de la validation de la signature</xsl:when>
			<xsl:when test="($term = 'TimeStamp')">Horodatage de la signature</xsl:when>
			<xsl:when test="($term = 'AdditionalTimestampingInformation')">Informations complémentaires sur l'horodatage</xsl:when>
			<xsl:when test="($term = 'AdditionalProofInformation')">Informations relatives aux preuves complémentaires</xsl:when>
			
			<!-- BinaryDataObject -->
			<xsl:when test="($term = 'MessageDigest')">Empreinte</xsl:when>
			<xsl:when test="($term = 'Uri')">Chemin vers le fichier</xsl:when>
			<xsl:when test="($term = 'Attachment')">Pièce jointe</xsl:when>
			<xsl:when test="($term = 'FormatLitteral')">Forme littérale du format</xsl:when>
			<xsl:when test="($term = 'Size')">Taille</xsl:when>
			<xsl:when test="($term = 'MimeType')">Type MIME</xsl:when>
			<xsl:when test="($term = 'FormatId')">Identifiant PRONOM</xsl:when>
			<xsl:when test="($term = 'LastModified')">Date de dernière modification</xsl:when>
			<xsl:when test="($term = 'Filename')">Nom du fichier</xsl:when>
			<xsl:when test="($term = 'DataObjectProfile')">Profil d'objet</xsl:when>
			
			<!-- BinaryDataObject -->
			<xsl:when test="($term = 'DataObjectNumber')">Version d'un objet de données</xsl:when>
			<xsl:when test="($term = 'PhysicalId')">Identifiant d'un objet physique</xsl:when>
			<xsl:when test="($term = 'PhysicalDimensions')">Dimensions d'un objet physique</xsl:when>
			
			<!-- ManagementMetadata | Management -->
			<xsl:when test="($term = 'ArchivalAgreement')">Convention de services</xsl:when>
			<xsl:when test="($term = 'ArchivalProfile')">Profil d'archivage</xsl:when>
			<xsl:when test="($term = 'ArchiveUnit')">Unité d'archives</xsl:when>
			<xsl:when test="($term = 'ServiceLevel')">Niveau de service demandé</xsl:when>
			<xsl:when test="($term = 'AcquisitionInformation')">Modalités d'entrées</xsl:when>
			<xsl:when test="($term = 'LegalStatus')">Statut legal</xsl:when>
			<xsl:when test="($term = 'OriginatingAgencyIdentifier')">Identifiant du service producteur</xsl:when>
			<xsl:when test="($term = 'SumissionAgencyIdentifier')">Identifiant du service versant</xsl:when>
			<xsl:when test="($term = 'AccessRule')">Règle de restriction d'accès</xsl:when>
			<xsl:when test="($term = 'AppraisalRule')">Règle de sort final</xsl:when>
			<xsl:when test="($term = 'DisseminationRule')">Règle de diffusion</xsl:when>
			<xsl:when test="($term = 'ReuseRule')">Règle de réutilisation</xsl:when>
			<xsl:when test="($term = 'StorageRule')">Règle de durée d'utilité courante</xsl:when>
			<xsl:when test="($term = 'ClassificationRule')">Règle de classification</xsl:when>
			<xsl:when test="($term = 'HoldRule')">Règle de gel</xsl:when>
			<xsl:when test="($term = 'HoldEndDate')">Date de fin de gel explicite</xsl:when>
			<xsl:when test="($term = 'HoldOwner')">Propriétaire de la demande de gel</xsl:when>
			<xsl:when test="($term = 'HoldReassessingDate')">Date de réévaluation du gel</xsl:when>
			<xsl:when test="($term = 'HoldReason')">Motif de gel</xsl:when>
			<xsl:when test="($term = 'PreventRearrangement')">Blocage de la reclassification</xsl:when>
			<xsl:when test="($term = 'Rule')">Règle</xsl:when>
			<xsl:when test="($term = 'FinalAction')">Sort final</xsl:when>
			<xsl:when test="($term = 'StartDate')">Date de départ</xsl:when>
			<xsl:when test="($term = 'ClassificationAudience')">Type d'audience</xsl:when>
			<xsl:when test="($term = 'ClassificationLevel')">Niveau de classification</xsl:when>
			<xsl:when test="($term = 'ClassificationOwner')">Propriétaire de la classification</xsl:when>
			<xsl:when test="($term = 'ClassificationReassessingDate')">Date de nouvelle classification</xsl:when>
			<xsl:when test="($term = 'NeedReassessingAuthorization')">Autorisation humaine</xsl:when>
			<xsl:when test="($term = 'PreventInheritance')">Ignorance de l'héritage</xsl:when>
			<xsl:when test="($term = 'RefNonRuleId')">Retrait de l'héritage</xsl:when>
			
			<!-- autres messages -->
			<xsl:when test="($term = 'ReplyCode')">Code retour</xsl:when>
			<xsl:when test="($term = 'GrantDate')">Date du transfert de responsabilité</xsl:when>
			<xsl:when test="($term = 'TransferReplyIdentifier')">Identifiant de la réponse au transfert</xsl:when>
			<xsl:when test="($term = 'AcknowledgementIdentifier')">Identifiant de l'accusé de réception</xsl:when>
			<xsl:when test="($term = 'MessageReceivedIdentifier')">Identifiant du message dont on accuse réception</xsl:when>
			<xsl:when test="($term = 'Receiver')">Service qui accuse réception</xsl:when>
			<xsl:when test="($term = 'Sender')">Expéditeur du message dont on accuse réception</xsl:when>
			<xsl:when test="($term = 'DeliveryRequestIdentifier')">Identifiant de la demande de communication</xsl:when>
			<xsl:when test="($term = 'Derogation')">Demande de dérogation</xsl:when>
			<xsl:when test="($term = 'UnitIdentifier')">Identifiant</xsl:when>
			<xsl:when test="($term = 'Requester')">Demandeur</xsl:when>
			<xsl:when test="($term = 'AuthorizationRequestReplyIdentifier')">Identifiant de l'autorisation de communication du service de contrôle</xsl:when>
			<xsl:when test="($term = 'DeliveryRequestIdentifier')">Identifiant de la demande de communication</xsl:when>
			<xsl:when test="($term = 'DeliveryRequestReplyIdentifier')">Identifiant de la réponse à la demande de communcation</xsl:when>

			<xsl:otherwise><xsl:value-of select="$term"/></xsl:otherwise>
		</xsl:choose>
	</xsl:template>

</xsl:stylesheet>
