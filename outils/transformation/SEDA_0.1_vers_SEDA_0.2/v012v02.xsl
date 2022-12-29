<?xml version="1.0" encoding="ISO-8859-1"?>
<!--
	Transformations SEDA v0.1 vers SEDA v0.2
-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:seda1="fr:gouv:ae:archive:draft:standard_echange_v0.1" xmlns:seda2="fr:gouv:ae:archive:draft:standard_echange_v0.2" exclude-result-prefixes="seda1 seda2">
	
    <xsl:output method="xml" indent="yes" encoding="iso-8859-1"/>
    
    <xsl:strip-space elements="*"/>
    
<!-- ****************************** -->
<!-- *** les regles par défaut  *** -->
<!-- ****************************** -->
    <xsl:template match="*">
        <xsl:variable name="tag" select="name()"/>
        <xsl:variable name="ns" select="namespace-uri()"/>
        <xsl:element name="{$tag}" namespace="{$ns}">
            <xsl:for-each select="@*">
                <xsl:apply-templates select="."/>
            </xsl:for-each>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>
    <xsl:template match="text()">
        <xsl:copy-of select="."/>
    </xsl:template>
    <xsl:template match="processing-instruction()">
        <xsl:copy-of select="."/>
    </xsl:template>
    <xsl:template match="comment()">
        <xsl:copy-of select="."/>
    </xsl:template>
    <xsl:template match="@*">
        <xsl:if test="not(.='')"><xsl:copy-of select="."/></xsl:if>
    </xsl:template>


<!-- ****************************** -->
<!-- *** les regles spécifiques *** -->
<!-- ****************************** -->
    
<!-- changement du namespace -->
    <xsl:template match="seda1:*">
        <xsl:element name="{local-name(.)}" namespace="fr:gouv:ae:archive:draft:standard_echange_v0.2">
        	<xsl:apply-templates select="@*"/>
        	<xsl:apply-templates/>
        </xsl:element>
    </xsl:template>
    
<!-- changement de la précision des dates extrêmes et dates de départ de calculs -->
    <xsl:template match="seda1:LatestDate/text()|seda1:OldestDate/text()|seda1:StartDate/text()">
       	<xsl:value-of select="substring-before(., 'T')"/>
    </xsl:template>
    
<!-- supression de champs -->
    <xsl:template match="seda1:KeywordUnit"/>
    <xsl:template match="seda1:District"/>
    <xsl:template match="seda1:TaxRegistration"/>
    <xsl:template match="seda1:Address/seda1:DepartmentName"/>
    <xsl:template match="seda1:Address/seda1:Format"/>
    <xsl:template match="seda1:Address/seda1:Identification"/>
    <xsl:template match="seda1:Address/seda1:In-HouseMail"/>
    <xsl:template match="seda1:Address/seda1:LineOne"/>
    <xsl:template match="seda1:Address/seda1:LineTwo"/>
    <xsl:template match="seda1:Address/seda1:LineThree"/>
    <xsl:template match="seda1:Address/seda1:LineFour"/>
    <xsl:template match="seda1:Address/seda1:LineFive"/>
    <xsl:template match="seda1:Address/seda1:LineFive"/>
    <xsl:template match="seda1:Address/seda1:PlotIdentification"/>
    <xsl:template match="seda1:Address/seda1:Type"/>
    <xsl:template match="seda1:Contact/seda1:JobTitle"/>
    <xsl:template match="seda1:Document/seda1:MultipleType"/>
    <xsl:template match="seda1:Document/seda1:Name"/> <!-- pourquoi pas le passer dans un champs Descrition -->

<!-- supression d'attributs dans les codes et les identifiants -->
    <xsl:template match="seda1:*/@listAgencyID"/>
    <xsl:template match="seda1:*/@schemeAgencyID"/>

<!-- changement de nom de l'attribut URI -->
    <xsl:template match="@URI">
        	<xsl:attribute name="uri"><xsl:value-of select="."/></xsl:attribute>
    </xsl:template>

