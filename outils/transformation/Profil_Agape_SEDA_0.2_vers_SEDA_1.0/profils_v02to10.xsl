<?xml version="1.0" encoding="ISO-8859-1"?>

<!-- **************************************************************** -->
<!-- *** 2012-11-07: Ajout des attributs pour les nouveaux types  *** -->
<!-- **************************************************************** -->

<xsl:stylesheet version="1.0" 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
    xmlns:xsd="http://www.w3.org/2001/XMLSchema">
	
    <xsl:output method="xml" indent="yes" encoding="UTF-8"/>
    
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

    <!-- Changement de l'espace de nom -->
    <xsl:template match="xsd:schema/@targetNamespace">
        <xsl:attribute name="targetNamespace">fr:gouv:culture:archivesdefrance:seda:v1.0</xsl:attribute>
    </xsl:template>

    <xsl:template match="xsd:schema">
        <xsd:schema>
            <xsl:apply-templates select="@*"/>
            <xsl:apply-templates/>            
        </xsd:schema>
    </xsl:template>
    
    <xsl:template match="xsd:element">
        <xsd:element>
            <xsl:apply-templates select="@*"/>
            <xsl:apply-templates/>            
        </xsd:element>
    </xsl:template>
    
    <xsl:template match="xsd:attribute">
        <xsd:attribute>
            <xsl:apply-templates select="@*"/>
            <xsl:apply-templates/>            
        </xsd:attribute>
    </xsl:template>
    
    <xsl:template match="xsd:annotation">
        <xsd:annotation>
            <xsl:apply-templates select="@*"/>
            <xsl:apply-templates/>            
        </xsd:annotation>
    </xsl:template>

    <!-- supression d'elements -->
    <xsl:template match="xsd:element[@name='Format']"/>
    <xsl:template match="xsd:element[@name='ItemIdentifier']"/>
    
    <!-- Passe tous les attributs connus des elements sauf l'attribut name -->
    <xsl:template name="att-sauf-name">
        <xsl:apply-templates select="@minOccurs"/>
        <xsl:apply-templates select="@maxOccurs"/>
        <xsl:apply-templates select="@type"/>
        <xsl:apply-templates select="@fixed"/>
        <xsl:apply-templates select="@use"/>
    </xsl:template>
    <!-- Passe tous les attributs connus des elements sauf l'attribut type -->
    <xsl:template name="att-sauf-type">
        <xsl:apply-templates select="@minOccurs"/>
        <xsl:apply-templates select="@maxOccurs"/>
        <xsl:apply-templates select="@name"/>
        <xsl:apply-templates select="@fixed"/>
        <xsl:apply-templates select="@use"/>
    </xsl:template>
    
