<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
    xmlns="http://www.w3.org/1999/xhtml"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:i18n="urn:hdr-static:i18n"
    exclude-result-prefixes="#all"
    version="2.0">
    <xsl:include href="./params.xsl"/>
    <xsl:include href="./i18n.xsl"/>
    <xsl:template name="html_head">
        <xsl:param name="html_title" select="i18n:t('project__short_title')"></xsl:param>
        <meta charset="utf-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1" />
        <link rel="icon" href="{$base}{$project_logo}" sizes="any" />
        <title><xsl:value-of select="$html_title"/></title>

        <!-- <link rel="canonical" href="{$base_url}" /> -->
        <xsl:for-each select="$languages">
            <link rel="alternate" hreflang="{.}" href="{$base_url}{.}/{$page}" />
        </xsl:for-each>
        <link rel="alternate" hreflang="x-default" href="{$base_url}{$default_lang}/{$page}" />
        <meta name="description" content="{i18n:t('project__title')}" />

        <meta property="og:type" content="website" />
        <meta property="og:title" content="{i18n:t('project__short_title')}" />
        <meta property="og:description" content="{i18n:t('project__title')}" />
        <!-- <meta property="og:url" content="{$base_url}" /> -->
        <meta property="og:site_name" content="{i18n:t('project__short_title')}" />
        <meta property="og:image" content="{$base_url}{$project_logo}" />

        <link rel="stylesheet" href="{$base}css/index.css?v={$version}" />
        <script type="module" src="{$base}js/main.js?v={$version}"></script>
    </xsl:template>
</xsl:stylesheet>
