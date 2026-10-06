<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:i18n="urn:hdr-static:i18n"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    version="2.0"
    exclude-result-prefixes="#all">

    <!-- start page, rendered from data/meta/index.xml -->
    <xsl:import href="./partials/shared.xsl"/>
    <xsl:import href="./partials/html_head.xsl"/>
    <xsl:import href="./partials/html_navbar.xsl"/>
    <xsl:import href="./partials/html_footer.xsl"/>
    <xsl:import href="./partials/zotero.xsl"/>
    <xsl:output encoding="UTF-8" media-type="text/html" method="html" version="5.0" indent="yes" omit-xml-declaration="yes"/>

    <xsl:template match="/">
        <xsl:variable name="doc_title" select="i18n:t('project__short_title')"/>
        <html class="h-full" lang="{$lang}">
            <head>
                <xsl:call-template name="html_head">
                    <xsl:with-param name="html_title" select="$doc_title"></xsl:with-param>
                </xsl:call-template>
                <xsl:call-template name="zoterMetaTags"></xsl:call-template>
            </head>
            <body class="flex min-h-full flex-col">
                <xsl:call-template name="nav_bar"/>
                <main id="main" tabindex="-1" class="flex grow flex-col">
                    <xsl:apply-templates select=".//tei:body/tei:figure"/>
                    <div class="prose mx-auto max-w-5xl">
                        <h1 class="text-balance  xl:text-5xl"><xsl:value-of select="replace(i18n:t('project__title'),' – ', '&#160;– ')"/></h1>
                        <xsl:apply-templates select=".//tei:body/tei:div"/>
                    </div>
                </main>
                <xsl:call-template name="html_footer"/>
            </body>
        </html>
    </xsl:template>

    <!-- bilingual TEI: leave out content in the other language -->
    <xsl:template match="tei:*[@xml:lang][@xml:lang != $lang]" priority="10"/>
</xsl:stylesheet>