<!-- changement de nom d'elements -->
    <xsl:template match="xsd:element[@name='URI']">
        <xsd:element name="URIID">
            <xsl:call-template name="att-sauf-name"/>
             <xsl:apply-templates/>
        </xsd:element>
    </xsl:template>
    <xsl:template match="xsd:element[@name='Appraisal']">
        <xsd:element name="AppraisalRule">
            <xsl:call-template name="att-sauf-name"/>
            <xsl:apply-templates/>
        </xsd:element>
    </xsl:template>
    <xsl:template match="xsd:element[@name='AccessRestriction']">
        <xsd:element name="AccessRestrictionRule">
            <xsl:call-template name="att-sauf-name"/>
            <xsl:apply-templates/>
        </xsd:element>
    </xsl:template>
    
    <!-- Changements de types des elements  -->
    <xsl:template match="xsd:element[@name='CustodialHistory']">
        <xsd:element name="CustodialHistory" type="CustodialHistoryType">
            <xsl:apply-templates select="@minOccurs"/>
            <xsl:apply-templates select="@maxOccurs"/>
            <xsd:element name="CustodialHistoryItem" type="qdt:CustodialHistoryItemType"  minOccurs="1"  maxOccurs="1">
                <xsl:apply-templates select="@fixed"/>
                <xsl:apply-templates/>
                <xsd:attribute name="when" type="xsd:date" use="optional"/>
            </xsd:element>
            <xsd:attribute name="Id" type="xsd:ID" use="optional"/>
        </xsd:element>
    </xsl:template>
    <xsl:template match="xsd:element[@name='Channel']">
        <xsd:element name="Channel" type="qdt:ArchivesCommunicationChannelCodeType">
            <xsl:apply-templates select="@minOccurs"/>
            <xsl:apply-templates select="@maxOccurs"/>
            <!-- <xsl:apply-templates select="@fixed"/> On efface l'ancienne valeur causera en general une erreur a la validation -->
	    <!-- <xsl:apply-templates/> on perd les anciens attributs -->
            <xsd:attribute default="D10A" name="listVersionID" type="xsd:token" use="prohibited"/>
         </xsd:element>
    </xsl:template>
    <xsl:template match="xsd:element[@name='RelatedObjectReference']">
        <xsd:element name="RelatedObjectReference" type="RelatedObjectReferenceType">
            <xsl:apply-templates select="@minOccurs"/>
            <xsl:apply-templates select="@maxOccurs"/>
            <xsd:element name="RelatedObjectIdentifier" type="qdt:ArchivesIDType"  minOccurs="1"  maxOccurs="1">
                <xsl:apply-templates select="@fixed"/>
                <xsl:apply-templates/>
            </xsd:element>
            <xsd:element name="Relation" type="qdt:ArchivesCodeType"  minOccurs="1"  maxOccurs="1"/>
            <xsd:attribute name="Id" type="xsd:ID" use="optional"/>
        </xsd:element>
    </xsl:template>
    <xsl:template match="xsd:element[@name='Control'][@fixed='true']">
        <xsd:element name="Control" type="qdt:ArchivesCodeType">
            <xsl:apply-templates select="@minOccurs"/>
            <xsl:apply-templates select="@maxOccurs"/>
            <!-- <xsl:apply-templates select="@fixed"/> Il faudra ajouter une valeur manuellement -->
            <xsd:attribute name="listID" type="xsd:token" use="optional"/>
            <xsd:attribute name="listAgencyID" use="prohibited"/>
            <xsd:attribute name="listAgencyName" type="xsd:string" use="optional"/>
            <xsd:attribute name="listName" type="xsd:string" use="optional"/>
            <xsd:attribute name="listVersionID" type="xsd:token" use="optional"/>
            <xsd:attribute name="name" type="xsd:string" use="optional"/>
            <xsd:attribute name="languageID" type="xsd:language" use="optional"/>
            <xsd:attribute name="listURI" type="xsd:anyURI" use="optional"/>
            <xsd:attribute name="listSchemeURI" type="xsd:anyURI" use="optional"/>
          </xsd:element>
     </xsl:template>
    <xsl:template match="xsd:element[@name='Control'][@fixed='false']"/>
                        
    <xsl:template match="xsd:element[@name='KeywordContent']">
        <xsd:element name="KeywordContent" type="qdt:KeywordContentType">
            <xsl:apply-templates select="@minOccurs"/>
            <xsl:apply-templates select="@maxOccurs"/>
            <xsl:apply-templates select="@fixed"/>
            <xsd:attribute name="role" type="xsd:token" use="prohibited"/>
            <xsl:apply-templates/>
          </xsd:element>
     </xsl:template>

                        
    <!-- supression de l'attribut listVersionID remplacee par la valeur par defaut  du schema -->
    <xsl:template match="xsd:attribute[@name='listVersionID']"/>
    
