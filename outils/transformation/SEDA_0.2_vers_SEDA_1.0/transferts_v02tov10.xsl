<?xml version="1.0" encoding="ISO-8859-1"?>
<!--
    Transformations SEDA version 0.2 vers  version 1.0
    
    Ces transformations concernent principalement le bloc Archive et sa mise en oeuvre 
    n'est prevue que pour le message ArchiveTransfer.
    
    Pour les autres messages autre que ArchiveTransfer, la feuille de styles doit etre adaptee.
    
    Lire les commentaires pour conprendre les choix  effectues et les quelques problemes
    residuels qui ne peuvent pas etre traites sans connaissances supplementaires du contexte.

    Copyright (c) 2011 Service interministériel des archives de France
    
    Ce document est sous licence Creative Commons Paternité 2.0 France.
    Pour accéder à une copie de cette licence, merci de vous rendre à l'adresse suivante
    http://creativecommons.org/licenses/by/2.0/fr/ ou envoyez un courrier à
    Creative Commons, 444 Castro Street, Suite 900,
    Mountain View, California, 94041, USA.

-->
<xsl:stylesheet version="1.0" 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
    xmlns="fr:gouv:culture:archivesdefrance:seda:v1.0" 
    xmlns:seda1="fr:gouv:ae:archive:draft:standard_echange_v0.2" 
    exclude-result-prefixes="seda1">
	
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
    
    <!-- Suppression de l'ancienne declaration de schemas -->
    <xsl:template xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" match="@xsi:schemaLocation"/>
    

<!-- ****************************** -->
<!-- *** les regles spécifiques *** -->
<!-- ****************************** -->
    
<!-- changement du namespace -->
    <xsl:template match="seda1:*">
        <xsl:element name="{local-name(.)}" >
        	<xsl:apply-templates select="@*"/>
        	<xsl:apply-templates/>
        </xsl:element>
    </xsl:template>
    
<!-- supression d'elements -->
    <xsl:template match="seda1:Format"/>
    <xsl:template match="seda1:ItemIdentifier"/>

<!-- changement de nom d'elements -->
    <xsl:template match="seda1:URI">
        <URIID>
            <xsl:apply-templates select="@*"/>
            <xsl:apply-templates/>
        </URIID>
    </xsl:template>
    <xsl:template match="seda1:Appraisal">
        <AppraisalRule>
            <xsl:apply-templates select="@*"/>
            <xsl:apply-templates/>
        </AppraisalRule>
    </xsl:template>
    <xsl:template match="seda1:AccessRestriction">
        <AccessRestrictionRule>
            <xsl:apply-templates select="@*"/>
            <xsl:apply-templates/>
        </AccessRestrictionRule>
    </xsl:template>
    <!-- ContentDescriptive est traite dans les changements d'ordre -->
    <!-- Contains est traite dans les changements d'ordre -->
    
<!-- Changements de types des elements  -->
    <xsl:template match="seda1:CustodialHistory">
        <CustodialHistory>
            <xsl:apply-templates select="@*"/>
            <CustodialHistoryItem>
                <xsl:apply-templates/>
            </CustodialHistoryItem>
        </CustodialHistory>
    </xsl:template>
    <xsl:template match="seda1:Channel">
        <Channel>
            <xsl:apply-templates select="@*"/>
            <xsl:apply-templates/><!-- L'ancienne valeur causera en general une erreur a la validation qu'il faudra corriger -->
        </Channel>
    </xsl:template>
    <xsl:template match="seda1:RelatedObjectReference">
        <RelatedObjectReference>
            <RelatedObjectIdentifier>
                <xsl:apply-templates select="@*"/>
                <xsl:apply-templates/>
            </RelatedObjectIdentifier>
            <Relation>
                <!-- Il faudra ajouter cette valeur manuellement -->
            </Relation>
        </RelatedObjectReference>
      </xsl:template>
    <xsl:template match="seda1:Control[.='true']">
        <Control>
            <xsl:apply-templates select="@*"/>
            <!-- Il faudra ajouter une valeur manuellement -->
          </Control>
     </xsl:template>
                        
                        