<!-- changement de cardinalité -->
    <xsl:template match="seda1:Contact[preceding-sibling::seda1:Contact]"/>
    <xsl:template match="seda1:BusinessType[preceding-sibling::seda1:BusinessType]"/>    
    <xsl:template match="seda1:OriginatingAgency/seda1:Description[preceding-sibling::seda1:Description]"/>
    <xsl:template match="seda1:Repository/seda1:Description[preceding-sibling::seda1:Description]"/>
    <xsl:template match="seda1:TransferringAgency/seda1:Description[preceding-sibling::seda1:Description]"/>
    <xsl:template match="seda1:ArchivalAgency/seda1:Description[preceding-sibling::seda1:Description]"/>
    <xsl:template match="seda1:Address/seda1:CitySub-DivisionName[preceding-sibling::seda1:CitySub-DivisionName]"/>
    <xsl:template match="seda1:Address/seda1:Postcode[preceding-sibling::seda1:Postcode]"/>
    <xsl:template match="seda1:Address/seda1:StreetName[preceding-sibling::seda1:StreetName]"/>
    <xsl:template match="seda1:Contact/seda1:Identification[preceding-sibling::seda1:Identification]"/>


<!-- lien des champs avec les tables de controle -->
    <xsl:template match="seda1:Language     | seda1:DescriptionLanguage     | seda1:DescriptionLevel     | seda1:ReplyCode     | seda1:Type     | seda1:KeywordType     | seda1:AccessRestriction/seda1:Code">
        <xsl:element name="{local-name(.)}" namespace="fr:gouv:ae:archive:draft:standard_echange_v0.2">
        	<xsl:attribute name="listVersionID">edition 2009</xsl:attribute>
        	<xsl:apply-templates/>
        </xsl:element>
    </xsl:template>

