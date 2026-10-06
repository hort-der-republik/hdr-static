<?xml version="1.0" encoding="UTF-8"?>
<!-- UI translations, read at build time from translations.csv
     (first column: key, one column per language, header row with language codes).
     Usage: <xsl:value-of select="i18n:t('navbar__about')"/> -->
<xsl:stylesheet
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:i18n="urn:hdr-static:i18n"
    exclude-result-prefixes="#all"
    version="3.0">

    <xsl:variable name="i18n:rows" as="element(row)*">
        <xsl:variable name="lines" select="unparsed-text-lines('../../translations.csv', 'utf-8')[normalize-space()]"/>
        <xsl:variable name="header" select="i18n:csv-fields($lines[1])"/>
        <xsl:for-each select="$lines[position() gt 1]">
            <xsl:variable name="fields" select="i18n:csv-fields(.)"/>
            <row key="{$fields[1]}">
                <xsl:for-each select="$header[position() gt 1]">
                    <xsl:variable name="i" select="position() + 1"/>
                    <value lang="{.}"><xsl:value-of select="$fields[$i]"/></value>
                </xsl:for-each>
            </row>
        </xsl:for-each>
    </xsl:variable>

    <!-- translation of $key in the page language, falling back to the default language -->
    <xsl:function name="i18n:t" as="xs:string">
        <xsl:param name="key" as="xs:string"/>
        <xsl:sequence select="i18n:t($key, $lang)"/>
    </xsl:function>

    <xsl:function name="i18n:t" as="xs:string">
        <xsl:param name="key" as="xs:string"/>
        <xsl:param name="in-lang" as="xs:string"/>
        <xsl:variable name="row" select="$i18n:rows[@key = $key]"/>
        <xsl:if test="empty($row)">
            <xsl:message>[i18n] missing key in translations.csv: <xsl:value-of select="$key"/></xsl:message>
        </xsl:if>
        <xsl:sequence select="string(($row/value[@lang = $in-lang][normalize-space()], $row/value[@lang = $default_lang], $key)[1])"/>
    </xsl:function>

    <!-- fields of one CSV line; quoted fields may contain commas and "" for a quote -->
    <xsl:function name="i18n:csv-fields" as="xs:string*">
        <xsl:param name="line" as="xs:string"/>
        <xsl:analyze-string select="concat(',', $line)" regex=',(?:"((?:""|[^"])*)"|([^,]*))'>
            <xsl:matching-substring>
                <xsl:sequence select="if (regex-group(1)) then replace(regex-group(1), '&quot;&quot;', '&quot;') else regex-group(2)"/>
            </xsl:matching-substring>
        </xsl:analyze-string>
    </xsl:function>
</xsl:stylesheet>