<!-- supression d'attributs dans les codes et les identifiants ou remplacement par la valeur par defaut  du schema -->
    <xsl:template match="seda1:*/@listVersionID"/>
    <xsl:template match="seda1:*/@listAgencyID"/>
    <xsl:template match="seda1:*/@schemeAgencyID"/>

 <!-- reorganisation de l'ordre des elements  -->
    <xsl:template match="seda1:ArchivalAgency | seda1:TransferringAgency | seda1:OriginatingAgency  | seda1:Repository">
        <xsl:element name="{local-name(.)}" >
            <xsl:apply-templates select="@*"/>
            <xsl:apply-templates select="seda1:BusinessType"/>            
            <xsl:apply-templates select="seda1:Description"/>            
            <xsl:apply-templates select="seda1:Identification"/>            
            <xsl:apply-templates select="seda1:LegalClassification"/>            
            <xsl:apply-templates select="seda1:Name"/>            
            <xsl:apply-templates select="seda1:Address"/>            
            <xsl:apply-templates select="seda1:Communication"/>            
            <xsl:apply-templates select="seda1:Contact"/>
        </xsl:element>
    </xsl:template>
    <xsl:template match="seda1:ContentDescriptive">
        <Keyword>
            <xsl:apply-templates select="@*"/>
            <xsl:apply-templates select="seda1:KeywordContent"/>
            <xsl:apply-templates select="seda1:KeywordReference"/>
            <xsl:apply-templates select="seda1:KeywordType"/>
            <xsl:apply-templates select="seda1:AccessRestriction"/>
        </Keyword>
    </xsl:template>
    <xsl:template match="seda1:ContentDescription">
        <ContentDescription>
            <xsl:apply-templates select="@*"/>
            <xsl:apply-templates select="seda1:Description"/>
            <xsl:apply-templates select="../seda1:DescriptionLevel"/><!-- on recupere l'info dans le niveau superieur -->
            <xsl:apply-templates select="seda1:FilePlanPosition"/>
            <xsl:apply-templates select="seda1:Language"/>
            <xsl:apply-templates select="seda1:LatestDate"/>
            <xsl:apply-templates select="seda1:OldestDate"/>
            <xsl:apply-templates select="seda1:OtherDescriptiveData"/>
            <xsl:apply-templates select="seda1:AccessRestriction"/>
            <xsl:apply-templates select="seda1:CustodialHistory"/>
            <xsl:apply-templates select="seda1:ContentDescriptive"/>
            <xsl:apply-templates select="seda1:OriginatingAgency"/>
            <xsl:apply-templates select="seda1:OtherMetadata"/>
            <xsl:apply-templates select="seda1:RelatedObjectReference"/>
            <xsl:apply-templates select="seda1:Repository"/>
        </ContentDescription>
    </xsl:template>
    <xsl:template match="seda1:Contains[not(ancestor::seda1:Contains)]">
        <Archive>
            <xsl:apply-templates select="@*"/>
            <xsl:apply-templates select="seda1:ArchivalAgencyArchiveIdentifier"/>
            <xsl:apply-templates select="seda1:ArchivalAgreement"/>
            <xsl:apply-templates select="seda1:ArchivalProfile"/>
            <xsl:apply-templates select="seda1:DescriptionLanguage"/>
            <xsl:apply-templates select="seda1:Name"/>
            <xsl:apply-templates select="seda1:OriginatingAgencyArchiveIdentifier"/>
            <xsl:apply-templates select="seda1:ServiceLevel"/>
            <xsl:apply-templates select="seda1:TransferringAgencyArchiveIdentifier"/>
            <xsl:apply-templates select="seda1:ContentDescription"/>
            <xsl:apply-templates select="seda1:AccessRestriction"/>
            <xsl:apply-templates select="seda1:Appraisal"/>
            <xsl:apply-templates select="seda1:Contains"/>
            <xsl:apply-templates select="seda1:Document"/>
        </Archive>
    </xsl:template>
    <xsl:template match="seda1:Contains[ancestor::seda1:Contains]">
        <ArchiveObject>
            <xsl:apply-templates select="@*"/>
            <xsl:apply-templates select="seda1:ArchivalAgencyObjectIdentifier"/>
            <xsl:apply-templates select="seda1:Name"/>
            <xsl:apply-templates select="seda1:OriginatingAgencyObjectIdentifier"/>
            <xsl:apply-templates select="seda1:TransferringAgencyObjectIdentifier"/>
            <xsl:apply-templates select="seda1:ContentDescription"/>
            <xsl:apply-templates select="seda1:AccessRestriction"/>
            <xsl:apply-templates select="seda1:Appraisal"/>
            <xsl:apply-templates select="seda1:Contains"/>
            <xsl:apply-templates select="seda1:Document"/>
        </ArchiveObject>
    </xsl:template>
    <xsl:template match="seda1:Document">
        <Document>
            <xsl:apply-templates select="@*"/>
            <xsl:if test="seda1:Identification">
                <ArchivalAgencyDocumentIdentifier>
                    <xsl:copy-of select="seda1:Identification/@*"/>
                    <xsl:value-of select="seda1:Identification"/>
                </ArchivalAgencyDocumentIdentifier>
            </xsl:if>
            <!-- <xsl:apply-templates select="seda1:ArchivalAgencyDocumentIdentifier"/> -->
            <xsl:apply-templates select="seda1:Attachment"/>
            <xsl:apply-templates select="seda1:Control"/>
            <xsl:apply-templates select="seda1:Copy"/>
            <xsl:apply-templates select="seda1:Creation"/>
            <xsl:apply-templates select="seda1:Description"/>
            <!--<xsl:apply-templates select="seda1:Integrity"/> il faut recuperer manuellement les empreintes de l'entete du message -->
            <xsl:apply-templates select="seda1:Issue"/>
            <xsl:apply-templates select="../seda1:ContentDescription/seda1:Language"/>
            <!-- <xsl:apply-templates select="seda1:OriginatingAgencyDocumentIdentifier"/> -->
            <xsl:apply-templates select="seda1:Purpose"/>
            <xsl:apply-templates select="seda1:Receipt"/>
            <xsl:apply-templates select="seda1:Response"/>
            <!-- <xsl:apply-templates select="seda1:Size"/> on ne peut pas prendre celui le Size du ContentDescription car il concerne peut etre plusieurs documents -->
            <xsl:apply-templates select="seda1:Status"/>
            <xsl:apply-templates select="seda1:Submission"/>
            <!-- <xsl:apply-templates select="seda1:TransferringAgencyDocumentIdentifier"/> -->
            <xsl:apply-templates select="seda1:Type"/>
            <xsl:apply-templates select="seda1:OtherMetadata"/>
            <!-- <xsl:apply-templates select="seda1:RelatedData"/> -->
        </Document>
    </xsl:template>
    <xsl:template match="seda1:ArchiveTransfer">
        <ArchiveTransfer>
            <xsl:apply-templates select="@*"/>
            <xsl:apply-templates select="seda1:Comment"/>
            <xsl:apply-templates select="seda1:Date"/>
            <xsl:apply-templates select="seda1:RelatedTransferReference"/>
            <xsl:apply-templates select="seda1:TransferIdentifier"/>
            <xsl:apply-templates select="seda1:TransferRequestReplyIdentifier"/>
            <xsl:apply-templates select="seda1:ArchivalAgency"/>
            <xsl:apply-templates select="seda1:TransferringAgency"/>
            <xsl:apply-templates select="seda1:Contains"/>
            <xsl:apply-templates select="seda1:NonRepudiation"/>
        </ArchiveTransfer>
    </xsl:template>
    
    <!-- Passage de la table des noms de langue ISO-639-1 a ISO-639-3 -->
    
    <xsl:template match="seda1:Language/text() | seda1:DescriptionLanguage/text()">
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
    </xsl:template>
    
</xsl:stylesheet>