<!-- la table du sort final (separation du sort final et de la duree avant de l'appliquer) -->
    <xsl:template match="seda1:Appraisal/seda1:Code">
        <xsl:element name="Code" namespace="fr:gouv:ae:archive:draft:standard_echange_v0.2">
        	<xsl:attribute name="listVersionID">edition 2009</xsl:attribute>
        	<xsl:choose>	
        		<xsl:when test="contains(., 'C')">conserver</xsl:when>
        		<xsl:otherwise>detruire</xsl:otherwise>
        	</xsl:choose>
        </xsl:element>
        <xsl:element name="Duration" namespace="fr:gouv:ae:archive:draft:standard_echange_v0.2">
        	<xsl:text>P</xsl:text><xsl:value-of select="translate(., 'CD', '')"/><xsl:text>Y</xsl:text>
        </xsl:element>
    </xsl:template>

<!-- tables des pays -->
    <xsl:template match="seda1:Country">
        <xsl:element name="{local-name(.)}" namespace="fr:gouv:ae:archive:draft:standard_echange_v0.2">
        	<xsl:attribute name="listVersionID">second edition 2006</xsl:attribute>
        	<xsl:apply-templates/>
        </xsl:element>
    </xsl:template>
    
<!-- changement dans les regles de restriction d'acces -->
    <!-- la date est arbitrairement au 1er janvier 2000 -->
    <xsl:template match="seda1:KeywordAudience[.='external']|seda1:DescriptionAudience[.='external']">
            <AccessRestriction xmlns="fr:gouv:ae:archive:draft:standard_echange_v0.2">
                <Code listVersionID="edition 2009">AR038</Code>
                <StartDate>2000-01-01</StartDate>
            </AccessRestriction>
    </xsl:template>
    <!-- par precaution la categorie est illimitée -->
    <xsl:template match="seda1:KeywordAudience|seda1:DescriptionAudience">
            <AccessRestriction xmlns="fr:gouv:ae:archive:draft:standard_echange_v0.2">
                <Code listVersionID="edition 2009">AR062</Code>
                <StartDate>2000-01-01</StartDate>
            </AccessRestriction>
    </xsl:template>
  
<!-- reorganisation des elements de ContentDescription (en particulier les regles desort-final 
et de restrictions d'acces remontent aux archives et objet d'archives) -->
    <xsl:template match="seda1:ContentDescription">
            <ContentDescription xmlns="fr:gouv:ae:archive:draft:standard_echange_v0.2">
        	<xsl:apply-templates select="@*"/>
        	<xsl:apply-templates select="seda1:CustodialHistory"/>            
        	<xsl:apply-templates select="seda1:Description"/>            
        	<xsl:apply-templates select="seda1:FilePlanPosition"/>            
        	<xsl:apply-templates select="seda1:Format"/>            
        	<xsl:apply-templates select="seda1:Language"/>            
        	<xsl:apply-templates select="seda1:LatestDate"/>            
        	<xsl:apply-templates select="seda1:OldestDate"/>            
        	<xsl:apply-templates select="seda1:OtherDescriptiveData"/>            
        	<xsl:apply-templates select="seda1:RelatedObjectReference"/>            
        	<xsl:apply-templates select="seda1:Size"/>            
        	<xsl:apply-templates select="seda1:OriginatingAgency"/>            
        	<xsl:apply-templates select="seda1:epository"/>            
        	<xsl:apply-templates select="seda1:ContentDescriptive"/>            
		<!-- DescriptionAudience devient Accesrestriction -->         
		<xsl:apply-templates select="seda1:DescriptionAudience"/>
		<!-- les regles de Appraisal et de AccessRestriction remontent aux archives et objet d'archives  -->           
            </ContentDescription>
    </xsl:template>

<!-- reorganisation des elements d'archives et objet d'archives (en particulier les regles desort-final 
    et de restrictions d'acces sont pris dans ContentDescription) -->
    <xsl:template match="seda1:ArchiveTransfer/seda1:Contains">
	<Contains xmlns="fr:gouv:ae:archive:draft:standard_echange_v0.2">
	      	<xsl:apply-templates select="@*"/>
		<xsl:apply-templates select="seda1:ArchivalAgencyArchiveIdentifier"/>
		<xsl:apply-templates select="seda1:ArchivalAgreement"/>
		<xsl:apply-templates select="seda1:ArchivalProfile"/>
		<xsl:apply-templates select="seda1:DescriptionLanguage"/>
		<xsl:apply-templates select="seda1:DescriptionLevel"/>
		<xsl:apply-templates select="seda1:Name"/>
		<xsl:apply-templates select="seda1:ServiceLevel"/>
		<xsl:apply-templates select="seda1:TransferringAgencyArchiveIdentifier"/>
		<xsl:apply-templates select="seda1:ContentDescription"/>
		<!-- on va chercher les regles si elles existent -->
		<xsl:apply-templates select="seda1:ContentDescription/seda1:Appraisal"/>
		<xsl:apply-templates select="seda1:ContentDescription/seda1:AccessRestriction"/>
		<xsl:apply-templates select="seda1:Document"/>
		<xsl:apply-templates select="seda1:Contains"/>
	</Contains>
    </xsl:template>
    <xsl:template match="seda1:Contains">
	<Contains xmlns="fr:gouv:ae:archive:draft:standard_echange_v0.2">
	      	<xsl:apply-templates select="@*"/>
		<xsl:apply-templates select="seda1:ArchivalAgencyObjectIdentifier"/>
		<xsl:apply-templates select="seda1:DescriptionLevel"/>
		<xsl:apply-templates select="seda1:Name"/>
		<xsl:apply-templates select="seda1:TransferringAgencyObjectIdentifier"/>
		<xsl:apply-templates select="seda1:ContentDescription"/>
		<!-- on va chercher les regles si elles existent -->
		<xsl:apply-templates select="seda1:ContentDescription/seda1:Appraisal"/>
		<xsl:apply-templates select="seda1:ContentDescription/seda1:AccessRestriction"/>
		<xsl:apply-templates select="seda1:Document"/>
		<xsl:apply-templates select="seda1:Contains"/>
	</Contains>
    </xsl:template>
    
    <xsl:template match="seda1:Document">
    	<xsl:for-each select="seda1:Attachment">
		<Document xmlns="fr:gouv:ae:archive:draft:standard_echange_v0.2">
			<xsl:if test="(../@Id) and (position() = last()) and (position() = 1)">
        			<xsl:attribute name="Id"><xsl:value-of select="../@Id"/></xsl:attribute>
        		</xsl:if>
                        <xsl:apply-templates select="."/>
                        <xsl:apply-templates select="../seda1:Control"/>
                        <xsl:apply-templates select="../seda1:Copy"/>
                        <xsl:apply-templates select="../seda1:Creation"/>
                        <xsl:apply-templates select="../seda1:Description"/>
                        <xsl:apply-templates select="../seda1:Identification"/>
                        <xsl:apply-templates select="../seda1:Issue"/>
                        <xsl:apply-templates select="../seda1:ItemIdentifier"/>
                        <xsl:apply-templates select="../seda1:Purpose"/>
                        <xsl:apply-templates select="../seda1:Receipt"/>
                        <xsl:apply-templates select="../seda1:Response"/>
                        <xsl:apply-templates select="../seda1:Status"/>
                        <xsl:apply-templates select="../seda1:Submission"/>
                        <xsl:apply-templates select="../seda1:Type"/>
		</Document>
    	</xsl:for-each>
    </xsl:template>
</xsl:stylesheet>