<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:seda="fr:gouv:ae:archive:draft:standard_echange_v0.2"
    xmlns:ead="http://www.w3.org/" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xsd="http://www.w3.org/2001/XMLSchema"
    xmlns:ccts="urn:un:unece:uncefact:documentation:standard:CoreComponentsTechnicalSpecification:2"
    exclude-result-prefixes="seda ead ccts xsd">

    <xsl:output indent="yes" method="xml" encoding="ISO-8859-1"/>

    <xsl:template match="/">
        <xsl:apply-templates select="//seda:ArchiveTransfer"/>
    </xsl:template>

    <!-- ======================================================== -->
    <!-- =====                                              ===== -->
    <!--            Règle qui s'applique à ArchiveTransfer        -->
    <!-- =====                                              ===== -->
    <!-- ======================================================== -->

    <xsl:template match="seda:ArchiveTransfer">
        <xsl:comment>transformation SEDA 0.2 en SEDA 2.0 </xsl:comment>
        <ArchiveTransfer>
            <xsl:if test="seda:Comment">
                <Comment>
                    <xsl:apply-templates select="seda:Comment"/>
                </Comment>
            </xsl:if>
            <Date>
                <xsl:apply-templates select="seda:Date"/>
            </Date>
            <MessageIdentifier>
                <xsl:apply-templates select="seda:TransferIdentifier"/>
            </MessageIdentifier>

            <xsl:if test="seda:NonRepudiation">
                <Signature>
                    <xsl:copy-of select="//seda:XMLSignature"/>
                </Signature>
            </xsl:if>

            <xsl:if test="seda:Contains/seda:ArchivalAgreement">
                <ArchivalAgreement>
                    <xsl:attribute name="schemeAgencyName">
                        <xsl:value-of
                            select="seda:Contains/seda:ArchivalAgreement/@schemeAgencyName"/>
                    </xsl:attribute>
                    <xsl:attribute name="schemeName">
                        <xsl:value-of select="seda:Contains/seda:ArchivalAgreement/@schemeName"/>
                    </xsl:attribute>
                    <xsl:value-of select="seda:Contains/seda:ArchivalAgreement"/>
                </ArchivalAgreement>
            </xsl:if>

            <xsl:call-template name="CodeList"/>

            <DataObjectPackage>
                <xsl:apply-templates select="//seda:Attachment"/>
                <DescriptiveMetadata>
                    <xsl:apply-templates select="//seda:ArchiveTransfer/seda:Contains"/>
                </DescriptiveMetadata>
                <ManagementMetadata>
                    <xsl:if test="seda:Contains/seda:ArchivalProfile">
                        <ArchivalProfile>
                            <xsl:attribute name="schemeAgencyName">
                                <xsl:value-of
                                    select="seda:Contains/seda:ArchivalProfile/@schemeAgencyName"/>
                            </xsl:attribute>
                            <xsl:attribute name="schemeName">
                                <xsl:value-of
                                    select="seda:Contains/seda:ArchivalProfile/@schemeName"/>
                            </xsl:attribute>
                            <xsl:value-of select="seda:Contains/seda:ArchivalProfile"/>
                        </ArchivalProfile>
                    </xsl:if>
                    <xsl:if test="seda:Contains/seda:Appraisal">
                        <xsl:apply-templates select="seda:Contains/seda:Appraisal"/>
                    </xsl:if>
                    <xsl:if test="seda:Contains/seda:AccessRestriction">
                        <xsl:apply-templates select="seda:Contains/seda:AccessRestriction"/>
                    </xsl:if>
                </ManagementMetadata>
            </DataObjectPackage>
            <ArchivalAgency>
                <xsl:apply-templates select="seda:ArchivalAgency"/>
            </ArchivalAgency>
            <TransferringAgency>
                <xsl:apply-templates select="seda:TransferringAgency"/>
            </TransferringAgency>
        </ArchiveTransfer>
    </xsl:template>

    <!-- Ne fonctionne pas pour l'instant -->
    <xsl:template name="Attribute">
        <xsl:if test="@schemeAgencyName">
            <xsl:attribute name="schemeAgencyName">
                <xsl:value-of select="@schemeAgencyName"/>
            </xsl:attribute>
        </xsl:if>
    </xsl:template>

    <!-- ======================================================== -->
    <!-- =====                                              ===== -->
    <!--            Règle qui s'applique à Agency                -->
    <!-- =====                                              ===== -->
    <!-- ======================================================== -->
    <xsl:template match="seda:ArchivalAgency | seda:TransferringAgency | seda:OriginatingAgency">
        <xsl:call-template name="Agency"/>
    </xsl:template>

    <xsl:template name="Agency">
        <Identifier>
            <xsl:attribute name="schemeAgencyName">
                <xsl:value-of select="seda:Identification/@schemeAgencyName"/>
            </xsl:attribute>
            <xsl:attribute name="schemeName">
                <xsl:value-of select="seda:Identification/@schemeName"/>
            </xsl:attribute>
            <xsl:value-of select="seda:Identification"/>
        </Identifier>
        <OrganizationDescriptiveMetadata>
            <xsl:element name="Agency" namespace="fr:gouv:ae:archive:draft:standard_echange_v0.2">
                <xsl:copy-of select="*[name()!='Identification']" copy-namespaces="no"/>
            </xsl:element>
        </OrganizationDescriptiveMetadata>
    </xsl:template>

    <!-- ======================================================== -->
    <!-- =====                                              ===== -->
    <!--            Règle qui s'applique à Archive                -->
    <!-- =====                                              ===== -->
    <!-- ======================================================== -->

    <xsl:template match="seda:ArchiveTransfer/seda:Contains">
        <ArchiveUnit id="{generate-id()}">
            <xsl:if test="seda:AccessRestriction | seda:Appraisal">
                <Management>
                    <xsl:apply-templates select="seda:Appraisal | seda:AccessRestriction"/>
                </Management>
            </xsl:if>
            <Content>
                <xsl:if test="seda:ContentDescription/seda:AccessRestriction">
                    <xsl:attribute name="restrictionValue">
                        <xsl:value-of
                            select="seda:ContentDescription/seda:AccessRestriction/seda:Code"/>
                    </xsl:attribute>
                </xsl:if>
                <xsl:apply-templates select="seda:DescriptionLevel"/>
                <xsl:apply-templates select="seda:Name"/>
                <xsl:apply-templates select="seda:ContentDescription"/>
            </Content>
            <xsl:apply-templates select="child::seda:Contains"/>
        </ArchiveUnit>
    </xsl:template>

    <!-- DescriptionLevel -->
    <xsl:template match="seda:DescriptionLevel">
        <DescriptionLevel>
            <xsl:if test=".='fonds'">Fonds</xsl:if>
            <xsl:if test=".='subfonds'">Subfonds</xsl:if>
            <xsl:if test=".='class'">Class</xsl:if>
            <xsl:if test=".='collection'">Collection</xsl:if>
            <xsl:if test=".='series'">Series</xsl:if>
            <xsl:if test=".='subseries'">Subseries</xsl:if>
            <xsl:if test=".='recordGrp'">RecordGrp</xsl:if>
            <xsl:if test=".='subGrp'">SubGrp</xsl:if>
            <xsl:if test=".='file'">File</xsl:if>
            <xsl:if test=".='item'">Item</xsl:if>
        </DescriptionLevel>
    </xsl:template>

    <!-- Name -->
    <xsl:template match="seda:Name">
        <Title>
            <xsl:apply-templates/>
        </Title>
    </xsl:template>


    <!-- ======================================================== -->
    <!-- =====                                              ===== -->
    <!--           Règle qui s'applique à l'élément Contains      -->
    <!-- =====                                              ===== -->
    <!-- ======================================================== -->

    <xsl:template match="seda:Contains">
        <ArchiveUnit id="{generate-id()}">
            <xsl:if test="seda:AccessRestriction | seda:Appraisal">
                <Management>
                    <xsl:apply-templates select="seda:Appraisal | seda:AccessRestriction"/>
                </Management>
            </xsl:if>
            <Content>
                <xsl:if test="seda:ContentDescription/seda:AccessRestriction">
                    <xsl:attribute name="restrictionValue">
                        <xsl:value-of
                            select="seda:ContentDescription/seda:AccessRestriction/seda:Code"/>
                    </xsl:attribute>
                </xsl:if>
                <xsl:apply-templates select="seda:DescriptionLevel"/>
                <xsl:apply-templates select="seda:Name"/>
                <xsl:apply-templates select="seda:ContentDescription"/>
            </Content>

            <xsl:apply-templates select="seda:Document"/>
            <xsl:apply-templates select="child::seda:Contains"/>
        </ArchiveUnit>
    </xsl:template>

    <!-- ======================================================== -->
    <!-- =====                                              ===== -->
    <!--           Règle qui s'applique à AccessRestriction       -->
    <!-- =====                                              ===== -->
    <!-- ======================================================== -->

    <xsl:template match="seda:Contains/seda:AccessRestriction">
        <AccessRule>
            <Rule>
                <xsl:apply-templates select="seda:Code"/>
            </Rule>
            <StartDate>
                <xsl:apply-templates select="seda:StartDate"/>
            </StartDate>
        </AccessRule>
    </xsl:template>

    <!-- ======================================================== -->
    <!-- =====                                              ===== -->
    <!--            règle qui s'applique à Appraisal              -->
    <!-- =====                                              ===== -->
    <!-- ======================================================== -->

    <xsl:template match="seda:Contains/seda:Appraisal">
        <AppraisalRule>
            <Rule>
                <xsl:apply-templates select="seda:Code"/>
            </Rule>
            <StartDate>
                <xsl:apply-templates select="seda:StartDate"/>
            </StartDate>
            <FinalAction>
                <xsl:choose>
                    <xsl:when test="seda:Code='detruire'">Destroy</xsl:when>
                    <xsl:otherwise>Keep</xsl:otherwise>
                </xsl:choose>
            </FinalAction>
        </AppraisalRule>
    </xsl:template>

    <!-- ======================================================== -->
    <!-- =====                                              ===== -->
    <!--        Règle qui s'applique à ContentDescription         -->
    <!-- =====                                              ===== -->
    <!-- ======================================================== -->

    <xsl:template match="seda:ContentDescription">
        <xsl:if test="seda:Description">
            <xsl:apply-templates select="seda:Description"/>
        </xsl:if>
        <xsl:if test="seda:CustodialHistory">
            <CustodialHistory>
                <xsl:apply-templates select="seda:CustodialHistory"/>
            </CustodialHistory>
        </xsl:if>
        <xsl:if test="seda:Language">
            <xsl:apply-templates select="seda:Language"/>
        </xsl:if>
        <xsl:apply-templates select="preceding-sibling::seda:DescriptionLanguage"/>
        <xsl:if test="seda:ContentDescriptive">
            <xsl:apply-templates select="seda:ContentDescriptive"/>
        </xsl:if>
        <xsl:if test="seda:OriginatingAgency">
            <OriginatingAgency>
                <xsl:apply-templates select="seda:OriginatingAgency"/>
            </OriginatingAgency>
        </xsl:if>
        <xsl:if test="seda:LatestDate">
            <xsl:apply-templates select="seda:LatestDate"/>
        </xsl:if>
        <xsl:if test="seda:OldestDate">
            <xsl:apply-templates select="seda:OldestDate"/>
        </xsl:if>
        <xsl:apply-templates select="seda:RelatedObjectReference"/>
    </xsl:template>

    <xsl:template match="@languageID">[lang: <xsl:value-of select="."/>] </xsl:template>

    <!-- Règle qui s'applique à CustodialHistory -->
    <xsl:template match="seda:ContentDescription/seda:CustodialHistory">
        <CustodialHistoryItem>
            <xsl:apply-templates/>
        </CustodialHistoryItem>
    </xsl:template>

    <!-- Règle qui s'applique à Description -->
    <xsl:template match="seda:ContentDescription/seda:Description">
        <Description>
            <xsl:apply-templates/>
        </Description>
    </xsl:template>

    <!-- Règle qui s'applique à Language -->
    <xsl:template match="seda:ContentDescription/seda:Language">
        <Language>
            <xsl:apply-templates/>
        </Language>
    </xsl:template>

    <!-- Règle qui s'applique aux dates -->
    <xsl:template match="seda:ContentDescription/seda:LatestDate">
        <StartDate>
            <xsl:apply-templates/>
        </StartDate>
    </xsl:template>
    <xsl:template match="seda:ContentDescription/seda:OldestDate">
        <EndDate>
            <xsl:apply-templates/>
        </EndDate>
    </xsl:template>

    <!-- Règle qui s'applique aux attributs de RelatedObjectReference -->
    <xsl:template match="seda:ContentDescription/seda:RelatedObjectReference">
        <RelatedObjectReference>
            <References>
                <DrDataObjectReference>
                    <xsl:apply-templates/>
                </DrDataObjectReference>
            </References>
        </RelatedObjectReference>
    </xsl:template>

    <!--Règle qui s'applique à ContentDescriptive-->
    <xsl:template match="seda:ContentDescriptive">
        <Keyword>
            <xsl:if test="seda:KeywordContent">
                <KeywordContent>
                    <xsl:value-of select="seda:KeywordContent"/>
                </KeywordContent>
            </xsl:if>
            <xsl:if test="seda:KeywordReference">
                <KeywordReference>
                    <xsl:value-of select="seda:KeywordReference"/>
                </KeywordReference>
            </xsl:if>
            <xsl:if test="seda:KeywordType">
                <KeywordType>
                    <xsl:value-of select="seda:KeywordType"/>
                </KeywordType>
            </xsl:if>
        </Keyword>
    </xsl:template>

    <!-- Règle qui s'applique à DescriptionLanguage -->
    <xsl:template match="seda:DescriptionLanguage">
        <DescriptionLanguage>
            <xsl:apply-templates/>
        </DescriptionLanguage>
    </xsl:template>

    <!-- Règle qui s'applique aux Ids -->
    <xsl:template match="seda:ArchivalAgencyArchiveIdentifier | seda:ArchivalAgencyObjectIdentifier">
        <SystemId>
            <xsl:apply-templates/>
        </SystemId>
    </xsl:template>
    <xsl:template
        match="seda:TransferringAgencyArchiveIdentifier | seda:TransferringAgencyObjectIdentifier">
        <TransferringAgencyArchiveUnitIdentifier>
            <xsl:apply-templates/>
        </TransferringAgencyArchiveUnitIdentifier>
    </xsl:template>


    <!-- ======================================================== -->
    <!-- =====                                              ===== -->
    <!--            Règle qui s'applique à Document               -->
    <!-- =====                                              ===== -->
    <!-- ======================================================== -->


    <xsl:template match="seda:Document">
        <DataObjectReference>
            <DataObjectId>
                <xsl:text>Id</xsl:text>
                <xsl:value-of select="seda:Attachment/@filename"/>
            </DataObjectId>
        </DataObjectReference>
    </xsl:template>


    <xsl:template match="seda:Document/seda:Attachment">
        <BinaryDataObject>
            <xsl:attribute name="id">
                <xsl:text>Id</xsl:text>
                <xsl:value-of select="@filename"/>
            </xsl:attribute>
            <Uri>
                <xsl:value-of select="@filename"/>
            </Uri>
            <xsl:choose>
                <xsl:when test="seda:Integrity">
                    <xsl:if test="seda:Integrity/seda:UnitIdentifier=seda:Attachment/@filename">
                        <MessageDigest>
                            <xsl:attribute name="algorithm">
                                <xsl:choose>
                                    <xsl:when
                                        test="//seda:Integrity/seda:Contains[not(@algorithme)]">Unknow</xsl:when>
                                    <xsl:otherwise>unkonw <xsl:value-of select="//seda:Contains/@algorithme"/>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:attribute>
                            <xsl:value-of select="//seda:Integrity/seda:Contains"/>
                        </MessageDigest>
                    </xsl:if>
                </xsl:when>
                <xsl:otherwise>
                    <MessageDigest>
                        <xsl:attribute name="algorithm">Unkonwn</xsl:attribute>
                    </MessageDigest>
                </xsl:otherwise>
            </xsl:choose>
            <Size>10000000</Size>
            <FormatIdentification>
                <xsl:if test="@mimeCode">
                    <MimeType>
                        <xsl:value-of select="@mimeCode"/>
                    </MimeType>
                </xsl:if>
                <xsl:if test="@format">
                    <FormatId>
                        <xsl:value-of select="@format"/>
                    </FormatId>
                </xsl:if>
            </FormatIdentification>
            <FileInfo>
                <Filename>
                    <xsl:value-of select="@filename"/>
                </Filename>
            </FileInfo>
        </BinaryDataObject>
    </xsl:template>

    <xsl:template name="CodeList">
        <CodeListVersions xml:id="ID005">
            <ReplyCodeListVersion>ReplyCodeListVersion0</ReplyCodeListVersion>
            <MessageDigestAlgorithmCodeListVersion>MessageDigestAlgorithmCodeListVersion0</MessageDigestAlgorithmCodeListVersion>
            <MimeTypeCodeListVersion>MimeTypeCodeListVersion0</MimeTypeCodeListVersion>
            <FileFormatCodeListVersion>FileFormatCodeListVersion0</FileFormatCodeListVersion>
            <CompressionAlgorithmCodeListVersion>CompressionAlgorithmCodeListVersion0</CompressionAlgorithmCodeListVersion>
            <DataObjectVersionCodeListVersion>DataObjectVersionCodeListVersion0</DataObjectVersionCodeListVersion>
            <StorageRuleCodeListVersion>StorageRuleCodeListVersion0</StorageRuleCodeListVersion>
            <AppraisalRuleCodeListVersion>AppraisalRuleCodeListVersion0</AppraisalRuleCodeListVersion>
            <AccessRuleCodeListVersion>AccessRuleCodeListVersion0</AccessRuleCodeListVersion>
            <DisseminationRuleCodeListVersion>DisseminationRuleCodeListVersion0</DisseminationRuleCodeListVersion>
            <ReuseRuleCodeListVersion>ReuseRuleCodeListVersion0</ReuseRuleCodeListVersion>
            <ClassificationRuleCodeListVersion>ClassificationRuleCodeListVersion0</ClassificationRuleCodeListVersion>
            <AuthorizationReasonCodeListVersion>AuthorizationReasonCodeListVersion0</AuthorizationReasonCodeListVersion>
            <RelationshipCodeListVersion>RelationshipCodeListVersion0</RelationshipCodeListVersion>
        </CodeListVersions>
    </xsl:template>
</xsl:stylesheet>
