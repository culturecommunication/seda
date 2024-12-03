<?xml version="1.0" encoding="UTF-8"?>
<!-- ======================================================== -->
<!-- =====                                              ===== -->
<!--               XSLT SEDA 2 EAD SIAF                       -->
<!--                Mintika - bnichele 2024                   -->
<!-- =====                                              ===== -->
<!-- ======================================================== -->
<xsl:stylesheet version="1.0" xmlns:seda="fr:gouv:culture:archivesdefrance:seda:v2.3"
    xmlns:ead="http://www.w3.org/" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xsd="http://www.w3.org/2001/XMLSchema"
    xmlns:ccts="urn:un:unece:uncefact:documentation:standard:CoreComponentsTechnicalSpecification:2"
    exclude-result-prefixes="seda ead ccts xsd">
    
    <xsl:output indent="yes" method="xml" encoding="utf-8" doctype-system="ead.dtd"/>

    <!-- Paramètres passés en entrée -->
    <xsl:param name="eadid"/>
    <xsl:param name="titleproper"/>

    <xsl:key name="BinaryData" match="seda:BinaryDataObject" use="@id"/>
    <xsl:key name="PhysicalData" match="seda:PhysicalDataObject" use="@id"/>
    <xsl:key name="DataGroup" match="seda:DataObjectGroup" use="@id"/>
    <!--<xsl:key name="DataGroup" match="seda:DataObjectGroup|seda:DataObjectGroupId" use="@id"/>-->
    <xsl:key name="BinaryDataGroupId" match="seda:BinaryDataObject/seda:DataObjectGroupId" use="."/>
    <xsl:key name="PhysicalDataGroupId" match="seda:PhysicalDataObject/seda:DataObjectGroupId" use="."/>

    <xsl:template match="/seda:ArchiveTransfer">
        <ead>
            <xsl:comment>Transformation SEDA 2.3 vers EAD</xsl:comment>
            <eadheader>
                <eadid>
                    <xsl:choose>
                        <xsl:when test="$eadid != ''">
                            <xsl:value-of select="$eadid"/>
                        </xsl:when>
                    </xsl:choose>
                </eadid>
                <filedesc>
                    <titlestmt>
                        <titleproper>
                            <xsl:if test="$titleproper != ''">
                                <xsl:value-of select="$titleproper"/>
                            </xsl:if>
                        </titleproper>
                    </titlestmt>
                </filedesc>
                <xsl:apply-templates select="seda:Content/seda:DescriptionLanguage"/>
            </eadheader>
            <xsl:apply-templates select="seda:DataObjectPackage/seda:DescriptiveMetadata/seda:ArchiveUnit" mode="top"/>
            <xsl:apply-templates select="seda:DescriptiveMetadata/seda:ArchiveUnit" mode="top"/>
        </ead>
    </xsl:template>

    <xsl:template match="seda:ArchiveUnit" mode="top">
        <archdesc>
            <xsl:attribute name="level">
                <xsl:choose>
                    <xsl:when test="seda:Content/seda:DescriptionLevel/text() = 'Fonds'">fonds</xsl:when>
                    <xsl:when test="seda:Content/seda:DescriptionLevel/text() = 'Subfonds'">subfonds</xsl:when>
                    <xsl:when test="seda:Content/seda:DescriptionLevel/text() = 'Series'">series</xsl:when>
                    <xsl:when test="seda:Content/seda:DescriptionLevel/text() = 'Subseries'">subseries</xsl:when>
                    <xsl:when test="seda:Content/seda:DescriptionLevel/text() = 'Collection'">collection</xsl:when>
                    <xsl:when test="seda:Content/seda:DescriptionLevel/text() = 'File'">file</xsl:when>
                    <xsl:when test="seda:Content/seda:DescriptionLevel/text() = 'RecordGrp'">recordgrp</xsl:when>
                    <xsl:when test="seda:Content/seda:DescriptionLevel/text() = 'SubGrp'">subgrp</xsl:when>
                    <xsl:when test="seda:Content/seda:DescriptionLevel/text() = 'Item'">item</xsl:when>
                </xsl:choose>
            </xsl:attribute>
            <did>
                <xsl:apply-templates select="seda:Content/seda:OriginatingSystemId"/>
                <xsl:apply-templates select="seda:Content/seda:TransferringAgencyArchiveUnitIdentifier"/>
                <xsl:apply-templates select="seda:Content/seda:OriginatingAgencyArchiveUnitIdentifier"/>
                <xsl:apply-templates select="seda:Content/seda:ArchivalAgencyArchiveUnitIdentifier"/>
                <xsl:apply-templates select="seda:Content/seda:PersistentIdentifier/seda:PersistentIdentifierContent"/>
                <xsl:apply-templates select="seda:Content/seda:Title"/>
                <xsl:if test="seda:Content/seda:StartDate or seda:Content/seda:EndDate">
                    <unitdate label="Date de l'unité documentaire">
                        <xsl:attribute name="normal">
                            <xsl:choose>
                                <xsl:when test="seda:Content/seda:StartDate and seda:Content/seda:EndDate">
                                    <xsl:value-of select="substring(seda:Content/seda:StartDate, 1, 4)"/>
                                    <xsl:text>/</xsl:text>
                                    <xsl:value-of select="substring(seda:Content/seda:EndDate, 1, 4)"/>
                                </xsl:when>
                                <xsl:when test="seda:Content/seda:StartDate">
                                    <xsl:value-of select="substring(seda:Content/seda:StartDate, 1, 4)"/>
                                </xsl:when>
                                <xsl:when test="seda:Content/seda:EndDate">
                                    <xsl:value-of select="substring(seda:Content/seda:EndDate, 1, 4)"/>
                                </xsl:when>
                            </xsl:choose>
                        </xsl:attribute>
                        <xsl:choose>
                            <xsl:when test="seda:Content/seda:StartDate and seda:Content/seda:EndDate">
                                <xsl:value-of select="concat(normalize-space(seda:Content/seda:StartDate), ' / ', normalize-space(seda:Content/seda:EndDate))"/>
                            </xsl:when>
                            <xsl:when test="seda:Content/seda:StartDate">
                                <xsl:value-of select="normalize-space(seda:Content/seda:StartDate)"/>
                            </xsl:when>
                            <xsl:when test="seda:Content/seda:EndDate">
                                <xsl:value-of select="normalize-space(seda:Content/seda:EndDate)"/>
                            </xsl:when>
                        </xsl:choose>
                    </unitdate>
                </xsl:if>
                <xsl:apply-templates select="seda:Content/seda:Language"/>
                <xsl:apply-templates select="seda:Content/seda:OriginatingAgency"/>
                <!--Solution 1<xsl:apply-templates select="seda:Content/seda:Gps"/>-->
                <xsl:if test="//seda:OriginatingAgencyIdentifier">
                    <origination><xsl:value-of select="//seda:OriginatingAgencyIdentifier"/></origination>
                </xsl:if>
                <xsl:apply-templates select="seda:DataObjectReference" mode="physical"/>
            </did>
            <xsl:if test="ancestor::seda:DataObjectPackage/seda:ManagementMetadata/seda:AcquisitionInformation">
                <acqinfo>
                    <p>
                        <date>
                            <xsl:apply-templates select="ancestor::seda:DataObjectPackage/seda:ManagementMetadata/seda:AcquisitionInformation"/>
                        </date>
                    </p>
                </acqinfo>
            </xsl:if>
            <xsl:if test="ancestor::seda:DataObjectPackage/seda:ManagementMetadata/seda:LegalStatus">
                <accessrestrict>
                    <p><xsl:value-of select="ancestor::seda:DataObjectPackage/seda:ManagementMetadata/seda:LegalStatus"/></p>
                </accessrestrict>
            </xsl:if>
            <xsl:apply-templates select="ancestor::seda:DataObjectPackage/seda:ManagementMetadata/seda:AccessRule"><xsl:with-param name="LevelAccessRule" select="'RacineManifest'"/></xsl:apply-templates>
            <xsl:apply-templates select="seda:Management/seda:AccessRule"><xsl:with-param name="LevelAccessRule" select="'PlanDeClassement'"/></xsl:apply-templates>
            
            <xsl:apply-templates select="ancestor::seda:DataObjectPackage/seda:ManagementMetadata/seda:AppraisalRule"><xsl:with-param name="LevelAppraisalRule" select="'RacineManifest'"/></xsl:apply-templates>
            <xsl:apply-templates select="seda:Management/seda:AppraisalRule"><xsl:with-param name="LevelAppraisalRule" select="'PlanDeClassement'"/></xsl:apply-templates>
            
            <xsl:apply-templates select="ancestor::seda:DataObjectPackage/seda:ManagementMetadata/seda:ReuseRule"><xsl:with-param name="LevelReuseRule" select="'ReuseRuleRacineManifest'"/></xsl:apply-templates>
            <xsl:apply-templates select="seda:Management/seda:ReuseRule"><xsl:with-param name="LevelReuseRule" select="'ReuseRulePlanDeClassement'"/></xsl:apply-templates>
            
            <xsl:apply-templates select="ancestor::seda:DataObjectPackage/seda:ManagementMetadata/seda:DisseminationRule"><xsl:with-param name="LevelDisseminationRule" select="'DisseminationRuleRacineManifest'"/></xsl:apply-templates>
            <xsl:apply-templates select="seda:Management/seda:DisseminationRule"><xsl:with-param name="LevelDisseminationRule" select="'DisseminationRulePlanDeClassement'"/></xsl:apply-templates>
            
            <xsl:apply-templates select="seda:Content"/>
            <xsl:choose>
                <xsl:when test="seda:DataObjectReference">
                    <xsl:choose>
                        <xsl:when test="seda:ArchiveUnit">
                            <xsl:apply-templates select="seda:DataObjectReference"/>
                            <dsc>
                                <xsl:apply-templates select="seda:ArchiveUnit"/>
                            </dsc>
                        </xsl:when>
                        <xsl:otherwise>
                                <xsl:apply-templates select="seda:DataObjectReference"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:when>
                <!-- Permet de générer les niveaux d'ArchiveUnit en-dessous du premier -->
                <xsl:otherwise>
                    <dsc>
                        <xsl:apply-templates select="seda:ArchiveUnit"/>
                    </dsc>
                </xsl:otherwise>
            </xsl:choose>
        </archdesc>
    </xsl:template>

    <!-- Permet de générer les niveaux d'ArchiveUnit en-dessous du premier -->
    <xsl:template match="seda:ArchiveUnit">
        <c>
            <xsl:attribute name="level">
                <xsl:choose>
                    <xsl:when test="seda:Content/seda:DescriptionLevel/text() = 'Fonds'">fonds</xsl:when>
                    <xsl:when test="seda:Content/seda:DescriptionLevel/text() = 'Subfonds'">subfonds</xsl:when>
                    <xsl:when test="seda:Content/seda:DescriptionLevel/text() = 'Series'">series</xsl:when>
                    <xsl:when test="seda:Content/seda:DescriptionLevel/text() = 'Subseries'">subseries</xsl:when>
                    <xsl:when test="seda:Content/seda:DescriptionLevel/text() = 'Collection'">collection</xsl:when>
                    <xsl:when test="seda:Content/seda:DescriptionLevel/text() = 'File'">file</xsl:when>
                    <xsl:when test="seda:Content/seda:DescriptionLevel/text() = 'RecordGrp'">recordgrp</xsl:when>
                    <xsl:when test="seda:Content/seda:DescriptionLevel/text() = 'SubGrp'">subgrp</xsl:when>
                    <xsl:when test="seda:Content/seda:DescriptionLevel/text() = 'Item'">item</xsl:when>
                </xsl:choose>
            </xsl:attribute>
            <did>
                <xsl:apply-templates select="seda:Content/seda:OriginatingSystemId"/>
                <xsl:apply-templates select="seda:Content/seda:TransferringAgencyArchiveUnitIdentifier"/>
                <xsl:apply-templates select="seda:Content/seda:OriginatingAgencyArchiveUnitIdentifier"/>
                <xsl:apply-templates select="seda:Content/seda:ArchivalAgencyArchiveUnitIdentifier"/>
                <xsl:apply-templates select="seda:Content/seda:PersistentIdentifier/seda:PersistentIdentifierContent"/>
                <xsl:apply-templates select="seda:Content/seda:Title"/>
                <xsl:if test="seda:Content/seda:StartDate or seda:Content/seda:EndDate">
                    <unitdate label="Date de l'unité documentaire">
                        <xsl:attribute name="normal">
                            <xsl:choose>
                                <xsl:when test="seda:Content/seda:StartDate and seda:Content/seda:EndDate">
                                    <xsl:value-of select="substring(seda:Content/seda:StartDate, 1, 4)"/>
                                    <xsl:text>/</xsl:text>
                                    <xsl:value-of select="substring(seda:Content/seda:EndDate, 1, 4)"/>
                                </xsl:when>
                                <xsl:when test="seda:Content/seda:StartDate">
                                    <xsl:value-of select="substring(seda:Content/seda:StartDate, 1, 4)"/>
                                </xsl:when>
                                <xsl:when test="seda:Content/seda:EndDate">
                                    <xsl:value-of select="substring(seda:Content/seda:EndDate, 1, 4)"/>
                                </xsl:when>
                            </xsl:choose>
                        </xsl:attribute>
                        <xsl:choose>
                            <xsl:when test="seda:Content/seda:StartDate and seda:Content/seda:EndDate">
                                <xsl:value-of select="concat(normalize-space(seda:Content/seda:StartDate), ' / ', normalize-space(seda:Content/seda:EndDate))"/>
                            </xsl:when>
                            <xsl:when test="seda:Content/seda:StartDate">
                                <xsl:value-of select="normalize-space(seda:Content/seda:StartDate)"/>
                            </xsl:when>
                            <xsl:when test="seda:Content/seda:EndDate">
                                <xsl:value-of select="normalize-space(seda:Content/seda:EndDate)"/>
                            </xsl:when>
                        </xsl:choose>
                    </unitdate>
                </xsl:if>
                
                <xsl:apply-templates select="seda:Content/seda:Language"/>
                <xsl:apply-templates select="seda:Content/seda:OriginatingAgency"/>
                <!-- Solution 1     <xsl:apply-templates select="seda:Content/seda:Gps"/>-->
                <xsl:apply-templates select="seda:DataObjectReference" mode="physical"/>
            </did>
            <xsl:apply-templates select="seda:Management/seda:AccessRule"><xsl:with-param name="LevelAccessRule" select="'PlanDeClassement'"/></xsl:apply-templates>
            <xsl:apply-templates select="seda:Management/seda:AppraisalRule"><xsl:with-param name="LevelAppraisalRule" select="'PlanDeClassement'"/></xsl:apply-templates>
            <xsl:apply-templates select="seda:Management/seda:ReuseRule"><xsl:with-param name="LevelReuseRule" select="'ReuseRulePlanDeClassement'"/></xsl:apply-templates>
            <xsl:apply-templates select="seda:Management/seda:DisseminationRule"><xsl:with-param name="LevelDisseminationRule" select="'DisseminationRulePlanDeClassement'"/></xsl:apply-templates>
            <xsl:apply-templates select="seda:Content"/>
            <xsl:apply-templates select="seda:DataObjectReference"/>
            <xsl:apply-templates select="seda:ArchiveUnit"/>
        </c>
    </xsl:template>
    
    <!-- Règle qui s'applique à Title -->
    <xsl:template match="seda:Content/seda:Title">
        <unittitle>
            <xsl:apply-templates select="@xml:lang"/>
            <xsl:apply-templates/>
        </unittitle>
    </xsl:template>

    <!-- ======================================================== -->
    <!-- =====                                              ===== -->
    <!--       Règle qui s'applique à AccessRule       -->
    <!-- =====                                              ===== -->
    <!-- ======================================================== -->

    <xsl:template match="seda:AccessRule">
        <xsl:param name="LevelAccessRule"/>
        <accessrestrict>
            <xsl:attribute name="altrender"><xsl:value-of select="$LevelAccessRule"/></xsl:attribute>
            <xsl:apply-templates select="seda:Rule"/>
            <xsl:apply-templates select="seda:StartDate"/>
        </accessrestrict>
    </xsl:template>
    <xsl:template match="seda:AccessRule/seda:Rule">
        <p>
            <xsl:apply-templates/>
        </p>
    </xsl:template>
    <xsl:template match="seda:AccessRule/seda:StartDate">
        <p>à partir de : <date><xsl:apply-templates/></date></p>
    </xsl:template>

    <!-- ======================================================== -->
    <!-- =====                                              ===== -->
    <!--        règle qui s'applique à AppraisalRule              -->
    <!-- =====                                              ===== -->
    <!-- ======================================================== -->

    <xsl:template match="seda:AppraisalRule">
        <xsl:param name="LevelAppraisalRule"/>
        <appraisal>
            <xsl:attribute name="altrender"><xsl:value-of select="$LevelAppraisalRule"/></xsl:attribute>
            <xsl:apply-templates select="seda:FinalAction | seda:Rule | seda:StartDate"/>
        </appraisal>
    </xsl:template>
    <xsl:template match="seda:AppraisalRule/seda:FinalAction">
        <p>
            <xsl:choose>
                <xsl:when test=". = 'Keep'">
                    <xsl:text>Conserver</xsl:text>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:text>Détruire</xsl:text>
                </xsl:otherwise>
            </xsl:choose>
        </p>
    </xsl:template>
    <xsl:template match="seda:AppraisalRule/seda:Rule">
        <p>
            <xsl:apply-templates/>
        </p>
    </xsl:template>
    <xsl:template match="seda:AppraisalRule/seda:StartDate">
        <p>à partir de : <date><xsl:apply-templates/></date></p>
    </xsl:template>
    
    <!-- ======================================================== -->
    <!-- =====                                              ===== -->
    <!--       Règle qui s'applique à ReuseRule       -->
    <!-- =====                                              ===== -->
    <!-- ======================================================== -->
    
    <xsl:template match="seda:ReuseRule">
        <xsl:param name="LevelReuseRule"/>
        <userestrict>
            <xsl:attribute name="altrender"><xsl:value-of select="$LevelReuseRule"/></xsl:attribute>
            <xsl:apply-templates select="seda:Rule | seda:StartDate"/>
        </userestrict>
    </xsl:template>
    <xsl:template match="seda:ReuseRule/seda:Rule">
        <p>
            <xsl:apply-templates/>
        </p>
    </xsl:template>
    <xsl:template match="seda:ReuseRule/seda:StartDate">
        <p>à partir de : <date><xsl:apply-templates/></date></p>
    </xsl:template>
    
    <!-- ======================================================== -->
    <!-- =====                                              ===== -->
    <!--       Règle qui s'applique à DisseminationRule       -->
    <!-- =====                                              ===== -->
    <!-- ======================================================== -->
    
    <xsl:template match="seda:DisseminationRule">
        <xsl:param name="LevelDisseminationRule"/>
        <userestrict>
            <xsl:attribute name="altrender"><xsl:value-of select="$LevelDisseminationRule"/></xsl:attribute>
            <xsl:apply-templates select="seda:Rule | seda:StartDate"/>
        </userestrict>
    </xsl:template>
    <xsl:template match="seda:DisseminationRule/seda:Rule">
        <p>
            <xsl:apply-templates/>
        </p>
    </xsl:template>
    <xsl:template match="seda:DisseminationRule/seda:StartDate">
        <p>à partir de : <date><xsl:apply-templates/></date></p>
    </xsl:template>

    <!-- ======================================================== -->
    <!-- =====                                              ===== -->
    <!--        Règle qui s'applique à Content         -->
    <!-- =====                                              ===== -->
    <!-- ======================================================== -->

    <xsl:template match="seda:Content">
        <xsl:apply-templates select="seda:RelatedObjectReference"/>
        <xsl:apply-templates select="seda:CustodialHistory"/>
        <xsl:if test="seda:Description">
            <scopecontent>
                    <xsl:apply-templates select="seda:Description"/>
            </scopecontent>
        </xsl:if>
        <xsl:if test="seda:Source">
            <originalsloc>
                <p>
                    <xsl:value-of select="seda:Source"/>
                </p>
            </originalsloc>
        </xsl:if>
        <xsl:apply-templates select="seda:FilePlanPosition"/>
        <xsl:if test="seda:Keyword|seda:Gps|seda:Coverage|seda:DocumentType|seda:Tag">
            <controlaccess>
                <xsl:apply-templates select="seda:Keyword"/>
                <xsl:apply-templates select="seda:Coverage"/>
                <xsl:apply-templates select="seda:DocumentType"/>
                <xsl:apply-templates select="seda:Tag"/>
                <xsl:apply-templates select="seda:Gps"/>
            </controlaccess>
        </xsl:if>
        <xsl:if test="seda:RelatedObjectReference/seda:References/seda:ExternalReference">
            <altformavail>
                <p>
                    <xsl:value-of select="seda:RelatedObjectReference/seda:References/seda:ExternalReference"/>
                </p>
            </altformavail>
        </xsl:if>
    </xsl:template>

    <!-- Règle permettant d'ajouter l'attribut de [lang] dans le contenu de la balise de correspodance -->
    <!-- Pour désactiver la génération des langues, commenter ce template et les occurences de @xml:lang -->
    <xsl:template match="@xml:lang">[lang: <xsl:value-of select="."/>] </xsl:template>

    <!-- Règle qui s'applique à CustodialHistory -->
    <xsl:template match="seda:Content/seda:CustodialHistory">
        <custodhist>
            <xsl:for-each select="seda:CustodialHistoryItem">
                <p>
                    <xsl:apply-templates select="./@xml:lang"/>
                    <xsl:apply-templates select="."/>
                </p>
            </xsl:for-each>
        </custodhist>
    </xsl:template>

    <!-- Règle qui s'applique à Description -->
    <xsl:template match="seda:Content/seda:Description">
        
            <p>
                <xsl:apply-templates select="@xml:lang"/>
                <xsl:apply-templates/>
            </p>
        
    </xsl:template>

    <!-- Règle qui s'applique à FilePlanPosition -->
    <xsl:template match="seda:Content/seda:FilePlanPosition">
        <fileplan>
            <p>
                <xsl:apply-templates/>
            </p>
        </fileplan>
    </xsl:template>
    
    <!-- Règle qui s'applique à Gps - Solution 1
    <xsl:template match="seda:Content/seda:Gps">
        <physloc>
            <xsl:if test="seda:GpsAltitude"><title>GpsAltitude : <xsl:value-of select="seda:GpsAltitude"/></title></xsl:if>
            <xsl:if test="seda:GpsAltitudeRef"><title>GpsAltitudeRef : <xsl:value-of select="seda:GpsAltitudeRef"/></title></xsl:if>
            <xsl:if test="seda:GpsLatitude"><title>GpsLatitude : <xsl:value-of select="seda:GpsLatitude"/></title></xsl:if>
            <xsl:if test="seda:GpsLatitudeRef"><title>GpsLatitudeRef : <xsl:value-of select="seda:GpsLatitudeRef"/></title></xsl:if>
            <xsl:if test="seda:GpsLongitude"><title>GpsLongitude : <xsl:value-of select="seda:GpsLongitude"/></title></xsl:if>
            <xsl:if test="seda:GpsLongitudeRef"><title>GpsLongitudeRef : <xsl:value-of select="seda:GpsLongitudeRef"/></title></xsl:if>
            <xsl:if test="seda:GpsDateStamp"><title>GpsDateStamp : <xsl:value-of select="seda:GpsDateStamp"/></title></xsl:if>
        </physloc>
    </xsl:template>-->
    
    <!-- Règle qui s'applique à Gps - Solution 2-->
    <xsl:template match="seda:Gps">
        <geogname>
            <xsl:if test="seda:GpsAltitude"> GpsAltitude : <xsl:value-of select="seda:GpsAltitude"/> </xsl:if>
            <xsl:if test="seda:GpsAltitudeRef"> GpsAltitudeRef : <xsl:value-of select="seda:GpsAltitudeRef"/> </xsl:if>
            <xsl:if test="seda:GpsLatitude"> GpsLatitude : <xsl:value-of select="seda:GpsLatitude"/> </xsl:if>
            <xsl:if test="seda:GpsLatitudeRef"> GpsLatitudeRef : <xsl:value-of select="seda:GpsLatitudeRef"/> </xsl:if>
            <xsl:if test="seda:GpsLongitude"> GpsLongitude : <xsl:value-of select="seda:GpsLongitude"/> </xsl:if>
            <xsl:if test="seda:GpsLongitudeRef"> GpsLongitudeRef : <xsl:value-of select="seda:GpsLongitudeRef"/> </xsl:if>
            <xsl:if test="seda:GpsDateStamp"> GpsDateStamp : <xsl:value-of select="seda:GpsDateStamp"/> </xsl:if>
        </geogname>
    </xsl:template>

    <!-- Règle qui s'applique aux attributs de RelatedObjectReference -->
    <xsl:template match="seda:Content/seda:RelatedObjectReference">
        <xsl:if test="*/seda:ArchiveUnitRefId|*/seda:DataObjectReference/*">
                <separatedmaterial>
                    <xsl:for-each select="*">
                        <xsl:for-each select="seda:ArchiveUnitRefId|seda:DataObjectReference/*">
                            <p>
                                <xsl:apply-templates select="."/>
                            </p>
                        </xsl:for-each>
                    </xsl:for-each>
                </separatedmaterial>
            </xsl:if>
        
            <xsl:if test="*/seda:RepositoryArchiveUnitPID|*/seda:RepositoryObjectPID">
                <relatedmaterial>
                    <xsl:for-each select="*">
                        <xsl:for-each select="seda:RepositoryArchiveUnitPID|seda:RepositoryObjectPID">
                            <p>
                                <xsl:apply-templates select="."/>
                            </p>
                        </xsl:for-each>
                    </xsl:for-each>
                </relatedmaterial>
            </xsl:if>
    </xsl:template>

    <!--Règle qui s'applique à Keyword-->
    <xsl:template match="seda:Keyword">
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
    
    <!--Règle qui s'applique à Coverage-->
    <xsl:template match="seda:Coverage">
        <xsl:for-each select="seda:Spatial">
            <geogname>
                <xsl:apply-templates select="."/>
            </geogname>
        </xsl:for-each>
        <xsl:for-each select="seda:Temporal">
            <p>
                <xsl:apply-templates select="."/>
            </p>
        </xsl:for-each>
        <xsl:for-each select="seda:Juridictional">
            <subject>
                <xsl:apply-templates select="."/>
            </subject>
        </xsl:for-each>
    </xsl:template>
    
    <!--Règle qui s'applique à DocumentType-->
    <xsl:template match="seda:DocumentType">
        <xsl:for-each select="*">
            <genreform>
                <xsl:apply-templates select="."/>
            </genreform>
        </xsl:for-each>
    </xsl:template>
    
    <!--Règle qui s'applique à Tag-->
    <xsl:template match="seda:Tag">
        <xsl:for-each select="*">
            <p>
                <xsl:apply-templates select="."/>
            </p>
        </xsl:for-each>
    </xsl:template>

    <!-- Règle qui s'applique à OriginatingAgency -->
    <xsl:template match="seda:Content/seda:OriginatingAgency">
        <origination>
            <xsl:value-of select="seda:Identifier"/>
        </origination>
    </xsl:template>


    <!-- Règle qui s'applique à ContentDescription/seda:Language -->
    <xsl:template match="seda:Content/seda:Language">
        <langmaterial>
            <language>
                <xsl:apply-templates/>
            </language>
        </langmaterial>
    </xsl:template>

    <!-- Règle qui s'applique à DescriptionLanguage -->
    <xsl:template match="seda:Content/seda:DescriptionLanguage">
        <profiledesc>
            <langusage>
                <language>
                    <xsl:apply-templates/>
                </language>
            </langusage>
        </profiledesc>
    </xsl:template>

    <!-- ======================================================== -->
    <!-- =====                                              ===== -->
    <!--            Règle qui s'applique à unitid                 -->
    <!-- =====                                              ===== -->
    <!-- ======================================================== -->
    <xsl:template match="seda:Content/seda:OriginatingAgencyArchiveUnitIdentifier">
        <unitid>
            <xsl:attribute name="type">identifiant du service producteur</xsl:attribute>
            <xsl:apply-templates/>
        </unitid>
    </xsl:template>
    <xsl:template match="seda:Content/seda:ArchivalAgencyArchiveUnitIdentifier">
        <unitid>
            <xsl:attribute name="type">identifiant du service d'archives</xsl:attribute>
            <xsl:apply-templates/>
        </unitid>
    </xsl:template>
    <xsl:template match="seda:Content/seda:TransferringAgencyArchiveUnitIdentifier">
        <unitid>
            <xsl:attribute name="type">identifiant du service versant</xsl:attribute>
            <xsl:apply-templates/>
        </unitid>
    </xsl:template>
    <xsl:template match="seda:Content/seda:OriginatingSystemId">
        <unitid>
            <xsl:attribute name="label">identifiant système d'origine</xsl:attribute>
            <xsl:apply-templates/>
        </unitid>
    </xsl:template>
    <xsl:template match="seda:Content/seda:PersistentIdentifier/seda:PersistentIdentifierContent">
        <unitid>
            <xsl:attribute name="label">identifiant pérènne</xsl:attribute>
            <xsl:apply-templates/>
        </unitid>
    </xsl:template>


    <!-- ======================================================== -->
    <!-- =====                                              ===== -->
    <!-- Règle qui s'applique à seda:DataObjectReference Binary   -->
    <!-- =====                                              ===== -->
    <!-- ======================================================== -->
    <!-- Génère autant de dao / phystech que de DataObjectReference au sein d'une ArchiveUnit -->
    <xsl:template match="seda:DataObjectReference">
        <xsl:for-each select="key('DataGroup', seda:DataObjectGroupReferenceId)/seda:BinaryDataObject|key('BinaryDataGroupId', seda:DataObjectGroupReferenceId)|key('BinaryData', seda:DataObjectReferenceId)">
            <dao>
                  <xsl:attribute name="title">
                            <xsl:value-of select="seda:FileInfo/seda:Filename"/>
                            <xsl:value-of select="following-sibling::seda:FileInfo/seda:Filename"/>
                  </xsl:attribute>
                
            </dao>
            <xsl:if test="seda:Size or following::seda:Size or seda:FormatIdentification/seda:FormatId or following::seda:FormatIdentification/seda:FormatId or seda:FormatIdentification/seda:FormatLitteral or following::seda:FormatIdentification/seda:FormatLitteral or seda:FileInfo or following-sibling::seda:FileInfo">
            <phystech>
                <xsl:if test="seda:Size|following::seda:Size">
                <p>
                    <xsl:text>Poids du fichier : </xsl:text>
                    <xsl:value-of select="seda:Size"/>
                    <xsl:value-of select="following-sibling::seda:Size"/>
                    <xsl:text> octets</xsl:text>
                </p>
                </xsl:if>
                <xsl:if test="seda:FormatIdentification/seda:FormatId|following::seda:FormatIdentification/seda:FormatId">
                    <p>
                        <xsl:text>Identifiant PRONOM : </xsl:text>
                        <xsl:value-of select="seda:FormatIdentification/seda:FormatId"/>
                        <xsl:value-of select="following-sibling::seda:FormatIdentification/seda:FormatId"/>
                    </p>
                </xsl:if>
                <xsl:if test="seda:FormatIdentification/seda:FormatLitteral|following::seda:FormatIdentification/seda:FormatLitteral">
                    <p>
                        <xsl:text>Forme littéral du nom de format : </xsl:text>
                        <xsl:value-of select="seda:FormatIdentification/seda:FormatLitteral"/>
                        <xsl:value-of select="following-sibling::seda:FormatIdentification/seda:FormatLitteral"/>
                    </p>
                </xsl:if>
                <xsl:for-each select="seda:FileInfo|following-sibling::seda:FileInfo">
                    <xsl:for-each select="*">
                        <p>
                            <xsl:apply-templates select="."/>
                        </p>
                    </xsl:for-each>
                </xsl:for-each>
            </phystech>    
            </xsl:if>
        </xsl:for-each>
    </xsl:template>
    
    <!-- ======================================================== -->
    <!-- =====                                              ===== -->
    <!-- Règle qui s'applique à seda:DataObjectReference Physical -->
    <!-- =====                                              ===== -->
    <!-- ======================================================== -->
    <xsl:template match="seda:DataObjectReference" mode="physical">
        <xsl:for-each select="key('PhysicalDataGroupId', seda:DataObjectGroupReferenceId)|key('PhysicalData', seda:DataObjectReferenceId)">
            <physdesc>
                <title>
                    <xsl:value-of select="seda:PhysicalId"/>
                    <xsl:value-of select="following-sibling::seda:PhysicalId"/>
                </title>
                <xsl:for-each select="seda:PhysicalDimensions/*">
                <dimensions>
                        <xsl:attribute name="unit">
                            <xsl:value-of select="@unit"/>
                        </xsl:attribute>
                        <xsl:attribute name="type">
                            <xsl:value-of select="name()"/>
                        </xsl:attribute>
                    <xsl:value-of select="."/>
                </dimensions>
                </xsl:for-each>
            </physdesc>
        </xsl:for-each>
    </xsl:template>

</xsl:stylesheet>
