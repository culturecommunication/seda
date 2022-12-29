<?xml version="1.0" encoding="UTF-8"?>
<schema xmlns="http://purl.oclc.org/dsdl/schematron"
    xmlns:xsd="http://www.w3.org/2001/XMLSchema"
    xmlns:seda="fr:gouv:culture:archivesdefrance:seda:v1.0">

    <ns uri="fr:gouv:culture:archivesdefrance:seda:v1.0" prefix="seda"/>
   
    <pattern>
        <rule context="seda:ContentDescription[(seda:LatestDate) and (seda:OldestDate)]">
            <let name="endDate" value="normalize-space(translate(seda:LatestDate, '- ', ''))" />
            <let name="startDate" value="normalize-space(translate(seda:OldestDate, '- ', ''))" />
            <assert test="number($endDate) >= number($startDate)">
                Erreur: date de fin <value-of select="seda:LatestDate"/> est anterieure à la date de début <value-of select="seda:OldestDate"/>
            </assert>
        </rule>
    </pattern>
   <pattern>
        <rule context="seda:LatestDate">
            <let name="endDate" value="normalize-space(translate(., '- ', ''))" />
            <let name="ancestorEndDate" value="normalize-space(translate(parent::seda:ContentDescription/../ancestor::seda:*[seda:ContentDescription/seda:LatestDate][1]/seda:ContentDescription/seda:LatestDate, '- ', ''))" /> 
            <assert test="($ancestorEndDate = '') or (($endDate) &lt;= ($ancestorEndDate))">
                Erreur: date de fin <value-of select="."/> est posterieure à la date de fin d'un niveau parent <value-of select="parent::seda:ContentDescription/../ancestor::seda:*[seda:ContentDescription/seda:LatestDate][1]/seda:ContentDescription/seda:LatestDate"/>
            </assert>
        </rule>
    </pattern>
    
    <pattern>
        <rule context="seda:OldestDate">
            <let name="startDate" value="normalize-space(translate(., '- ', ''))" />
            <let name="ancestorStartDate" value="normalize-space(translate(parent::seda:ContentDescription/../ancestor::seda:*[seda:ContentDescription/seda:OldestDate][1]/seda:ContentDescription/seda:OldestDate, '- ', ''))" /> 
            <assert test="($ancestorStartDate = '') or (($startDate) >= ($ancestorStartDate))">
                Erreur: date de début <value-of select="."/> est anterieure à la date de début d'un niveau parent <value-of select="parent::seda:ContentDescription/../ancestor::seda:*[seda:ContentDescription/seda:OldestDate][1]/seda:ContentDescription/seda:OldestDate"/>
            </assert>
        </rule>
    </pattern>
    
    <pattern>
        <rule context="seda:ArchiveObject[ancestor::seda:*[seda:ContentDescription/seda:DescriptionLevel='item']]">
            <let name="level" value="seda:ContentDescription/seda:DescriptionLevel" />
            <assert test="$level = 'item'">
                Erreur: '<value-of select="$level"/>' ne peut pas &#xea;tre une sub-division de 'item' 
            </assert>
        </rule>
    </pattern>

    <pattern>
        <rule context="seda:DescriptionLevel[(.='series') or (. = 'subseries')]">
            <assert test="count(./../..//seda:DescriptionLevel[. = 'fonds']) = 0">
                Erreur: un niveau '<value-of select="."/>' ne peut pas avoir une sub-division 'fonds' 
            </assert>
        </rule>
    </pattern>
</schema>