<!-- reorganisation de l'ordre des elements  -->
    <xsl:template match="xsd:element[@name='ArchivalAgency' or @name='TransferringAgency' or @name='OriginatingAgency' or @name='Repository']">
        <xsd:element>
            <xsl:apply-templates select="@*"/>
            <xsl:apply-templates select="xsd:element[@name='BusinessType']"/>            
            <xsl:apply-templates select="xsd:element[@name='Description']"/>            
            <xsl:apply-templates select="xsd:element[@name='Identification']"/>            
            <xsl:apply-templates select="xsd:element[@name='LegalClassification']"/>            
            <xsl:apply-templates select="xsd:element[@name='Name']"/>            
            <xsl:apply-templates select="xsd:element[@name='Address']"/>            
            <xsl:apply-templates select="xsd:element[@name='Communication']"/>            
            <xsl:apply-templates select="xsd:element[@name='Contact']"/>
            <xsl:apply-templates select="xsd:attribute"/>
            <xsl:apply-templates select="xsd:annotation"/>
        </xsd:element>
    </xsl:template>
    <xsl:template match="xsd:element[@name='ContentDescriptive']">
        <xsd:element name="Keyword">
            <xsl:call-template name="att-sauf-name"/>
            <xsl:apply-templates select="xsd:element[@name='KeywordContent']"/>
            <xsl:apply-templates select="xsd:element[@name='KeywordReference']"/>
            <xsl:apply-templates select="xsd:element[@name='KeywordType']"/>
            <xsl:apply-templates select="xsd:element[@name='AccessRestriction']"/>
            <xsl:apply-templates select="xsd:attribute"/>
            <xsl:apply-templates select="xsd:annotation"/>
        </xsd:element>
    </xsl:template>
    <xsl:template match="xsd:element[@name='ContentDescription']">
        <xsd:element>
            <xsl:apply-templates select="@*"/>
            <xsl:apply-templates select="xsd:element[@name='Description']"/>
            <xsl:apply-templates select="../xsd:element[@name='DescriptionLevel']"/><!-- on recupere l'info dans le niveau superieur -->
            <xsl:apply-templates select="xsd:element[@name='FilePlanPosition']"/>
            <xsl:apply-templates select="xsd:element[@name='Language']"/>
            <xsl:apply-templates select="xsd:element[@name='LatestDate']"/>
            <xsl:apply-templates select="xsd:element[@name='OldestDate']"/>
            <xsl:apply-templates select="xsd:element[@name='OtherDescriptiveData']"/>
            <xsl:apply-templates select="xsd:element[@name='AccessRestriction']"/>
            <xsl:apply-templates select="xsd:element[@name='CustodialHistory']"/>
            <xsl:apply-templates select="xsd:element[@name='ContentDescriptive']"/>
            <xsl:apply-templates select="xsd:element[@name='OriginatingAgency']"/>
            <xsl:apply-templates select="xsd:element[@name='OtherMetadata']"/>
            <xsl:apply-templates select="xsd:element[@name='RelatedObjectReference']"/>
            <xsl:apply-templates select="xsd:element[@name='Repository']"/>
            <xsl:apply-templates select="xsd:attribute"/>
            <xsl:apply-templates select="xsd:annotation"/>
        </xsd:element>
    </xsl:template>

    <xsl:template match="xsd:element[@name='Contains'][@type='ArchiveType']">
        <xsd:element name="Archive">
            <xsl:call-template name="att-sauf-name"/>
            <xsl:apply-templates select="xsd:element[@name='ArchivalAgencyArchiveIdentifier']"/>
            <xsl:apply-templates select="xsd:element[@name='ArchivalAgreement']"/>
            <xsl:apply-templates select="xsd:element[@name='ArchivalProfile']"/>
            <xsl:apply-templates select="xsd:element[@name='DescriptionLanguage']"/>
            <xsl:apply-templates select="xsd:element[@name='Name']"/>
            <xsl:apply-templates select="xsd:element[@name='OriginatingAgencyArchiveIdentifier']"/>
            <xsl:apply-templates select="xsd:element[@name='ServiceLevel']"/>
            <xsl:apply-templates select="xsd:element[@name='TransferringAgencyArchiveIdentifier']"/>
            <xsl:apply-templates select="xsd:element[@name='ContentDescription']"/>
            <xsl:apply-templates select="xsd:element[@name='AccessRestriction']"/>
            <xsl:apply-templates select="xsd:element[@name='Appraisal']"/>
            <xsl:apply-templates select="xsd:element[@name='Contains']"/>
            <xsl:apply-templates select="xsd:element[@name='Document']"/>
            <xsl:apply-templates select="xsd:attribute"/>
            <xsl:apply-templates select="xsd:annotation"/>
        </xsd:element>
    </xsl:template>

    <xsl:template match="xsd:element[@name='Contains'][@type='ArchiveObjectType']">
        <xsd:element name="ArchiveObject">
            <xsl:call-template name="att-sauf-name"/>
            <xsl:apply-templates select="xsd:element[@name='ArchivalAgencyObjectIdentifier']"/>
            <xsl:apply-templates select="xsd:element[@name='Name']"/>
            <xsl:apply-templates select="xsd:element[@name='OriginatingAgencyObjectIdentifier']"/>
            <xsl:apply-templates select="xsd:element[@name='TransferringAgencyObjectIdentifier']"/>
            <xsl:apply-templates select="xsd:element[@name='ContentDescription']"/>
            <xsl:apply-templates select="xsd:element[@name='AccessRestriction']"/>
            <xsl:apply-templates select="xsd:element[@name='Appraisal']"/>
            <xsl:apply-templates select="xsd:element[@name='Contains']"/>
            <xsl:apply-templates select="xsd:element[@name='Document']"/>
            <xsl:apply-templates select="xsd:attribute"/>
            <xsl:apply-templates select="xsd:annotation"/>
        </xsd:element>
    </xsl:template>
    
    <xsl:template match="xsd:element[@name='Document']">
        <xsd:element>
            <xsl:apply-templates select="@*"/>
            <xsl:if test="xsd:element[@name='Identification']">
                <xsd:element name="ArchivalAgencyDocumentIdentifier">
                    <xsl:copy-of select="xsd:element[@name='Identification']/@*"/>
                    <xsl:apply-templates select="xsd:element[@name='Identification']/*"/>
                </xsd:element>
            </xsl:if>
            <!-- ArchivalAgencyDocumentIdentifier -->
            <xsl:apply-templates select="xsd:element[@name='Attachment']"/>
            <xsl:apply-templates select="xsd:element[@name='Control']"/>
            <xsl:apply-templates select="xsd:element[@name='Copy']"/>
            <xsl:apply-templates select="xsd:element[@name='Creation']"/>
            <xsl:apply-templates select="xsd:element[@name='Description']"/>
            <!--Integrity: il faut recuperer manuellement les empreintes de l'entete du message -->
            <xsl:apply-templates select="xsd:element[@name='Issue']"/>
            <xsl:apply-templates select="../xsd:element[@name='ContentDescription']/xsd:element[@name='Language']"/>
            <!-- OriginatingAgencyDocumentIdentifier -->
            <xsl:apply-templates select="xsd:element[@name='Purpose']"/>
            <xsl:apply-templates select="xsd:element[@name='Receipt']"/>
            <xsl:apply-templates select="xsd:element[@name='Response']"/>
            <!-- Size: on ne peut pas prendre celui le Size du ContentDescription car il concerne peut etre plusieurs documents -->
            <xsl:apply-templates select="xsd:element[@name='Status']"/>
            <xsl:apply-templates select="xsd:element[@name='Submission']"/>
            <!-- TransferringAgencyDocumentIdentifier -->
            <xsl:apply-templates select="xsd:element[@name='Type']"/>
            <xsl:apply-templates select="xsd:element[@name='OtherMetadata']"/>
            <!-- RelatedData -->
            <xsl:apply-templates select="xsd:attribute"/>
            <xsl:apply-templates select="xsd:annotation"/>
        </xsd:element>
    </xsl:template>
    <xsl:template match="xsd:element[@name='ArchiveTransfer']">
        <xsd:element>
            <xsl:apply-templates select="@*"/>
            <xsl:apply-templates select="xsd:element[@name='Comment']"/>
            <xsl:apply-templates select="xsd:element[@name='Date']"/>
            <xsl:apply-templates select="xsd:element[@name='RelatedTransferReference']"/>
            <xsl:apply-templates select="xsd:element[@name='TransferIdentifier']"/>
            <xsl:apply-templates select="xsd:element[@name='TransferRequestReplyIdentifier']"/>
            <xsl:apply-templates select="xsd:element[@name='ArchivalAgency']"/>
            <xsl:apply-templates select="xsd:element[@name='TransferringAgency']"/>
            <xsl:apply-templates select="xsd:element[@name='Contains']"/>
            <xsl:apply-templates select="xsd:element[@name='NonRepudiation']"/>
            <xsl:apply-templates select="xsd:attribute"/>
            <xsl:apply-templates select="xsd:annotation"/>
        </xsd:element>
    </xsl:template>
    
    <!-- Passage de la table des noms de langue ISO-639-1 a ISO-639-3 -->
    
    <xsl:template match="xsd:element[@name='Language']/@fixed | xsd:element[@name='DescriptionLanguage']/@fixed">
        <xsl:attribute name="fixed">
            <xsl:choose>
                <xsl:when test=".='aa'">aar</xsl:when>
                <xsl:when test=".='ab'">abk</xsl:when>
                <xsl:when test=".='ae'">ave</xsl:when>
                <xsl:when test=".='af'">afr</xsl:when>
                <xsl:when test=".='ak'">aka</xsl:when>
                <xsl:when test=".='am'">amh</xsl:when>
                <xsl:when test=".='an'">arg</xsl:when>
                <xsl:when test=".='ar'">ara</xsl:when>
                <xsl:when test=".='as'">asm</xsl:when>
                <xsl:when test=".='av'">ava</xsl:when>
                <xsl:when test=".='ay'">aym</xsl:when>
                <xsl:when test=".='az'">aze</xsl:when>
                <xsl:when test=".='ba'">bak</xsl:when>
                <xsl:when test=".='be'">bel</xsl:when>
                <xsl:when test=".='bg'">bul</xsl:when>
                <xsl:when test=".='bi'">bis</xsl:when>
                <xsl:when test=".='bm'">bam</xsl:when>
                <xsl:when test=".='bn'">ben</xsl:when>
                <xsl:when test=".='bo'">bod</xsl:when>
                <xsl:when test=".='br'">bre</xsl:when>
                <xsl:when test=".='bs'">bos</xsl:when>
                <xsl:when test=".='ca'">cat</xsl:when>
                <xsl:when test=".='ce'">che</xsl:when>
                <xsl:when test=".='ch'">cha</xsl:when>
                <xsl:when test=".='co'">cos</xsl:when>
                <xsl:when test=".='cr'">cre</xsl:when>
                <xsl:when test=".='cs'">ces</xsl:when>
                <xsl:when test=".='cu'">chu</xsl:when>
                <xsl:when test=".='cv'">chv</xsl:when>
                <xsl:when test=".='cy'">cym</xsl:when>
                <xsl:when test=".='da'">dan</xsl:when>
                <xsl:when test=".='de'">deu</xsl:when>
                <xsl:when test=".='dv'">div</xsl:when>
                <xsl:when test=".='dz'">dzo</xsl:when>
                <xsl:when test=".='ee'">ewe</xsl:when>
                <xsl:when test=".='el'">ell</xsl:when>
                <xsl:when test=".='en'">eng</xsl:when>
                <xsl:when test=".='eo'">epo</xsl:when>
                <xsl:when test=".='es'">spa</xsl:when>
                <xsl:when test=".='et'">est</xsl:when>
                <xsl:when test=".='eu'">eus</xsl:when>
                <xsl:when test=".='fa'">fas</xsl:when>
                <xsl:when test=".='ff'">ful</xsl:when>
                <xsl:when test=".='fi'">fin</xsl:when>
                <xsl:when test=".='fj'">fij</xsl:when>
                <xsl:when test=".='fo'">fao</xsl:when>
                <xsl:when test=".='fr'">fra</xsl:when>
                <xsl:when test=".='fy'">fry</xsl:when>
                <xsl:when test=".='ga'">gle</xsl:when>
                <xsl:when test=".='gd'">gla</xsl:when>
                <xsl:when test=".='gl'">glg</xsl:when>
                <xsl:when test=".='gn'">grn</xsl:when>
                <xsl:when test=".='gu'">guj</xsl:when>
                <xsl:when test=".='gv'">glv</xsl:when>
                <xsl:when test=".='ha'">hau</xsl:when>
                <xsl:when test=".='he'">heb</xsl:when>
                <xsl:when test=".='hi'">hin</xsl:when>
                <xsl:when test=".='ho'">hmo</xsl:when>
                <xsl:when test=".='hr'">hrv</xsl:when>
                <xsl:when test=".='ht'">hat</xsl:when>
                <xsl:when test=".='hu'">hun</xsl:when>
                <xsl:when test=".='hy'">hye</xsl:when>
                <xsl:when test=".='hz'">her</xsl:when>
                <xsl:when test=".='ia'">ina</xsl:when>
                <xsl:when test=".='id'">ind</xsl:when>
                <xsl:when test=".='ie'">ile</xsl:when>
                <xsl:when test=".='ig'">ibo</xsl:when>
                <xsl:when test=".='ii'">iii</xsl:when>
                <xsl:when test=".='ik'">ipk</xsl:when>
                <xsl:when test=".='io'">ido</xsl:when>
                <xsl:when test=".='is'">isl</xsl:when>
                <xsl:when test=".='it'">ita</xsl:when>
                <xsl:when test=".='iu'">iku</xsl:when>
                <xsl:when test=".='ja'">jpn</xsl:when>
                <xsl:when test=".='jv'">jav</xsl:when>
                <xsl:when test=".='ka'">kat</xsl:when>
                <xsl:when test=".='kg'">kon</xsl:when>
                <xsl:when test=".='ki'">kik</xsl:when>
                <xsl:when test=".='kj'">kua</xsl:when>
                <xsl:when test=".='kk'">kaz</xsl:when>
                <xsl:when test=".='kl'">kal</xsl:when>
                <xsl:when test=".='km'">khm</xsl:when>
                <xsl:when test=".='kn'">kan</xsl:when>
                <xsl:when test=".='ko'">kor</xsl:when>
                <xsl:when test=".='kr'">kau</xsl:when>
                <xsl:when test=".='ks'">kas</xsl:when>
                <xsl:when test=".='ku'">kur</xsl:when>
                <xsl:when test=".='kv'">kom</xsl:when>
                <xsl:when test=".='kw'">cor</xsl:when>
                <xsl:when test=".='ky'">kir</xsl:when>
                <xsl:when test=".='la'">lat</xsl:when>
                <xsl:when test=".='lb'">ltz</xsl:when>
                <xsl:when test=".='lg'">lug</xsl:when>
                <xsl:when test=".='li'">lim</xsl:when>
                <xsl:when test=".='ln'">lin</xsl:when>
                <xsl:when test=".='lo'">lao</xsl:when>
                <xsl:when test=".='lt'">lit</xsl:when>
                <xsl:when test=".='lu'">lub</xsl:when>
                <xsl:when test=".='lv'">lav</xsl:when>
                <xsl:when test=".='mg'">mlg</xsl:when>
                <xsl:when test=".='mh'">mah</xsl:when>
                <xsl:when test=".='mi'">mri</xsl:when>
                <xsl:when test=".='mk'">mkd</xsl:when>
                <xsl:when test=".='ml'">mal</xsl:when>
                <xsl:when test=".='mn'">mon</xsl:when>
                <xsl:when test=".='mo'">mol</xsl:when>
                <xsl:when test=".='mr'">mar</xsl:when>
                <xsl:when test=".='ms'">msa</xsl:when>
                <xsl:when test=".='mt'">mlt</xsl:when>
                <xsl:when test=".='my'">mya</xsl:when>
                <xsl:when test=".='na'">nau</xsl:when>
                <xsl:when test=".='nb'">nob</xsl:when>
                <xsl:when test=".='nd'">nde</xsl:when>
                <xsl:when test=".='ne'">nep</xsl:when>
                <xsl:when test=".='ng'">ndo</xsl:when>
                <xsl:when test=".='nl'">nld</xsl:when>
                <xsl:when test=".='nn'">nno</xsl:when>
                <xsl:when test=".='no'">nor</xsl:when>
                <xsl:when test=".='nr'">nbl</xsl:when>
                <xsl:when test=".='nv'">nav</xsl:when>
                <xsl:when test=".='ny'">nya</xsl:when>
                <xsl:when test=".='oc'">oci</xsl:when>
                <xsl:when test=".='oj'">oji</xsl:when>
                <xsl:when test=".='om'">orm</xsl:when>
                <xsl:when test=".='or'">ori</xsl:when>
                <xsl:when test=".='os'">oss</xsl:when>
                <xsl:when test=".='pa'">pan</xsl:when>
                <xsl:when test=".='pi'">pli</xsl:when>
                <xsl:when test=".='pl'">pol</xsl:when>
                <xsl:when test=".='ps'">pus</xsl:when>
                <xsl:when test=".='pt'">por</xsl:when>
                <xsl:when test=".='qu'">que</xsl:when>
                <xsl:when test=".='rm'">roh</xsl:when>
                <xsl:when test=".='rn'">run</xsl:when>
                <xsl:when test=".='ro'">ron</xsl:when>
                <xsl:when test=".='ru'">rus</xsl:when>
                <xsl:when test=".='rw'">kin</xsl:when>
                <xsl:when test=".='sa'">san</xsl:when>
                <xsl:when test=".='sc'">srd</xsl:when>
                <xsl:when test=".='sd'">snd</xsl:when>
                <xsl:when test=".='se'">sme</xsl:when>
                <xsl:when test=".='sg'">sag</xsl:when>
                <xsl:when test=".='si'">sin</xsl:when>
                <xsl:when test=".='sk'">slk</xsl:when>
                <xsl:when test=".='sl'">slv</xsl:when>
                <xsl:when test=".='sm'">smo</xsl:when>
                <xsl:when test=".='sn'">sna</xsl:when>
                <xsl:when test=".='so'">som</xsl:when>
                <xsl:when test=".='sq'">sqi</xsl:when>
                <xsl:when test=".='sr'">srp</xsl:when>
                <xsl:when test=".='ss'">ssw</xsl:when>
                <xsl:when test=".='st'">sot</xsl:when>
                <xsl:when test=".='su'">sun</xsl:when>
                <xsl:when test=".='sv'">swe</xsl:when>
                <xsl:when test=".='sw'">swa</xsl:when>
                <xsl:when test=".='ta'">tam</xsl:when>
                <xsl:when test=".='te'">tel</xsl:when>
                <xsl:when test=".='tg'">tgk</xsl:when>
                <xsl:when test=".='th'">tha</xsl:when>
                <xsl:when test=".='ti'">tir</xsl:when>
                <xsl:when test=".='tk'">tuk</xsl:when>
                <xsl:when test=".='tl'">tgl</xsl:when>
                <xsl:when test=".='tn'">tsn</xsl:when>
                <xsl:when test=".='to'">ton</xsl:when>
                <xsl:when test=".='tr'">tur</xsl:when>
                <xsl:when test=".='ts'">tso</xsl:when>
                <xsl:when test=".='tt'">tat</xsl:when>
                <xsl:when test=".='tw'">twi</xsl:when>
                <xsl:when test=".='ty'">tah</xsl:when>
                <xsl:when test=".='ug'">uig</xsl:when>
                <xsl:when test=".='uk'">ukr</xsl:when>
                <xsl:when test=".='ur'">urd</xsl:when>
                <xsl:when test=".='uz'">uzb</xsl:when>
                <xsl:when test=".='ve'">ven</xsl:when>
                <xsl:when test=".='vi'">vie</xsl:when>
                <xsl:when test=".='vo'">vol</xsl:when>
                <xsl:when test=".='wa'">wln</xsl:when>
                <xsl:when test=".='wo'">wol</xsl:when>
                <xsl:when test=".='xh'">xho</xsl:when>
                <xsl:when test=".='yi'">yid</xsl:when>
                <xsl:when test=".='yo'">yor</xsl:when>
                <xsl:when test=".='za'">zha</xsl:when>
                <xsl:when test=".='zh'">zho</xsl:when>
                <xsl:when test=".='zu'">zul</xsl:when>
                <xsl:otherwise><xsl:value-of select="."/></xsl:otherwise>
            </xsl:choose>
        </xsl:attribute>
    </xsl:template>
    
</xsl:stylesheet>