<?xml version="1.0" encoding="ISO-8859-1" ?>
<!--
	SEDA v0.2 XSLT display HTML
-->

<xsl:stylesheet version="1.0"
		xmlns:seda="fr:gouv:ae:archive:draft:standard_echange_v0.2"
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
body             { font-size: small; color:#4B4B4B; background-color: #FFFFCC;}
fieldset         { border: 1px solid blue;}
legend           { color: blue; font-weight: bold; padding: 2px 6px }
h2               { color: blue; text-align:center;}
h4               { margin: 0px; padding: 0.1em;}
label            { font-weight: bold; }
code             { display: block; padding: 0.8em; margin: 0.8em; background-color: lightgrey; }
div.Archive      { display: block; padding: 0.8em; border: dotted 1px blue; background-color: #EEEEFF; }
div.Contains     { display: none; padding: 0.6em; border: dotted 1px grey; }
div.Document     { display: none; padding: 0.4em; border: dotted 1px red; background-color: #DDCCFF; }
div.TransferringAgency, div.OriginatingAgency, div.ArchivalAgency, div.Requester { display: block; padding: 0.8em; margin: 0.8em; border: dotted 1px blue; }
div.Address, div.Contact { display: block; padding: 0.8em; margin: 0.8em; border: dotted 1px blue; }
div.code-value   { padding-left: 2.0em; }
li.nonexpandable { margin: 0px; padding: 0px; list-style: none; }
li.expandable    { margin: 0px; padding: 0px; list-style-image: url("http://www.archivesdefrance.culture.gouv.fr/seda/xslt/pics/file-open.png"); }
li.expanded      { margin: 0px; padding: 0px; list-style-image: url("http://www.archivesdefrance.culture.gouv.fr/seda/xslt/pics/folder.png"); }
a.info           { text-decoration: none; position:relative; z-index:10; }
a.info:before    { padding-right: 0.3em; content: url("http://www.archivesdefrance.culture.gouv.fr/seda/xslt/pics/ico-loupe.gif"); }
a.info:hover     { z-index:20; }
a.info > span    { display:none; }
a.info:hover > span { display:block; position:absolute; top:18px; left:10px; padding-left:5px; padding-top:2px; padding-bottom:2px; padding-right:5px; font-family:'Courier', monospace; font-weight:normal; font-size:8px; color:#777777; text-decoration:none; width:450px; text-align:left; background-color: lightblue; white-space:normal; }
a.info:hover > span > span { display:block; }
.info-generales  { text-align:center; }
.acteurs         { display:table; width: 100%; border-spacing: 30pt 2pt; table-layout: fixed; }
.acteur          { display:table-cell; vertical-align :top; }
#commands        { text-align: right; }
.Archive-name:before { padding-right: 0.3em; content: url("http://www.archivesdefrance.culture.gouv.fr/seda/xslt/pics/folder.png"); }
.Document-name, .Archive-name, .Contains-name {	 font-weight: bold; }
.ContentDescription { display: block; background-color: #CCCCFF;	 border: dotted 1px blue; padding: 0.8em; margin: 0.8em; }
.detail          { display : none; padding: 1.0em; border: dotted 1px blue; }
span.titre       { border: outset 3px blue; background-color: lightgrey; padding-right:4pt; }
.titre a         { text-decoration: none; font-size: large ; xcolor: black; }
.titre img       { border: none; }
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
		if ( (childs.item(i).className == "Contains") 
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
				<xsl:apply-templates select="seda:Integrity"/>
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
				<xsl:apply-templates select="seda:Contains"/>
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
	<xsl:template match="seda:ArchiveTransferAcceptance">
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
					<xsl:apply-templates select="seda:ReplyCode"/>
					<xsl:apply-templates select="seda:TransferAcceptanceIdentifier"/>
					<xsl:apply-templates select="seda:TransferIdentifier"/>
				</div>
				<div class="acteurs">
					<div class="acteur"><xsl:apply-templates select="seda:TransferringAgency"/></div>
					<div class="acteur"><xsl:apply-templates select="seda:ArchivalAgency"/></div>
				</div>
				<xsl:apply-templates select="seda:Approval"/>
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
	<xsl:template match="seda:ArchiveTransferReplyAcknowledgement">
		<h2>
			Message de <xsl:call-template name="traduction"><xsl:with-param name="term" select="local-name()"/></xsl:call-template>
			<xsl:text> </xsl:text><xsl:apply-templates select="@*"/>
		</h2>
                <xsl:apply-templates select="seda:Comment"/>
                <xsl:apply-templates select="seda:Date"/>
                <xsl:apply-templates select="seda:ReplyCode"/>
                <xsl:apply-templates select="seda:TransferReplyAcknowledgementIdentifier"/>
                <xsl:apply-templates select="seda:TransferReplyIdentifier"/>
                <xsl:apply-templates select="seda:TransferringAgency"/>
                <xsl:apply-templates select="seda:ArchivalAgency"/>
	</xsl:template>

<!--
************************************
**** Les messages de Communication
************************************
-->
	<xsl:template match="seda:ArchiveDelivery">
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
					<xsl:apply-templates select="seda:DeliveryAuthorizationIdentifier"/>
					<xsl:apply-templates select="seda:DeliveryIdentifier"/>
					<xsl:apply-templates select="seda:DeliveryRequestIdentifier"/>
					<xsl:apply-templates select="seda:UnitIdentifier"/>
				</div>
				<div class="acteurs">
					<div class="acteur"><xsl:apply-templates select="seda:Requester"/></div>
					<div class="acteur"><xsl:apply-templates select="seda:ArchivalAgency"/></div>
				</div>
				<xsl:apply-templates select="seda:Signature"/>
				<xsl:apply-templates select="seda:HashCode"/>
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
	<xsl:template match="seda:ArchiveDeliveryRequest">
		<h2>
			Message de <xsl:call-template name="traduction"><xsl:with-param name="term" select="local-name()"/></xsl:call-template>
			<xsl:text> </xsl:text><xsl:apply-templates select="@*"/>
		</h2>
		<xsl:apply-templates select="seda:Comment"/>
		<xsl:apply-templates select="seda:Date"/>
		<xsl:apply-templates select="seda:DeliveryRequestIdentifier"/>
		<xsl:apply-templates select="seda:Derogation"/>
		<xsl:apply-templates select="seda:UnitIdentifier"/>
		<xsl:apply-templates select="seda:AccessRequester"/>
		<xsl:apply-templates select="seda:ArchivalAgency"/>
		<xsl:apply-templates select="seda:Authentication"/>
	</xsl:template>
	<xsl:template match="seda:ArchiveDeliveryRequestReply">
		<h2>
			Message de <xsl:call-template name="traduction"><xsl:with-param name="term" select="local-name()"/></xsl:call-template>
			<xsl:text> </xsl:text><xsl:apply-templates select="@*"/>
		</h2>
		<xsl:apply-templates select="seda:Comment"/>
		<xsl:apply-templates select="seda:Date"/>
		<xsl:apply-templates select="seda:DeliveryRequestIdentifier"/>
		<xsl:apply-templates select="seda:DeliveryRequestReplyIdentifier"/>
		<xsl:apply-templates select="seda:ReplyCode"/>
		<xsl:apply-templates select="seda:UnitIdentifier"/>
		<xsl:apply-templates select="seda:AccessRequester"/>
		<xsl:apply-templates select="seda:ArchivalAgency"/>
		<xsl:apply-templates select="seda:Authentication"/>
	</xsl:template>
	<xsl:template match="seda:ArchiveDeliveryAuthorizationRequest">
		<h2>
			Message de <xsl:call-template name="traduction"><xsl:with-param name="term" select="local-name()"/></xsl:call-template>
			<xsl:text> </xsl:text><xsl:apply-templates select="@*"/>
		</h2>
		<xsl:apply-templates select="seda:Comment"/>
		<xsl:apply-templates select="seda:Date"/>
		<xsl:apply-templates select="seda:DeliveryAuthorizationRequestIdentifier"/>
		<xsl:apply-templates select="seda:ArchiveDeliveryRequestIdentifier"/>
		<xsl:apply-templates select="seda:UnitIdentifier"/>
		<xsl:apply-templates select="seda:ArchivalAgency"/>
		<xsl:apply-templates select="seda:ControlAuthority"/>
		<xsl:apply-templates select="seda:Requester"/>
		<xsl:apply-templates select="seda:OriginatingAgency"/>
		<xsl:apply-templates select="seda:Authentication"/>
		<xsl:apply-templates select="seda:Archive"/>
	</xsl:template>
	<xsl:template match="seda:ArchiveDeliveryAuthorizationRequestReply">
		<h2>
			Message de <xsl:call-template name="traduction"><xsl:with-param name="term" select="local-name()"/></xsl:call-template>
			<xsl:text> </xsl:text><xsl:apply-templates select="@*"/>
		</h2>
		<xsl:apply-templates select="seda:Comment"/>
		<xsl:apply-templates select="seda:Date"/>
		<xsl:apply-templates select="seda:DeliveryAuthorizationRequestIdentifier"/>
		<xsl:apply-templates select="seda:DeliveryAuthorizationRequestReplyIdentifier"/>
		<xsl:apply-templates select="seda:ReplyCode"/>
		<xsl:apply-templates select="seda:UnitIdentifier"/>
		<xsl:apply-templates select="seda:ArchivalAgency"/>
		<xsl:apply-templates select="seda:ControlAuthority"/>
		<xsl:apply-templates select="seda:OriginatingAgency"/>
		<xsl:apply-templates select="seda:Authentication"/>
	</xsl:template>
	<xsl:template match="seda:ArchiveDeliveryAuthorizationRequestReplyAcknowledgement">
		<h2>
			Message de <xsl:call-template name="traduction"><xsl:with-param name="term" select="local-name()"/></xsl:call-template>
			<xsl:text> </xsl:text><xsl:apply-templates select="@*"/>
		</h2>
		<xsl:apply-templates select="seda:Comment"/>
		<xsl:apply-templates select="seda:Date"/>
		<xsl:apply-templates select="seda:DeliveryAuthorizationRequestReplyAcknowledgementIdentifier"/>
		<xsl:apply-templates select="seda:DeliveryAuthorizationRequestReplyIdentifier"/>
		<xsl:apply-templates select="seda:ReplyCode"/>
		<xsl:apply-templates select="seda:UnitIdentifier"/>
		<xsl:apply-templates select="seda:ArchivalAgency"/>
		<xsl:apply-templates select="seda:ControlAuthority"/>
		<xsl:apply-templates select="seda:OriginatingAgency"/>
		<xsl:apply-templates select="seda:NonRepudiation"/>
	</xsl:template>
	<xsl:template match="seda:ArchiveDeliveryAcknowledgement">
		<h2>
			Message de <xsl:call-template name="traduction"><xsl:with-param name="term" select="local-name()"/></xsl:call-template>
			<xsl:text> </xsl:text><xsl:apply-templates select="@*"/>
		</h2>
		<xsl:apply-templates select="seda:Comment"/>
		<xsl:apply-templates select="seda:Date"/>
		<xsl:apply-templates select="seda:DeliveryAcknowledgementIdentifier"/>
		<xsl:apply-templates select="seda:DeliveryIdentifier"/>
		<xsl:apply-templates select="seda:ReplyCode"/>
		<xsl:apply-templates select="seda:UnitIdentifier"/>
		<xsl:apply-templates select="seda:Requester"/>
		<xsl:apply-templates select="seda:ArchivalAgency"/>
		<xsl:apply-templates select="seda:Signature"/>
	</xsl:template>

<!-- Archive -->
	<xsl:template match="seda:Archive">
		<h2>
			<xsl:call-template name="traduction"><xsl:with-param name="term" select="local-name()"/></xsl:call-template>
		</h2>

		<xsl:call-template name="ArchiveObjectType"/>
	</xsl:template>

<!-- Archive -->
	<xsl:template match="seda:ArchiveDelivery/seda:Archive|seda:ArchiveTransfer/seda:Contains">
		<xsl:call-template name="ArchiveType"/>
	</xsl:template>	
		
<!-- Object d'archive  -->
	<xsl:template match="seda:Contains">
		<xsl:call-template name="ArchiveObjectType"/>
	</xsl:template>
	
<!-- Document -->
	<xsl:template match="seda:Document">
		<p onclick="toggle(event, this)" class="Document-name">
			Document
		</p>
		<div class="{local-name()}" onclick="toggle(event, this)">
                        <xsl:apply-templates select="@*"/>                      

                        <xsl:apply-templates select="seda:Control"/>
                        <xsl:apply-templates select="seda:Copy"/>
                        <xsl:apply-templates select="seda:Creation"/>
                        <xsl:apply-templates select="seda:Description"/>
                        <xsl:apply-templates select="seda:Identification"/>
                        <xsl:apply-templates select="seda:Issue"/>
                        <xsl:apply-templates select="seda:ItemIdentifier"/>
                        <xsl:apply-templates select="seda:Purpose"/>
                        <xsl:apply-templates select="seda:Receipt"/>
                        <xsl:apply-templates select="seda:Response"/>
                        <xsl:apply-templates select="seda:Status"/>
                        <xsl:apply-templates select="seda:Submission"/>
                        <xsl:apply-templates select="seda:Type"/>
                        <xsl:apply-templates select="seda:OtherMetadata"/>
			<xsl:apply-templates select="seda:Attachment"/>
		</div>
	</xsl:template>
	
<!-- Attachment -->
	<!-- on n'affiche pas le contenu qui peut être en base64Binary -->
	<xsl:template match="seda:Attachment">
		<div class="{local-name()}">
			<label><xsl:call-template name="traduction"><xsl:with-param name="term" select="local-name()"/></xsl:call-template>: </label>
                        <xsl:apply-templates select="@*"/>
		</div>
	</xsl:template>

<!-- Content description -->
	<xsl:template match="seda:ContentDescription">
		<div class="{local-name()}">
			<div class="collapsed-content">
				<!-- <label><xsl:call-template name="traduction"><xsl:with-param name="term" select="local-name()"/></xsl:call-template>: </label> -->
				<xsl:apply-templates select="seda:OriginatingAgency"/>
				<xsl:apply-templates select="seda:Repository"/>
				<xsl:apply-templates select="seda:CustodialHistory"/>
				<xsl:apply-templates select="seda:Description"/>
				<xsl:call-template name="dates_extremes"><xsl:with-param name="lang" select="'fr'"/></xsl:call-template>
				<xsl:apply-templates select="seda:FilePlanPosition"/>
				<xsl:apply-templates select="seda:OtherDescriptiveData"/>
				<xsl:apply-templates select="seda:RelatedObjectReference"/>
				<xsl:apply-templates select="seda:ContentDescriptive"/>
				<xsl:apply-templates select="seda:AccessRestriction"/>
				<xsl:apply-templates select="seda:Language"/>
				<xsl:apply-templates select="seda:Format"/>
				<xsl:apply-templates select="seda:Size"/>
				<xsl:apply-templates select="seda:OtherMetadata"/>
			</div>
		</div>
	</xsl:template>

<!-- Content Descriptive -->
	<xsl:template match="seda:ContentDescriptive[1]">
		<div class="{local-name()}">
			<label><xsl:call-template name="traduction"><xsl:with-param name="term">Keywords</xsl:with-param></xsl:call-template>: </label>
			<xsl:apply-templates select="@*"/>
			<div class="code-value">
				<xsl:apply-templates select="seda:KeywordContent"/>
				<div class="code-value">
					<xsl:apply-templates select="seda:KeywordReference"/>
					<xsl:apply-templates select="seda:KeywordType"/>
					<xsl:apply-templates select="seda:AccessRestriction"/>
				</div>
			</div>
		</div>
	</xsl:template>
	<xsl:template match="seda:ContentDescriptive">
		<div class="{local-name()}">
			<xsl:apply-templates select="@*"/>
			<div class="code-value">
				<xsl:apply-templates select="seda:KeywordContent"/>
				<div class="code-value">
					<xsl:apply-templates select="seda:KeywordReference"/>
					<xsl:apply-templates select="seda:KeywordType"/>
					<xsl:apply-templates select="seda:AccessRestriction"/>
				</div>
			</div>
		</div>
	</xsl:template>

<!-- Appraisal or AccessRestriction -->
	<xsl:template match="seda:AccessRestriction|seda:Appraisal">
		<xsl:call-template name="RulesType"/>
	</xsl:template>

<!-- Organisations (services d'archives, service versant, service producteur -->
	<xsl:template match="seda:TransferringAgency|seda:ArchivalAgency|seda:OriginatingAgency|seda:Requester">
		<xsl:call-template name="Organisation"/>
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

<!-- Communication -->
	<xsl:template match="seda:Communication">
		<div class="{local-name()}">
			<label><xsl:call-template name="traduction"><xsl:with-param name="term" select="local-name()"/></xsl:call-template>: </label>
			<div class="code-value">
				<xsl:apply-templates select="seda:Channel"/>
				<xsl:apply-templates select="seda:CompleteNumber"/>
				<xsl:apply-templates select="seda:URI"/>
			</div>
		</div>
	</xsl:template>

<!-- Signature -->
	<xsl:template match="seda:NonRepudiation|seda:Signature">
		<div class="{local-name()}">
			<label><xsl:call-template name="traduction"><xsl:with-param name="term" select="local-name()"/></xsl:call-template>: </label>
			<code>
				<xsl:call-template name="code"/>
			</code>
		</div>
	</xsl:template>	
	
<!-- Empreinte -->
	<xsl:template match="seda:Integrity|seda:HashCode">
		<div class="{local-name()}">
			<label><xsl:call-template name="traduction"><xsl:with-param name="term" select="local-name()"/></xsl:call-template>: </label>
			<div class="code-value">
				<xsl:call-template name="HashCodeType"/>
			</div>
		</div>
	</xsl:template>	
	<xsl:template name="HashCodeType">
		<xsl:apply-templates select="seda:UnitIdentifier"/>
		<xsl:apply-templates select="seda:Contains"/>
	</xsl:template>
	<xsl:template match="seda:HashCode/seda:UnitIdentifier|seda:Integrity/seda:UnitIdentifier" priority="2">
		<div>
			<label><xsl:call-template name="traduction"><xsl:with-param name="term" select="'Empreinte/UnitIdentifier'"/></xsl:call-template>: </label>
			<xsl:apply-templates select="@*"/>
			<xsl:apply-templates/>
		</div>
	</xsl:template>
	<xsl:template match="seda:HashCode/seda:Contains|seda:Integrity/seda:Contains">
		<div>
			<label><xsl:call-template name="traduction"><xsl:with-param name="term" select="'Empreinte/Contains'"/></xsl:call-template>: </label>
			<xsl:apply-templates select="@*"/>
			<xsl:apply-templates/>
		</div>
	</xsl:template>

<!-- Divers -->
	<xsl:template match="seda:Language[(. != '') or (@* !='')]
	|seda:ReplyCode[(. != '') or (@* !='')]
	|seda:Control[(. != '') or (@* !='')]
	|seda:Copy[(. != '') or (@* !='')]
	|seda:Format[(. != '') or (@* !='')]
	|seda:Size[(. != '') or (@* !='')]
	|seda:CustodialHistory[(. != '') or (@* !='')]
	|seda:Description[(. != '') or (@* !='')]
	|seda:FilePlanPosition[(. != '') or (@* !='')]
	|seda:OtherDescriptiveData[(. != '') or (@* !='')]
	|seda:RelatedObjectReference[(. != '') or (@* !='')]
	|seda:Repository[(. != '') or (@* !='')]
	|seda:BusinessType[(. != '') or (@* !='')]
	|seda:District[(. != '') or (@* !='')]
	|seda:Identification[(. != '') or (@* !='')]
	|seda:LegalClassification[(. != '') or (@* !='')]
	|seda:Name[(. != '') or (@* !='')]
	|seda:TaxRegistration[(. != '') or (@* !='')]
	|seda:PersonName[(. != '') or (@* !='')]
	|seda:Responsibility[(. != '') or (@* !='')]
	|seda:Type[(. != '') or (@* !='')]
	|seda:BlockName[(. != '') or (@* !='')]
	|seda:BuildingName[(. != '') or (@* !='')]
	|seda:BuildingNumber[(. != '') or (@* !='')]
	|seda:CityName[(. != '') or (@* !='')]
	|seda:CitySub-DivisionName[(. != '') or (@* !='')]
	|seda:Country[(. != '') or (@* !='')]
	|seda:FloorIdentification[(. != '') or (@* !='')]
	|seda:Postcode[(. != '') or (@* !='')]
	|seda:PostOfficeBox[(. != '') or (@* !='')]
	|seda:RoomIdentification[(. != '') or (@* !='')]
	|seda:StreetName[(. != '') or (@* !='')]
	|seda:Date[(. != '') or (@* !='')]
	|seda:LatestDate[(. != '') or (@* !='')]
	|seda:OldestDate[(. != '') or (@* !='')]
	|seda:StartDate[(. != '') or (@* !='')]
	|seda:Comment[(. != '') or (@* !='')]
	|seda:DeliveryAuthorizationIdentifier[(. != '') or (@* !='')]
	|seda:DeliveryIdentifier[(. != '') or (@* !='')]
	|seda:DeliveryRequestIdentifier[(. != '') or (@* !='')]
	|seda:UnitIdentifier[(. != '') or (@* !='')]
	|seda:ArchivalAgencyArchiveIdentifier[(. != '') or (@* !='')]
	|seda:ArchivalAgreement[(. != '') or (@* !='')]
	|seda:ArchivalProfile[(. != '') or (@* !='')]
	|seda:DescriptionLanguage[(. != '') or (@* !='')]
	|seda:DescriptionLevel[(. != '') or (@* !='')]
	|seda:ServiceLevel[(. != '') or (@* !='')]
	|seda:TransferringAgencyArchiveIdentifier[(. != '') or (@* !='')]
	|seda:PKCS7Signature[(. != '') or (@* !='')]
	|seda:RelatedTransferReference[(. != '') or (@* !='')]
	|seda:TransferIdentifier[(. != '') or (@* !='')]
	|seda:TransferReplyIdentifier[(. != '') or (@* !='')]
	|seda:TransferAcceptanceIdentifier[(. != '') or (@* !='')]
	|seda:TransferRequestReplyIdentifier[(. != '') or (@* !='')]
	|seda:TransferringAgencyObjectIdentifier[(. != '') or (@* !='')]
	|seda:ArchivalAgencyObjectIdentifier[(. != '') or (@* !='')]
	|seda:KeywordContent[(. != '') or (@* !='')]
	|seda:KeywordReference[(. != '') or (@* !='')]
	|seda:KeywordType[(. != '') or (@* !='')]
	|seda:Creation[(. != '') or (@* !='')]
	|seda:Issue[(. != '') or (@* !='')]
	|seda:ItemIdentifier[(. != '') or (@* !='')]
	|seda:Purpose[(. != '') or (@* !='')]
	|seda:Receipt[(. != '') or (@* !='')]
	|seda:Response[(. != '') or (@* !='')]
	|seda:Duration[(. != '') or (@* !='')]
	|seda:Status[(. != '') or (@* !='')]
	|seda:Submission[(. != '') or (@* !='')]">
		<div class="{local-name()}">
			<label><xsl:call-template name="traduction"><xsl:with-param name="term" select="local-name()"/></xsl:call-template>: </label>
			<xsl:apply-templates select="@*"/>
			<xsl:apply-templates/>
		</div>
	</xsl:template>

<!-- cas particuliers -->

	<xsl:template match="seda:Appraisal/seda:Code[(. != '') or (@* !='')]">
		<div class="{local-name()}">
			<label><xsl:call-template name="traduction">
				<xsl:with-param name="term">Appraisal/Code</xsl:with-param>
			</xsl:call-template>: </label>
			<xsl:apply-templates select="@*"/>
			<xsl:apply-templates/>
		</div>
	</xsl:template>
	<xsl:template match="seda:AccessRestriction/seda:Code[(. != '') or (@* !='')]">
		<div class="{local-name()}">
			<label><xsl:call-template name="traduction">
				<xsl:with-param name="term">AccessRestriction/Code</xsl:with-param>
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
	<xsl:template match="seda:URI[(. != '') or (@* !='')]">
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

	<xsl:template match="seda:ReplyCode[@listVersionID='edition 2009']/text()">
		<xsl:variable name="value" select="."/>
		<xsl:variable name="table">codes/archives_echanges_v0-2_reply_code.xsd</xsl:variable>
		<xsl:value-of select="document($table)//xsd:enumeration[@value=$value]//xsd:annotation/xsd:documentation/ccts:Name"/>
	</xsl:template>
	<xsl:template match="seda:DescriptionLevel[@listVersionID='edition 2009']/text()">
		<xsl:variable name="value" select="."/>
		<xsl:variable name="table">codes/archives_echanges_v0-2_descriptionlevel_code.xsd</xsl:variable>
		<xsl:value-of select="document($table)//xsd:enumeration[@value=$value]//xsd:annotation/xsd:documentation/ccts:Name"/>
	</xsl:template>
	<xsl:template match="seda:Type[@listVersionID='edition 2009']/text()">
		<xsl:variable name="value" select="."/>
		<xsl:variable name="table">codes/archives_echanges_v0-2_documenttype_code.xsd</xsl:variable>
		<xsl:value-of select="document($table)//xsd:enumeration[@value=$value]//xsd:annotation/xsd:documentation[@xml:lang='fr']/ccts:Name"/>
	</xsl:template>
	<xsl:template match="seda:DescriptionLanguage[@listVersionID='edition 2009']/text()|seda:Language[@listVersionID='edition 2009']/text()">
		<xsl:variable name="value" select="."/>
		<xsl:variable name="table">codes/archives_echanges_v0-2_language_code.xsd</xsl:variable>
		<xsl:value-of select="document($table)//xsd:enumeration[@value=$value]//xsd:annotation/xsd:documentation[@xml:lang='fr']/ccts:Name"/>
	</xsl:template>
	<xsl:template match="seda:Appraisal/seda:Code[@listVersionID='edition 2009']/text()">
		<xsl:variable name="value" select="."/>
		<xsl:variable name="table">codes/archives_echanges_v0-2_appraisal_code.xsd</xsl:variable>
		<xsl:value-of select="document($table)//xsd:enumeration[@value=$value]//xsd:annotation/xsd:documentation/ccts:Name"/>
	</xsl:template>
	<xsl:template match="seda:Size[@unitCode!='']/text()">
		<xsl:variable name="value"><xsl:value-of select="../@unitCode"/></xsl:variable>
		<xsl:variable name="table">codes/UNECE_MeasurementUnitCommonCode_5.xsd</xsl:variable>
		<xsl:value-of select="."/> 
		<xsl:value-of select="document($table)//xsd:enumeration[@value=$value]//xsd:annotation/xsd:documentation"/>
	</xsl:template>
	<xsl:template match="seda:Country[@listVersionID='second edition 2006']/text()">
		<xsl:variable name="value" select="."/>
		<xsl:variable name="table">codes/ISO_ISOTwoletterCountryCode_SecondEdition2006VI-3.xsd</xsl:variable>
		<xsl:value-of select="document($table)//xsd:enumeration[@value=$value]//xsd:annotation/xsd:documentation/ccts:Name"/>
	</xsl:template>
	<xsl:template match="seda:AccessRestriction/seda:Code[@listVersionID='edition 2009']/text()">
		<xsl:variable name="value" select="."/>
		<xsl:variable name="table">codes/archives_echanges_v0-2_accessrestriction_code.xsd</xsl:variable>
		<xsl:variable name="meta"><xsl:value-of select="document($table)//xsd:enumeration[@value=$value]//xsd:annotation/xsd:documentation/ccts:Name"/></xsl:variable>
		<xsl:choose>
			<xsl:when test="$meta='0 an'">Immédiat</xsl:when>
			<xsl:otherwise><xsl:value-of select="$meta"/></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template match="seda:KeywordType[@listVersionID='edition 2009']/text()">
		<xsl:variable name="value" select="."/>
		<xsl:variable name="table">codes/archives_echanges_v0-2_keywordtype_code.xsd</xsl:variable>
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


	<xsl:template name="Organisation">
		<xsl:variable name="myid" select="generate-id()"/>
		<fieldset class="{local-name()}">
			<legend onclick="mytoggle('{$myid}')"><xsl:call-template name="traduction"><xsl:with-param name="term" select="local-name()"/></xsl:call-template></legend>
			<div id="{$myid}">
				<xsl:apply-templates select="seda:BusinessType"/>
				<xsl:apply-templates select="seda:Description"/>
				<xsl:apply-templates select="seda:District"/>
				<xsl:apply-templates select="seda:Identification"/>
				<xsl:apply-templates select="seda:LegalClassification"/>
				<xsl:apply-templates select="seda:Name"/>
				<xsl:apply-templates select="seda:TaxRegistration"/>
				<xsl:apply-templates select="seda:Contact"/>
				<xsl:apply-templates select="seda:Address"/>
				<xsl:apply-templates select="seda:Communication"/>
			</div>
		</fieldset>
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

	<xsl:template name="ArchiveType">
		<div>
			<p class="Archive-name">
				<xsl:call-template name="name">
					<xsl:with-param name="nom" select="seda:Name"/>
				</xsl:call-template>
			</p>
			<div>
				<xsl:apply-templates select="@*"/>

				<xsl:apply-templates select="seda:ArchivalAgencyArchiveIdentifier"/>
				<xsl:apply-templates select="seda:ArchivalAgreement"/>
				<xsl:apply-templates select="seda:ArchivalProfile"/>
				<xsl:apply-templates select="seda:DescriptionLanguage"/>
				<xsl:apply-templates select="seda:DescriptionLevel"/>
				<xsl:apply-templates select="seda:ServiceLevel"/>
				<xsl:apply-templates select="seda:TransferringAgencyArchiveIdentifier"/>
				<xsl:apply-templates select="seda:Appraisal"/>
				<xsl:apply-templates select="seda:AccessRestriction"/>

				<xsl:apply-templates select="seda:ContentDescription"/>
				<xsl:if test="seda:Contains">
					<ul>
						<xsl:for-each select="seda:Contains">
							<xsl:sort select="seda:Name"/>
							<li class="expandable" onclick="toggle(event, this)">
								<xsl:apply-templates select="."/>
							</li>
						</xsl:for-each>
					</ul>
				</xsl:if>
				<xsl:if test="seda:Document">
					<ul>
						<xsl:for-each select="seda:Document">
							<xsl:sort select="seda:Name"/>
							<li class="expandable" onclick="toggle(event, this)">
								<xsl:apply-templates select="."/>
							</li>
						</xsl:for-each>
					</ul>
				</xsl:if>
			</div>
		</div>
	</xsl:template>	
	
	<xsl:template name="ArchiveObjectType">
		<p class="{local-name()}-name" onclick="toggle(event, this)">
			<xsl:call-template name="name">
				<xsl:with-param name="nom" select="seda:Name"/>
			</xsl:call-template>
		</p>
		<div class="{local-name()}" onclick="toggle(event, this)">
			<xsl:apply-templates select="@*"/>
			<xsl:apply-templates select="seda:ArchivalAgencyObjectIdentifier"/>
			<xsl:apply-templates select="seda:DescriptionLevel"/>
			<xsl:apply-templates select="seda:TransferringAgencyObjectIdentifier"/>
			<xsl:apply-templates select="seda:Appraisal"/>
			<xsl:apply-templates select="seda:AccessRestriction"/>
			
			<xsl:apply-templates select="seda:ContentDescription"/>
			<xsl:if test="seda:Contains">
				<ul>
					<xsl:for-each select="seda:Contains">
						<xsl:sort select="seda:Name"/>
						<li class="expandable" onclick="toggle(event, this)">
							<xsl:apply-templates select="."/>
						</li>
					</xsl:for-each>
				</ul>
			</xsl:if>
			<xsl:if test="seda:Document">
				<ul>
					<xsl:for-each select="seda:Document">
						<xsl:sort select="seda:Name"/>
						<li class="expandable" onclick="toggle(event, this)">
							<xsl:apply-templates select="."/>
						</li>
					</xsl:for-each>
				</ul>
			</xsl:if>
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
			<xsl:when test="($term = 'ReplyCode')">Code retour</xsl:when>
			<xsl:when test="($term = 'Attachment')">Pièce jointe</xsl:when>
			<xsl:when test="($term = 'NonRepudiation')">Signature</xsl:when>
			<xsl:when test="($term = 'Integrity')">Empreinte</xsl:when>
			<xsl:when test="($term = 'Empreinte/Contains')">Valeur</xsl:when>
			<xsl:when test="($term = 'Channel')">Canal</xsl:when>
			<xsl:when test="($term = 'CompleteNumber')">Numéro</xsl:when>
			<xsl:when test="($term = 'URI')"></xsl:when>
			<xsl:when test="($term = 'Name')">Nom</xsl:when>
			<xsl:when test="($term = 'ArchiveDelivery')">Communication</xsl:when>
			<xsl:when test="($term = 'ArchiveTransfer')">Transfert</xsl:when>
			<xsl:when test="($term = 'Address')">Adresse</xsl:when>
			<xsl:when test="($term = 'Contact')">Contact</xsl:when>
			<xsl:when test="($term = 'Requester')">Demandeur d'archives</xsl:when>
			<xsl:when test="($term = 'TransferringAgency')">Service versant</xsl:when>
			<xsl:when test="($term = 'ArchivalAgency')">Service d'archives</xsl:when>
			<xsl:when test="($term = 'OriginatingAgency')">Service producteur</xsl:when>
			<xsl:when test="($term = 'AccessRestriction')">Restriction d'accès</xsl:when>
			<xsl:when test="($term = 'AccessRestriction/Code')">Délai de communicabilité</xsl:when>
			<xsl:when test="($term = 'Appraisal/Code')">Sort final</xsl:when>
			<xsl:when test="($term = 'ArchivalAgreement')">Convention</xsl:when>
			<xsl:when test="($term = 'ArchivalProfile')">Profil</xsl:when>
			<xsl:when test="($term = 'Comment')">Commentaire</xsl:when>
			<xsl:when test="($term = 'Creation')">Date de création</xsl:when>
			<xsl:when test="($term = 'CustodialHistory')">Historique</xsl:when>
			<xsl:when test="($term = 'DescriptionLanguage')">Langue de la description</xsl:when>
			<xsl:when test="($term = 'Issue')">Date d'émission</xsl:when>
			<xsl:when test="($term = 'LatestDate')">Date de fin</xsl:when>
			<xsl:when test="($term = 'Language')">Langue du contenu</xsl:when>
			<xsl:when test="($term = 'Purpose')">Objet</xsl:when>
			<xsl:when test="($term = 'Receipt')">Date de réception</xsl:when>
			<xsl:when test="($term = 'Size')">Taille</xsl:when>
			<xsl:when test="($term = 'StartDate')">Date de départ du calcul</xsl:when>
			<xsl:when test="($term = 'Submission')">Date de soumission</xsl:when>
			<xsl:when test="($term = 'Status')">Etat</xsl:when>
			<xsl:when test="($term = 'Control')">Présence d'exigences de contrôle</xsl:when>
			<xsl:when test="($term = 'Country')">Pays</xsl:when>
			<xsl:when test="($term = 'FilePlanPosition')">Position dans le plan de classement</xsl:when>
			<xsl:when test="($term = 'Identification')">Identifiant</xsl:when>
			<xsl:when test="($term = 'OldestDate')">Date de début</xsl:when>
			<xsl:when test="($term = 'Type')">Type</xsl:when>
			<xsl:when test="($term = 'OtherDescriptiveData')">Autres informations</xsl:when>
			<xsl:when test="($term = 'RelatedTransferReference')">Référence à un autre transfert</xsl:when>
			<xsl:when test="($term = 'ServiceLevel')">Niveau de service demandé</xsl:when>
			<xsl:when test="($term = 'TransferIdentifier')">Identifiant du transfert</xsl:when>
			<xsl:when test="($term = 'TransferAcceptanceIdentifier')">Identifiant d'acceptation du transfert</xsl:when>
			<xsl:when test="($term = 'TransferReplyIdentifier')">Identifiant de la réponse au transfert</xsl:when>
			<xsl:when test="($term = 'Description')">Description</xsl:when>
			<xsl:when test="($term = 'Format')">Format</xsl:when>
			<xsl:when test="($term = 'Response')">Date de réponse</xsl:when>
			<xsl:when test="($term = 'Appraisal')">Règle de conservation</xsl:when>
			<xsl:when test="($term = 'Copy')">Exemplaire</xsl:when>
			<xsl:when test="($term = 'KeywordContent')">Mot-clé</xsl:when>
			<xsl:when test="($term = 'Keywords')">Indexation</xsl:when>
			<xsl:when test="($term = 'ArchivalAgencyArchiveIdentifier')">Cote service d'archive</xsl:when>
			<xsl:when test="($term = 'ArchivalAgencyObjectIdentifier')">Cote article service d'archive</xsl:when>
			<xsl:when test="($term = 'TransferringAgencyArchiveIdentifier')">Identifiant service versant</xsl:when>
			<xsl:when test="($term = 'TransferringAgencyObjectIdentifier')">Identifiant d'origine</xsl:when>
			<xsl:when test="($term = 'BlockName')">Quartier</xsl:when>
			<xsl:when test="($term = 'BuildingName')">Bâtiment</xsl:when>
			<xsl:when test="($term = 'BuildingNumber')">Numéro</xsl:when>
			<xsl:when test="($term = 'CityName')">Localité</xsl:when>
			<xsl:when test="($term = 'CitySub-DivisionName')">Arrondissement / quartier</xsl:when>
			<xsl:when test="($term = 'Code')">Code</xsl:when>
			<xsl:when test="($term = 'BusinessType')">Code de l'activité</xsl:when>
			<xsl:when test="($term = 'DeliveryAuthorizationIdentifier')">Référence de la dérogation</xsl:when>
			<xsl:when test="($term = 'DeliveryIdentifier')">Référence de la communication</xsl:when>
			<xsl:when test="($term = 'DeliveryRequestIdentifier')">Référence de la demande</xsl:when>
			<xsl:when test="($term = 'Contact/DepartmentName')">Service</xsl:when>
			<xsl:when test="($term = 'DescriptionLevel')">Niveau de description</xsl:when>
			<xsl:when test="($term = 'District')">Ressort territorial</xsl:when>
			<xsl:when test="($term = 'FloorIdentification')">Etage</xsl:when>
			<xsl:when test="($term = 'KeywordReference')">Identifiant dans le référentiel associé</xsl:when>
			<xsl:when test="($term = 'KeywordType')">Type</xsl:when>
			<xsl:when test="($term = 'LegalClassification')">Code de la catégorie juridique</xsl:when>
			<xsl:when test="($term = 'PersonName')">Nom</xsl:when>
			<xsl:when test="($term = 'PostOfficeBox')">Boite postale</xsl:when>
			<xsl:when test="($term = 'Postcode')">Code postal</xsl:when>
			<xsl:when test="($term = 'RelatedObjectReference')">Référence complémentaire</xsl:when>
			<xsl:when test="($term = 'Repository')">Lieu de dépôt</xsl:when>
			<xsl:when test="($term = 'Responsibility')">Attributions</xsl:when>
			<xsl:when test="($term = 'RoomIdentification')">Pièce</xsl:when>
			<xsl:when test="($term = 'StreetName')">Voie</xsl:when>
			<xsl:when test="($term = 'TransferRequestReplyIdentifier')">Référence de la réponse à la demande de transfert</xsl:when>
			<xsl:when test="($term = 'ItemIdentifier')">Identifiant unique d'un élément particulier dans le document</xsl:when>
			<xsl:when test="($term = 'UnitIdentifier')">Cote de l'objet communiqué</xsl:when>
			<xsl:when test="($term = 'Empreinte/UnitIdentifier')">Fichier</xsl:when>
			<xsl:when test="($term = 'Date')">Date</xsl:when>
			<xsl:when test="($term = 'Duration')">Durée d'utilité administrative (DUA)</xsl:when>

			<xsl:otherwise><xsl:value-of select="$term"/></xsl:otherwise>
		</xsl:choose>
	</xsl:template>

</xsl:stylesheet>
