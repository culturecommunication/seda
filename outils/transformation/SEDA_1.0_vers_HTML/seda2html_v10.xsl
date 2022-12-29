<?xml version="1.0" encoding="ISO-8859-1" ?>
<!--
	SEDA v1.0 XSLT display HTML
-->

<xsl:stylesheet version="1.0"
	xmlns:seda="fr:gouv:culture:archivesdefrance:seda:v1.0"
	xmlns="http://www.w3.org/1999/xhtml"
               xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
               xmlns:xsd="http://www.w3.org/2001/XMLSchema"
               xmlns:ccts="urn:un:unece:uncefact:documentation:standard:CoreComponentsTechnicalSpecification:2"
	exclude-result-prefixes="seda xsl xsd ccts">

	<xsl:output method="html" indent="yes" media-type="text/html" encoding="UTF-8"/>

	<xsl:template match="/">
		<html>
			<head>
				<style type="text/css">
.info-generales  { text-align:center; }
a.info           { text-decoration: none; position:relative; z-index:10; }
a.info:before    { padding-right: 0.3em; content: url("./pics/ico-loupe.gif"); }
a.info:hover     { z-index:20; }
a.info > span    { display:none; }
a.info:hover > span { display:block; position:absolute; top:18px; left:10px; padding-left:5px; padding-top:2px; padding-bottom:2px; padding-right:5px; font-family:'Courier', monospace; font-weight:normal; font-size:10px; color:#777777; text-decoration:none; width:450px; text-align:left; background-color: lightblue; white-space:normal; }
a.info:hover > span > span { display:block; }
.acteurs         { display:table; width: 100%; border-spacing: 30pt 2pt; table-layout: fixed; }
.acteur          { display:table-cell; vertical-align :top; }
.Archive-name, .ArchiveObject-name, .Document-name {	 font-weight: bold; }
.Archive-name:before { padding-right: 0.3em; content: url("./pics/folder.png"); }
div.Archive      { display: block; padding: 0.8em; border: dotted 1px blue; background-color: #EEEEFF; }
div.ArchiveObject     { display: none; padding: 0.6em; border: dotted 1px grey; }
div.Document     { display: none; padding: 0.4em; border: dotted 1px red; background-color: #DDCCFF; }
div.Organisation { display: block; padding: 0.8em; margin: 0.8em; border: dotted 1px blue; }
body             { font-size: small; color:#4B4B4B; background-color: #FFFFCC;}
fieldset         { border: 1px solid blue;}
legend           { color: blue; font-weight: bold; padding: 2px 6px }
h2               { color: blue; text-align:center;}
h4               { margin: 0px; padding: 0.1em;}
label            { font-weight: bold; }
code             { display: block; padding: 0.8em; margin: 0.8em; background-color: lightgrey; }
div.Address, div.Contact { display: block; padding: 0.8em; margin: 0.8em; border: dotted 1px blue; }
div.code-value   { padding-left: 2.0em; }
li.nonexpandable { margin: 0px; padding: 0px; list-style: none; }
li.expandable    { margin: 0px; padding: 0px; list-style-image: url("./pics/file-open.png"); }
li.expanded      { margin: 0px; padding: 0px; list-style-image: url("./pics/folder.png"); }
#commands        { text-align: right; }
.ContentDescription { display: block; background-color: #CCCCFF;	 border: dotted 1px blue; padding: 0.8em; margin: 0.8em; }
				</style>
				<script type="text/javascript">
function mytoggle(eltId) {
	var elt = document.getElementById(eltId);
	elt.style.display = (elt.style.display == "block") ? "none" : "block";
}

function toggle(event, item) {
	event = event || window.event;
	if (event.stopPropagation instanceof Function) event.stopPropagation();
	else event.cancelBubble = true;
	if (item.className == "expandable") {
		processVisibility(item, true);
		item.className = "expanded";
	} else if (item.className == "expanded") {
		item.className = "expandable";
		processVisibility(item, false);
	}
	return false;
}

function processVisibility(item, visible) {
	var childs = item.childNodes;
	for (var i=0; i&lt;childs.length; i++) {
		if ( (childs.item(i).className == "ArchiveObject") 
			|| (childs.item(i).className == "Document")
			|| (childs.item(i).className == "Attachment") ) {
			if (visible) {
				childs.item(i).style.display = "block";
			} else {
				childs.item(i).style.display = "none";
			}
		}	
	}
}

function expandAll(visible) {
	var theClass = 'expanded';
	if (visible) {
		theClass = 'expandable';
	}
	var allHTMLTags=document.getElementsByTagName("*");
	for (i=0; i&lt;allHTMLTags.length; i++) {
		var tag = allHTMLTags[i];
		if (tag.className==theClass) {
			processVisibility(tag, visible);
			if (visible) {
				tag.className = "expanded";
			} else {
				tag.className = "expandable";
			}
		}
	}
}
				</script>
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
					<xsl:apply-templates select="seda:TransferIdentifier"/>
					<xsl:apply-templates select="seda:TransferRequestReplyIdentifier"/>
				</div>
				<div class="acteurs">
					<div class="acteur"><xsl:apply-templates select="seda:TransferringAgency"/></div>
					<div class="acteur"><xsl:apply-templates select="seda:ArchivalAgency"/></div>
				</div>
				<xsl:apply-templates select="seda:NonRepudiation"/>
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
				<xsl:apply-templates select="seda:Archive"/>
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
					<xsl:apply-templates select="seda:TransferIdentifier"/>
					<xsl:apply-templates select="seda:TransferReplyIdentifier"/>
				</div>
				<div class="acteurs">
					<div class="acteur"><xsl:apply-templates select="seda:TransferringAgency"/></div>
					<div class="acteur"><xsl:apply-templates select="seda:ArchivalAgency"/></div>
				</div>
				<xsl:apply-templates select="seda:NonRepudiation"/>
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
				<xsl:apply-templates select="seda:NonRepudiation"/>
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
				<xsl:apply-templates select="seda:NonRepudiation"/>
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
				<xsl:apply-templates select="seda:NonRepudiation"/>
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
				<xsl:apply-templates select="seda:Archive"/>
			</div>
		</fieldset>
	</xsl:template>

<!-- Archive -->
	<xsl:template match="seda:Archive">
		<div>
			<p class="Archive-name">
				<xsl:call-template name="name">
					<xsl:with-param name="nom" select="seda:Name"/>
				</xsl:call-template>
			</p>
			<div>
				<xsl:apply-templates select="@*"/>
				
				<xsl:apply-templates select="seda:ArchivalAgencyArchiveIdentifier"/>
				<xsl:apply-templates select="seda:TransferringAgencyArchiveIdentifier"/>
				<xsl:apply-templates select="seda:OriginatingAgencyArchiveIdentifier"/>
				<xsl:apply-templates select="seda:ArchivalAgreement"/>
				<xsl:apply-templates select="seda:ArchivalProfile"/>
				<xsl:apply-templates select="seda:DescriptionLanguage"/>
				<xsl:apply-templates select="seda:ServiceLevel"/>
				<xsl:apply-templates select="seda:AppraisalRule"/>
				<xsl:apply-templates select="seda:AccessRestrictionRule"/>
				
				<xsl:apply-templates select="seda:ContentDescription"/>
				<xsl:if test="seda:ArchiveObject">
					<ul>
						<xsl:for-each select="seda:ArchiveObject">
							<li class="expandable" onclick="toggle(event, this)">
								<xsl:apply-templates select="."/>
							</li>
						</xsl:for-each>
					</ul>
				</xsl:if>
				<xsl:if test="seda:Document">
					<ul>
						<xsl:for-each select="seda:Document">
							<li class="expandable" onclick="toggle(event, this)">
								<xsl:apply-templates select="."/>
							</li>
						</xsl:for-each>
					</ul>
				</xsl:if>
			</div>
		</div>
	</xsl:template>	

<!-- ArchiveObject -->	
	<xsl:template  match="seda:ArchiveObject">
		<p class="ArchiveObject-name" onclick="toggle(event, this)">
			<xsl:call-template name="name">
				<xsl:with-param name="nom" select="seda:Name"/>
			</xsl:call-template>
		</p>
		<div class="ArchiveObject" onclick="toggle(event, this)">
			<xsl:apply-templates select="@*"/>
			<xsl:apply-templates select="seda:ArchivalAgencyObjectIdentifier"/>
			<xsl:apply-templates select="seda:TransferringAgencyObjectIdentifier"/>
			<xsl:apply-templates select="seda:OriginatingAgencyObjectIdentifier"/>
			<xsl:apply-templates select="seda:AppraisalRule"/>
			<xsl:apply-templates select="seda:AccessRestrictionRule"/>
			
			<xsl:apply-templates select="seda:ContentDescription"/>
			<xsl:if test="seda:ArchiveObject">
				<ul>
					<xsl:for-each select="seda:ArchiveObject">
						<li class="expandable" onclick="toggle(event, this)">
							<xsl:apply-templates select="."/>
						</li>
					</xsl:for-each>
				</ul>
			</xsl:if>
			<xsl:if test="seda:Document">
				<ul>
					<xsl:for-each select="seda:Document">
						<li class="expandable" onclick="toggle(event, this)">
							<xsl:apply-templates select="."/>
						</li>
					</xsl:for-each>
				</ul>
			</xsl:if>
		</div>
	</xsl:template>
	
<!-- Document -->
	<xsl:template match="seda:Document">
		<p onclick="toggle(event, this)" class="Document-name">
			Document
		</p>
		<div class="Document" onclick="toggle(event, this)">
			<xsl:apply-templates select="@*"/>                      
			<xsl:apply-templates select="seda:ArchivalAgencyDocumentIdentifier"/>
			<xsl:apply-templates select="seda:OriginatingAgencyDocumentIdentifier"/>
			<xsl:apply-templates select="seda:TransferringAgencyDocumentIdentifier"/>
			<xsl:apply-templates select="seda:Control"/>
			<xsl:apply-templates select="seda:Copy"/>
			<xsl:apply-templates select="seda:Creation"/>
			<xsl:apply-templates select="seda:Description"/>
			<xsl:apply-templates select="seda:Issue"/>
			<xsl:apply-templates select="seda:Language"/>
			<xsl:apply-templates select="seda:Purpose"/>
			<xsl:apply-templates select="seda:Receipt"/>
			<xsl:apply-templates select="seda:Response"/>
			<xsl:apply-templates select="seda:Size"/>
			<xsl:apply-templates select="seda:Status"/>
			<xsl:apply-templates select="seda:Submission"/>
			<xsl:apply-templates select="seda:Type"/>
			<xsl:apply-templates select="seda:Integrity"/>
			<xsl:apply-templates select="seda:RelatedData"/>
			<xsl:apply-templates select="seda:OtherMetadata"/>
			
			<xsl:apply-templates select="seda:Attachment"/>
		</div>
	</xsl:template>
	
<!-- Attachment -->
	<!-- on n'affiche pas le contenu qui peut être en base64Binary -->
	<xsl:template match="seda:Attachment">
		<div class="Attachment">
			<label><xsl:call-template name="traduction"><xsl:with-param name="term" select="local-name()"/></xsl:call-template>: </label>
                        		<xsl:apply-templates select="@*"/>
		</div>
	</xsl:template>

<!-- Content description -->
	<xsl:template match="seda:ContentDescription">
		<div class="ContentDescription">
			<div class="collapsed-content">
				<!-- <label><xsl:call-template name="traduction"><xsl:with-param name="term" select="local-name()"/></xsl:call-template>: </label> -->
				<xsl:apply-templates select="seda:OriginatingAgency"/>
				<xsl:apply-templates select="seda:Repository"/>
				<xsl:apply-templates select="seda:CustodialHistory"/>
				<xsl:apply-templates select="seda:Description"/>
				<xsl:call-template name="dates_extremes"><xsl:with-param name="lang" select="'fr'"/></xsl:call-template>
				<xsl:apply-templates select="seda:DescriptionLevel"/>
				<xsl:apply-templates select="seda:FilePlanPosition"/>
				<xsl:apply-templates select="seda:OtherDescriptiveData"/>
				<xsl:apply-templates select="seda:RelatedObjectReference"/>
				<xsl:apply-templates select="seda:Keyword"/>
				<xsl:apply-templates select="seda:AccessRestrictionRule"/>
				<xsl:apply-templates select="seda:Language"/>
				<xsl:apply-templates select="seda:Size"/>
				<xsl:apply-templates select="seda:OtherMetadata"/>
			</div>
		</div>
	</xsl:template>

<!-- Keyword -->
	<xsl:template match="seda:Keyword[1]">
		<div class="{local-name()}">
			<label><xsl:call-template name="traduction"><xsl:with-param name="term">Keywords</xsl:with-param></xsl:call-template>: </label>
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
	<xsl:template match="seda:AccessRestrictionRule|seda:AppraisalRule">
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
	
<!-- Contact -->
	<xsl:template match="seda:Contact">
		<div class="{local-name()}">
			<label><xsl:call-template name="traduction"><xsl:with-param name="term" select="local-name()"/></xsl:call-template>: </label>
			<div class="code-value">
				<xsl:apply-templates select="seda:PersonName"/>
				<xsl:apply-templates select="seda:Identification"/>
				<xsl:apply-templates select="seda:Responsibility"/>
				<xsl:apply-templates select="seda:DepartmentName"/>
				<xsl:apply-templates select="seda:Address"/>
				<xsl:apply-templates select="seda:Communication"/>
			</div>
		</div>
	</xsl:template>
	
<!-- Address -->
	<xsl:template match="seda:Address">
		<div class="{local-name()}">
			<label><xsl:call-template name="traduction"><xsl:with-param name="term" select="local-name()"/></xsl:call-template>: </label>
			<div class="code-value">
				<xsl:apply-templates select="seda:BlockName"/>
				<xsl:apply-templates select="seda:BuildingName"/>
				<xsl:apply-templates select="seda:BuildingNumber"/>
				<xsl:apply-templates select="seda:StreetName"/>
				<xsl:apply-templates select="seda:Postcode"/>
				<xsl:apply-templates select="seda:CityName"/>
				<xsl:apply-templates select="seda:CitySub-DivisionName"/>
				<xsl:apply-templates select="seda:Country"/>
				<xsl:apply-templates select="seda:FloorIdentification"/>
				<xsl:apply-templates select="seda:PostOfficeBox"/>
				<xsl:apply-templates select="seda:RoomIdentification"/>
			</div>
		</div>
	</xsl:template>
	
<!-- Blocs dont l'ordre n'a pas besoin d'etre reorganise -->
	<xsl:template match="seda:Communication|seda:CustodialHistory|seda:RelatedData|seda:RelatedObjectReference">
		<div class="{local-name()}">
			<label><xsl:call-template name="traduction"><xsl:with-param name="term" select="local-name()"/></xsl:call-template>: </label>
			<div class="code-value">
				<xsl:apply-templates select="*"/>
			</div>
		</div>
	</xsl:template>
	

<!-- Signature -->
	<xsl:template match="seda:NonRepudiation">
		<div class="{local-name()}">
			<label><xsl:call-template name="traduction"><xsl:with-param name="term" select="local-name()"/></xsl:call-template>: </label>
			<code>
				<xsl:call-template name="code"/>
			</code>
		</div>
	</xsl:template>	
	
<!-- Empreinte -->
	<xsl:template match="seda:Integrity">
		<div>
			<label><xsl:call-template name="traduction"><xsl:with-param name="term" select="local-name()"/></xsl:call-template>: </label>
			<xsl:apply-templates select="@*"/>
			<xsl:apply-templates/>
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

	<xsl:template match="seda:AppraisalRule/seda:Code[(. != '') or (@* !='')]">
		<div class="{local-name()}">
			<label><xsl:call-template name="traduction">
				<xsl:with-param name="term">AppraisalRule/Code</xsl:with-param>
			</xsl:call-template>: </label>
			<xsl:apply-templates select="@*"/>
			<xsl:apply-templates/>
		</div>
	</xsl:template>
	<xsl:template match="seda:AccessRestrictionRule/seda:Code[(. != '') or (@* !='')]">
		<div class="{local-name()}">
			<label><xsl:call-template name="traduction">
				<xsl:with-param name="term">AccessRestrictionRule/Code</xsl:with-param>
			</xsl:call-template>: </label>
			<xsl:apply-templates select="@*"/>
			<xsl:apply-templates/>
		</div>
	</xsl:template>
	<xsl:template match="seda:Contact/seda:DepartmentName[(. != '') or (@* !='')]">
		<div class="{local-name()}">
			<label><xsl:call-template name="traduction">
				<xsl:with-param name="term">Contact/DepartmentName</xsl:with-param>
			</xsl:call-template>: </label>
			<xsl:apply-templates select="@*"/>
			<xsl:apply-templates/>
		</div>
	</xsl:template>
	<xsl:template match="seda:URIID[(. != '') or (@* !='')]">
		<a>
			<xsl:choose>
				<xsl:when test="contains(., '@')">
					<xsl:attribute name="href">mailto:<xsl:apply-templates/></xsl:attribute>
				</xsl:when>
				<xsl:otherwise>
					<xsl:attribute name="href"><xsl:apply-templates/></xsl:attribute>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:apply-templates/>
		</a>
	</xsl:template>

	<xsl:template match="seda:Copy[(. != '') or (@* !='')]/text()">
		<xsl:choose>
			<xsl:when test=".='true'">copie</xsl:when>
			<xsl:when test=".='false'">original</xsl:when>
			<xsl:otherwise><xsl:apply-templates/></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template match="seda:Control[(. != '') or (@* !='')]/text()">
		<xsl:choose>
			<xsl:when test=".='true'">vrai</xsl:when>
			<xsl:when test=".='false'">faux</xsl:when>
			<xsl:otherwise><xsl:apply-templates/></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template match="seda:Duration/text()">
		<xsl:param name="periode" select="substring-after(.,'P')"/>
		<xsl:variable name="ans">
			<xsl:if test="contains($periode, 'Y')"><xsl:value-of select="substring-before($periode, 'Y')"/></xsl:if>
		</xsl:variable>
		<xsl:variable name="mois">
			<xsl:choose>
				<xsl:when test="contains($periode, 'Y')">
					<xsl:value-of select="substring-before(substring-after($periode, 'Y'), 'M')"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="substring-before($periode, 'M')"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="jours">
			<xsl:choose>
				<xsl:when test="contains($periode, 'M')">
					<xsl:value-of select="substring-before(substring-after($periode, 'M'), 'D')"/>
				</xsl:when>
				<xsl:when test="contains($periode, 'Y')">
					<xsl:value-of select="substring-before(substring-after($periode, 'Y'), 'D')"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="substring-before($periode, 'D')"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:if test="($ans!='')">
			<xsl:value-of select="$ans"/> an<xsl:if test="(number($ans)>1)">s </xsl:if>
		</xsl:if>
		<xsl:if test="($mois!='')">
			<xsl:value-of select="$mois"/> moi<xsl:if test="(number($mois)>1)">s </xsl:if>
		</xsl:if>
		<xsl:if test="($jours!='')">
			<xsl:value-of select="$jours"/> jour<xsl:if test="(number($jours)>1)">s </xsl:if>
		</xsl:if>
	</xsl:template>

	<xsl:template match="seda:ReplyCode/text()">
		<xsl:value-of select="."/>
	</xsl:template>
	<xsl:template match="seda:DescriptionLevel/text()">
		<xsl:variable name="value" select="."/>
		<xsl:variable name="table">codes/seda_v1-0_descriptionlevel_code.xsd</xsl:variable>
		<xsl:value-of select="document($table)//xsd:enumeration[@value=$value]//xsd:annotation/xsd:documentation/ccts:Name"/>
	</xsl:template>
	<xsl:template match="seda:Type/text()">
		<xsl:variable name="value" select="."/>
		<xsl:variable name="table">codes/seda_v1-0_documenttype_code.xsd</xsl:variable>
		<xsl:value-of select="document($table)//xsd:enumeration[@value=$value]//xsd:annotation/xsd:documentation[@xml:lang='fr']/ccts:Name"/>
	</xsl:template>
	<xsl:template match="seda:DescriptionLanguage/text()|seda:Language/text()">
		<xsl:value-of select="."/>
	</xsl:template>
	<xsl:template match="seda:AppraisalRule/seda:Code/text()">
		<xsl:variable name="value" select="."/>
		<xsl:variable name="table">codes/seda_v1-0_appraisal_code.xsd</xsl:variable>
		<xsl:value-of select="document($table)//xsd:enumeration[@value=$value]//xsd:annotation/xsd:documentation/ccts:Name"/>
	</xsl:template>
	<xsl:template match="seda:Size[@unitCode!='']/text()">
		<xsl:variable name="value"><xsl:value-of select="../@unitCode"/></xsl:variable>
		<xsl:variable name="table">codes/UNECE_MeasurementUnitCommonCode_7.xsd</xsl:variable>
		<xsl:value-of select="."/> 
		<xsl:value-of select="document($table)//xsd:enumeration[@value=$value]//xsd:annotation/xsd:documentation"/>
	</xsl:template>
	<xsl:template match="seda:Country/text()">
		<xsl:variable name="value" select="."/>
		<xsl:variable name="table">codes/ISO_ISOTwoletterCountryCode_SecondEdition2006VI-8.xsd</xsl:variable>
		<xsl:value-of select="document($table)//xsd:enumeration[@value=$value]//xsd:annotation/xsd:documentation/ccts:Name"/>
	</xsl:template>
	<xsl:template match="seda:AccessRestrictionRule/seda:Code/text()">
		<xsl:variable name="value" select="."/>
		<xsl:variable name="table">codes/seda_v1-0_accessrestriction_code.xsd</xsl:variable>
		<xsl:variable name="meta"><xsl:value-of select="document($table)//xsd:enumeration[@value=$value]//xsd:annotation/xsd:documentation/ccts:Name"/></xsl:variable>
		<xsl:choose>
			<xsl:when test="$meta='0 an'">Immédiat</xsl:when>
			<xsl:otherwise><xsl:value-of select="$meta"/></xsl:otherwise>
		</xsl:choose>
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
				<xsl:apply-templates select="seda:Duration"/>
				<xsl:apply-templates select="seda:Code"/>
				<xsl:apply-templates select="seda:StartDate"/>
			</div>
		</div>
	</xsl:template>


	<!-- Formatage des dates extremes -->
	<xsl:template name="dates_extremes">
		<xsl:param name="lang"></xsl:param>
		<xsl:if test="(seda:LatestDate != '') or (seda:OldestDate != '')">
			<div>
				<xsl:choose>
					<xsl:when test="($lang = 'fr')">
						<label>Dates extrêmes : </label>
						<xsl:apply-templates select="seda:OldestDate"/>
						<label> au </label>
						<xsl:apply-templates select="seda:LatestDate"/>
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
	
	<xsl:template match="seda:LatestDate|seda:OldestDate|seda:StartDate/text()|seda:Date/text()|seda:Receipt/text()|seda:Response/text()|seda:Submission/text()|seda:Issue/text()|seda:Creation/text()" priority="1">
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
		<!-- <xsl:text> à </xsl:text>
		<xsl:value-of select="substring-after($date, 'T')"/> -->
	</xsl:template>


	<!-- Formatage des code xml -->
	<xsl:template name="code">
		<xsl:if test="node()">
			<xsl:text>&lt;</xsl:text>
			<xsl:value-of select="local-name()"/>
			<xsl:text> xmlns="</xsl:text><xsl:value-of select="namespace-uri()"/><xsl:text>" </xsl:text>
			<xsl:for-each select="@*">
				<xsl:text> </xsl:text><xsl:value-of select="local-name()"/><xsl:text>="</xsl:text><xsl:value-of select="."/><xsl:text>"</xsl:text>
			</xsl:for-each>
			<xsl:text>&gt;</xsl:text>
		</xsl:if>
		
		<xsl:value-of select="normalize-space(text())"/>
		
		<xsl:for-each select="text()|*">
			<xsl:call-template name="code"/>
		</xsl:for-each>

		<xsl:if test="node()">
			<xsl:text>&lt;/</xsl:text><xsl:value-of select="local-name()"/><xsl:text>&gt;</xsl:text>
		</xsl:if>
	</xsl:template>

<!-- Traduction de termes en français -->
	<xsl:template name="traduction">
		<xsl:param name="term"></xsl:param>
		<xsl:choose>
			<!-- schema archive_transfer -->
			<xsl:when test="($term = 'ArchiveTransfer')">Transfert</xsl:when>
			<xsl:when test="($term = 'Comment')">Commentaire</xsl:when>
			<xsl:when test="($term = 'Date')">Date</xsl:when>
			<xsl:when test="($term = 'RelatedTransferReference')">Référence à un autre transfert</xsl:when>
			<xsl:when test="($term = 'TransferIdentifier')">Identifiant du transfert</xsl:when>
			<xsl:when test="($term = 'TransferRequestReplyIdentifier')">Identifiant de la réponse à la demande de transfert</xsl:when>
			<xsl:when test="($term = 'ArchivalAgency')">Service d'archives</xsl:when>
			<xsl:when test="($term = 'TransferringAgency')">Service versant</xsl:when>
			<xsl:when test="($term = 'NonRepudiation')">Signature</xsl:when>
			<!-- schema archive -->
			<xsl:when test="($term = 'AccessRestrictionRule')">Règle de restriction d'accès</xsl:when>
			<xsl:when test="($term = 'AppraisalRule')">Règle de sort final</xsl:when>
			<xsl:when test="($term = 'ArchivalAgencyArchiveIdentifier')">Identifiant du service d'archive</xsl:when>
			<xsl:when test="($term = 'ArchivalAgencyDocumentIdentifier')">Identifiant du service d'archive</xsl:when>
			<xsl:when test="($term = 'ArchivalAgencyObjectIdentifier')">Identifiant du service d'archive</xsl:when>
			<xsl:when test="($term = 'ArchivalAgreement')">Convention de services</xsl:when>
			<xsl:when test="($term = 'ArchivalProfile')">Profil d'archivage</xsl:when>
			<xsl:when test="($term = 'Archive')">Archive</xsl:when>
			<xsl:when test="($term = 'ArchiveObject')">Unité documentaire</xsl:when>
			<xsl:when test="($term = 'Attachment')">Pièce jointe</xsl:when>
			<xsl:when test="($term = 'Code')">Code</xsl:when>
			<xsl:when test="($term = 'ContentDescription')">Description du contenu</xsl:when>
			<xsl:when test="($term = 'Keyword')">Mot-clé</xsl:when>
			<xsl:when test="($term = 'Control')">Exigences de contrôle</xsl:when>
			<xsl:when test="($term = 'Copy')">Exemplaire</xsl:when>
			<xsl:when test="($term = 'Creation')">Date de création</xsl:when>
			<xsl:when test="($term = 'CustodialHistory')">Historique de conservation</xsl:when>
			<xsl:when test="($term = 'CustodialHistoryItem')">Evénement</xsl:when>
			<xsl:when test="($term = 'Data')">Données binaires</xsl:when>
			<xsl:when test="($term = 'Description')">Description</xsl:when>
			<xsl:when test="($term = 'DescriptionLanguage')">Langue de la description</xsl:when>
			<xsl:when test="($term = 'DescriptionLevel')">Niveau de description</xsl:when>
			<xsl:when test="($term = 'Document')">Document</xsl:when>
			<xsl:when test="($term = 'Duration')">Durée d'utilité Administrative</xsl:when>
			<xsl:when test="($term = 'FilePlanPosition')">Position dans le plan de classement</xsl:when>
			<xsl:when test="($term = 'Integrity')">Empreinte</xsl:when>
			<xsl:when test="($term = 'Issue')">Date d'émission</xsl:when>
			<xsl:when test="($term = 'KeywordContent')">Mot-clé</xsl:when>
			<xsl:when test="($term = 'KeywordReference')">Identifiant dans le référentiel associé</xsl:when>
			<xsl:when test="($term = 'KeywordType')">Type</xsl:when>
			<xsl:when test="($term = 'Language')">Langue du contenu</xsl:when>
			<xsl:when test="($term = 'LatestDate')">Date de fin</xsl:when>
			<xsl:when test="($term = 'Name')">Nom</xsl:when>
			<xsl:when test="($term = 'OldestDate')">Date de début</xsl:when>
			<xsl:when test="($term = 'OriginatingAgency')">Service producteur</xsl:when>
			<xsl:when test="($term = 'OriginatingAgencyArchiveIdentifier')">Identifiant service producteur</xsl:when>
			<xsl:when test="($term = 'OriginatingAgencyDocumentIdentifier')">Identifiant service producteur</xsl:when>
			<xsl:when test="($term = 'OriginatingAgencyObjectIdentifier')">Identifiant service producteur</xsl:when>
			<xsl:when test="($term = 'OtherDescriptiveData')">Autres informations</xsl:when>
			<xsl:when test="($term = 'OtherMetadata')">Autres métadonnées</xsl:when>
			<xsl:when test="($term = 'Purpose')">Objet</xsl:when>
			<xsl:when test="($term = 'Receipt')">Date de réception</xsl:when>
			<xsl:when test="($term = 'RelatedData')">Données liées</xsl:when>
			<xsl:when test="($term = 'RelatedObjectIdentifier')">Identifiant</xsl:when>
			<xsl:when test="($term = 'RelatedObjectReference')">Référence complémentaire</xsl:when>
			<xsl:when test="($term = 'Relation')">Nature de la relation</xsl:when>
			<xsl:when test="($term = 'Repository')">Service d'archives</xsl:when>
			<xsl:when test="($term = 'Response')">Date de réponse</xsl:when>
			<xsl:when test="($term = 'ServiceLevel')">Niveau de service demandé</xsl:when>
			<xsl:when test="($term = 'Size')">Taille</xsl:when>
			<xsl:when test="($term = 'StartDate')">Date de départ du calcul</xsl:when>
			<xsl:when test="($term = 'Status')">Etat</xsl:when>
			<xsl:when test="($term = 'Submission')">Date de soumission</xsl:when>
			<xsl:when test="($term = 'TransferringAgencyArchiveIdentifier')">Identifiant service versant</xsl:when>
			<xsl:when test="($term = 'TransferringAgencyDocumentIdentifier')">Identifiant service versant</xsl:when>
			<xsl:when test="($term = 'TransferringAgencyObjectIdentifier')">Identifiant service versant</xsl:when>
			<xsl:when test="($term = 'Type')">Type</xsl:when>
			<!-- schema Organization -->
			<xsl:when test="($term = 'Address')">Adresse</xsl:when>
			<xsl:when test="($term = 'BlockName')">Quartier</xsl:when>
			<xsl:when test="($term = 'BuildingName')">Bâtiment</xsl:when>
			<xsl:when test="($term = 'BuildingNumber')">Numéro</xsl:when>
			<xsl:when test="($term = 'BusinessType')">Code de l'activité</xsl:when>
			<xsl:when test="($term = 'Channel')">Type/Outil de communication</xsl:when>
			<xsl:when test="($term = 'CityName')">Localité</xsl:when>
			<xsl:when test="($term = 'CitySub-DivisionName')">Arrondissement / quartier</xsl:when>
			<xsl:when test="($term = 'Communication')">Moyen de communication</xsl:when>
			<xsl:when test="($term = 'CompleteNumber')">Numéro</xsl:when>
			<xsl:when test="($term = 'Contact')">Contact</xsl:when>
			<xsl:when test="($term = 'Country')">Pays</xsl:when>
			<xsl:when test="($term = 'Contact/DepartmentName')">Service</xsl:when>
			<xsl:when test="($term = 'FloorIdentification')">Etage</xsl:when>
			<xsl:when test="($term = 'Identification')">Identifiant</xsl:when>
			<xsl:when test="($term = 'LegalClassification')">Code de la catégorie juridique</xsl:when>
			<xsl:when test="($term = 'PersonName')">Nom</xsl:when>
			<xsl:when test="($term = 'PostOfficeBox')">Boite postale</xsl:when>
			<xsl:when test="($term = 'Postcode')">Code postal</xsl:when>
			<xsl:when test="($term = 'Responsibility')">Attributions</xsl:when>
			<xsl:when test="($term = 'RoomIdentification')">Pièce</xsl:when>
			<xsl:when test="($term = 'StreetName')">Voie</xsl:when>
			<xsl:when test="($term = 'URIID')">Identifiant</xsl:when>

			<xsl:when test="($term = 'AccessRestrictionRule/Code')">Délai de communicabilité</xsl:when>
			<xsl:when test="($term = 'AppraisalRule/Code')">Sort final</xsl:when>
			<xsl:when test="($term = 'Keywords')">Indexation</xsl:when>

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
