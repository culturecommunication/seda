<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:seda="fr:gouv:ae:archive:draft:standard_echange_v0.2"
    xmlns:ead="http://www.w3.org/" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xsd="http://www.w3.org/2001/XMLSchema"
    xmlns:ccts="urn:un:unece:uncefact:documentation:standard:CoreComponentsTechnicalSpecification:2"
    exclude-result-prefixes="seda ead ccts xsd">

    <xsl:output indent="yes" method="xml" encoding="ISO-8859-1" doctype-system="ead.dtd"/>

    <xsl:template match="/">
        <xsl:apply-templates
            select="//seda:ArchiveDelivery/seda:Archive|seda:ArchiveTransfer/seda:Contains"/>
    </xsl:template>

    <!-- Attention les attributs de DescriptionLevel, de Document/Description, de keywordType et 
        de KeywordContent ne sont pas traités (prb du value-of) -->


    <!-- ======================================================== -->
    <!-- =====                                              ===== -->
    <!--            Règle qui s'applique à Archive                -->
    <!-- =====                                              ===== -->
    <!-- ======================================================== -->

    <xsl:template match="seda:ArchiveDelivery/seda:Archive|seda:ArchiveTransfer/seda:Contains">
        <xsl:comment>transformation SEDA en EAD: transformation_ead.xsl</xsl:comment>

        <ead>
            <eadheader>
                <eadid/>
                <filedesc>
                    <titlestmt>
                        <titleproper/>
                    </titlestmt>
                </filedesc>
                <xsl:apply-templates select="seda:DescriptionLanguage"/>
            </eadheader>
            <archdesc>
                <xsl:attribute name="level">
                    <xsl:value-of select="seda:DescriptionLevel"/>
                </xsl:attribute>
                <xsl:call-template name="did"/>
                <xsl:if test="//seda:ArchiveTransfer/seda:Date">
                    <acqinfo>
                        <p>
                            <date>
                                <xsl:apply-templates select="//seda:ArchiveTransfer/seda:Date"/>
                            </date>
                        </p>
                    </acqinfo>
                </xsl:if>

                <xsl:apply-templates select="seda:AccessRestriction"/>
                <xsl:apply-templates select="seda:Appraisal"/>
                <xsl:apply-templates select="seda:ContentDescription"/>
                <xsl:apply-templates
                    select="seda:ContentDescription/seda:OriginatingAgency/seda:Description"/>
                <xsl:apply-templates select="seda:Document"/>
                <dsc>
                    <xsl:apply-templates select="seda:Contains"/>
                </dsc>
            </archdesc>
        </ead>
    </xsl:template>


    <!-- ======================================================== -->
    <!-- =====                                              ===== -->
    <!--           Règle qui s'applique à l'élément Contains      -->
    <!-- =====                                              ===== -->
    <!-- ======================================================== -->

    <xsl:template match="seda:Contains">
        <c>
            <xsl:attribute name="level">
                <xsl:value-of select="seda:DescriptionLevel"/>
            </xsl:attribute>
            <xsl:call-template name="did"/>
            <xsl:apply-templates select="seda:AccessRestriction"/>
            <xsl:apply-templates select="seda:ContentDescription"/>
            <xsl:apply-templates select="seda:Appraisal"/>
            <xsl:apply-templates
                select="seda:ContentDescription/seda:OriginatingAgency/seda:Description"/>
            <xsl:apply-templates select="seda:Document"/>
            <xsl:apply-templates select="seda:Contains"/>
        </c>
    </xsl:template>
    <xsl:template name="did">
        <did>
            <xsl:apply-templates
                select="seda:ArchivalAgencyArchiveIdentifier | seda:ArchivalAgencyObjectIdentifier | seda:TransferringAgencyArchiveIdentifier | seda:TransferringAgencyObjectIdentifier"/>
            <xsl:apply-templates select="seda:Name"/>
            <xsl:if
                test="seda:ContentDescription/seda:OldestDate | seda:ContentDescription/seda:LatestDate">
                <unitdate>
                    <xsl:value-of
                        select="concat(normalize-space(seda:ContentDescription/seda:OldestDate), ' / ', normalize-space(seda:ContentDescription/seda:LatestDate))"
                    />
                </unitdate>
            </xsl:if>
            <xsl:apply-templates select="seda:ContentDescription/seda:Size"/>
            <xsl:apply-templates select="seda:ContentDescription/seda:Language"/>
            <xsl:apply-templates select="seda:ContentDescription/seda:Repository"/>
            <xsl:apply-templates select="seda:ContentDescription/seda:OriginatingAgency"/>
        </did>
    </xsl:template>

    <!-- Règle qui s'applique à Name -->
    <xsl:template match="seda:Name">
        <unittitle>
            <xsl:apply-templates/>
        </unittitle>
    </xsl:template>

    <!-- ======================================================== -->
    <!-- =====                                              ===== -->
    <!--           Règle qui s'applique à AccessRestriction       -->
    <!-- =====                                              ===== -->
    <!-- ======================================================== -->

    <xsl:template match="seda:AccessRestriction">
        <accessrestrict>
            <xsl:apply-templates select="seda:Code"/>
            <xsl:apply-templates select="seda:StartDate"/>
        </accessrestrict>
    </xsl:template>
    <xsl:template match="seda:AccessRestriction/seda:Code">
        <xsl:attribute name="audience">internal</xsl:attribute>
        <xsl:apply-templates/>
    </xsl:template>
    <xsl:template match="seda:AccessRestriction/seda:StartDate">
        <p>à partir de : <date><xsl:apply-templates/></date>
        </p>
    </xsl:template>

    <!-- Cas particulier: règle qui s'applique au code d'AccessRestriction -->
    <xsl:template match="seda:AccessRestriction/seda:Code[@listVersionID='edition 2009']/text()">
        <xsl:variable name="value" select="."/>
        <xsl:variable name="table"
            >codes/archives_echanges_v0-2_accessrestriction_code.xsd</xsl:variable>
        <xsl:variable name="meta">
            <xsl:value-of
                select="document($table)//xsd:enumeration[@value=$value]//xsd:annotation/xsd:documentation/ccts:Name"
            />
        </xsl:variable>
        <p>
            <xsl:choose>
                <xsl:when test="$meta='0 an'">Immédiat</xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="$meta"/>
                </xsl:otherwise>
            </xsl:choose>
        </p>
        <p>
            <xsl:value-of
                select="document($table)//xsd:enumeration[@value=$value]//xsd:annotation/xsd:documentation/ccts:Description"
            />
        </p>
    </xsl:template>

    <!-- ======================================================== -->
    <!-- =====                                              ===== -->
    <!--            règle qui s'applique à Appraisal              -->
    <!-- =====                                              ===== -->
    <!-- ======================================================== -->

    <xsl:template match="seda:Appraisal">
        <appraisal>
            <xsl:apply-templates select="seda:Code | seda:StartDate"/>
        </appraisal>
    </xsl:template>
    <xsl:template match="seda:Appraisal/seda:Code">
        <p>
            <xsl:apply-templates/>
        </p>
    </xsl:template>
    <xsl:template match="seda:Appraisal/seda:StartDate">
        <p>à partir de : <date><xsl:apply-templates/></date></p>
    </xsl:template>

    <!-- ======================================================== -->
    <!-- =====                                              ===== -->
    <!--        Règle qui s'applique à ContentDescription         -->
    <!-- =====                                              ===== -->
    <!-- ======================================================== -->

    <xsl:template match="seda:ContentDescription">
        <xsl:apply-templates select="seda:AccessRestriction"/>
        <xsl:apply-templates select="seda:RelatedObjectReference"/>
        <xsl:apply-templates select="seda:CustodialHistory"/>
        <xsl:apply-templates select="seda:Description"/>
        <xsl:apply-templates select="seda:Format"/>
        <xsl:if test="seda:ContentDescriptive">
            <controlaccess>
                <xsl:apply-templates select="seda:ContentDescriptive"/>
            </controlaccess>
        </xsl:if>
        <xsl:apply-templates select="seda:OtherDescriptiveData"/>
    </xsl:template>

    <xsl:template match="@languageID">[lang: <xsl:value-of select="."/>] </xsl:template>

    <!-- Règle qui s'applique à CustodialHistory -->
    <xsl:template match="seda:ContentDescription/seda:CustodialHistory">
        <custodhist>
            <p>
                <xsl:apply-templates select="@languageID"/>
                <xsl:apply-templates/>
            </p>
        </custodhist>
    </xsl:template>

    <!-- Règle qui s'applique à Description -->
    <xsl:template match="seda:ContentDescription/seda:Description">
        <scopecontent>
            <p>
                <xsl:apply-templates select="@languageID"/>
                <xsl:apply-templates/>
            </p>
        </scopecontent>
    </xsl:template>

    <!-- Règle qui s'applique à Format -->
    <xsl:template match="seda:ContentDescription/seda:Format">
        <phystech>
            <p>
                <xsl:apply-templates select="@languageID"/>
                <xsl:apply-templates/>
            </p>
        </phystech>
    </xsl:template>

    <!-- Règle qui s'applique à OtherDescriptiveData -->
    <xsl:template match="seda:ContentDescription/seda:OtherDescriptiveData">
        <odd>
            <p>
                <xsl:apply-templates select="@languageID"/>
                <xsl:apply-templates/>
            </p>
        </odd>
    </xsl:template>

    <!-- Règle qui s'applique aux attributs de RelatedObjectReference -->
    <xsl:template match="seda:ContentDescription/seda:RelatedObjectReference">
        <separatedmaterial>
            <p>
                <xsl:apply-templates/>
            </p>
        </separatedmaterial>
    </xsl:template>

    <!--Règle qui s'applique à ContentDescriptive-->
    <xsl:template match="seda:ContentDescriptive">
        <xsl:choose>
            <xsl:when test="not(seda:KeywordType)">
                <p>
                    <xsl:value-of select="seda:KeywordContent"/>
                </p>
            </xsl:when>
            <xsl:otherwise>
                <xsl:element name="{seda:KeywordType/text()}">
                    <xsl:value-of select="seda:KeywordContent"/>
                </xsl:element>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!-- Règle qui s'applique à OriginatingAgency -->
    <xsl:template match="seda:ContentDescription/seda:OriginatingAgency">
        <origination>
            <xsl:attribute name="id">
                <xsl:apply-templates select="seda:Identification"/>
            </xsl:attribute>
            <xsl:apply-templates select="seda:Name"/>
            <xsl:apply-templates select="seda:Contact/seda:DepartmentName"/>
            <xsl:apply-templates select="seda:Contact/seda:PersonName"/>
        </origination>
    </xsl:template>
    <xsl:template match="seda:Contact/seda:DepartmentName">
        <corpname>
            <xsl:value-of select="local-name()"/>: <xsl:value-of select="."/>
        </corpname>
    </xsl:template>
    <xsl:template match="seda:OriginatingAgency/seda:Name">
        <corpname>
            <xsl:apply-templates/>
        </corpname>
    </xsl:template>
    <xsl:template match="seda:Contact/seda:PersonName">
        <persname>
            <xsl:apply-templates/>
        </persname>
    </xsl:template>
    <xsl:template match="seda:ContentDescription/seda:OriginatingAgency/seda:Description">
        <bioghist>
            <p><xsl:value-of select="local-name()"/>: <xsl:value-of select="."/></p>
        </bioghist>
    </xsl:template>


    <!-- Règle qui s'applique à ContentDescription/seda:Language -->
    <xsl:template match="seda:ContentDescription/seda:Language">
        <langmaterial>
            <language>
                <xsl:apply-templates/>
            </language>
        </langmaterial>
    </xsl:template>


    <!-- Règle qui s'applique à Repository -->
    <xsl:template match="seda:ContentDescription/seda:Repository">
        <repository>
            <xsl:apply-templates/>
        </repository>
    </xsl:template>

    <!-- Règle qui s'applique à Size -->
    <xsl:template match="seda:ContentDescription/seda:Size">
        <physdesc>
            <extent>
                <xsl:apply-templates/>
            </extent>
        </physdesc>
    </xsl:template>

    <!-- Règle qui s'applique à DescriptionLanguage -->
    <xsl:template match="seda:DescriptionLanguage">
        <profiledesc>
            <langusage>
                <language>
                    <xsl:apply-templates/>
                </language>
            </langusage>
        </profiledesc>
    </xsl:template>

    <!-- Règle qui s'applique à unitid -->
    <xsl:template match="seda:ArchivalAgencyArchiveIdentifier | seda:ArchivalAgencyObjectIdentifier">
        <unitid>
            <xsl:attribute name="type">identifiant du service d'archives</xsl:attribute>
            <xsl:apply-templates/>
        </unitid>
    </xsl:template>
    <xsl:template
        match="seda:TransferringAgencyArchiveIdentifier | seda:TransferringAgencyObjectIdentifier">
        <unitid>
            <xsl:attribute name="type">identifiant du service versant</xsl:attribute>
            <xsl:apply-templates/>
        </unitid>
    </xsl:template>


    <!-- ======================================================== -->
    <!-- =====                                              ===== -->
    <!--            Règle qui s'applique à Document               -->
    <!-- =====                                              ===== -->
    <!-- ======================================================== -->
    <xsl:template match="seda:Document">
        <xsl:apply-templates select="seda:Attachment"/>       
    </xsl:template>
    <xsl:template match="seda:Document/seda:Attachment">
        <c>
            <did>
                <unittitle>
                    <xsl:value-of select="@filename"/>
                </unittitle>
                <xsl:apply-templates select="ancestor-or-self::seda:Document/seda:Identification"/>
            </did>
            <dao>
                <xsl:apply-templates select="@uri"/>
            </dao>
            <phystech>
                <p>
                    <xsl:value-of select="@format"/>
                </p>
            </phystech>
        </c>
    </xsl:template>
    <xsl:template match="seda:Document/seda:Attachment/@uri">
        <xsl:attribute name="href">
            <xsl:value-of select="."/>
        </xsl:attribute>
    </xsl:template>
    <xsl:template match="seda:Document/seda:Identification">
        <unitid>
            <xsl:value-of select="."/>
        </unitid>
    </xsl:template>
</xsl:stylesheet>
