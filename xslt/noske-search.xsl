<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:i18n="urn:hdr-static:i18n"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    version="2.0"
    exclude-result-prefixes="#all">

    <xsl:import href="./partials/html_navbar.xsl"/>
    <xsl:import href="./partials/html_head.xsl"/>
    <xsl:import href="./partials/html_footer.xsl"/>
    <xsl:import href="./partials/typesense_libs.xsl"/>
    <xsl:output encoding="UTF-8" media-type="text/html" method="html" version="5.0" indent="yes" omit-xml-declaration="yes"/>

    <xsl:template match="/">
        <xsl:variable name="doc_title" select="i18n:t('noske__title')"/>
        <html class="h-full" lang="{$lang}">
            <head>
                <xsl:call-template name="html_head">
                    <xsl:with-param name="html_title" select="$doc_title"/>
                </xsl:call-template>
                <link rel="stylesheet" href="{$base}css/search.css" type="text/css"/>
            </head>

            <body class="flex min-h-full flex-col">
                <xsl:call-template name="nav_bar"/>
                <main id="main" tabindex="-1" class="container flex grow flex-col gap-y-12 py-6">
                    <nav aria-label="{i18n:t('breadcrumb__label')}">
                        <ol class="breadcrumb">
                            <li>
                                <a href="index.html">
                                    <xsl:value-of select="i18n:t('project__short_title')"/>
                                </a>
                            </li>
                            <li aria-current="page">
                                <xsl:value-of select="$doc_title"/>
                            </li>
                        </ol>
                    </nav>
                    <div>
                        <h1 class="text-center text-5xl font-light">
                            <xsl:value-of select="$doc_title"/>
                        </h1>
                        <div>
                            <div id="noske-search"></div>
                            <div class="p-2 text-center" id="reset-button">
                                <a href="noske-search.html" class="btn btn-primary"><xsl:value-of select="i18n:t('noske__reset')"/></a>
                            </div>
                            <div id="noske-stats"></div>
                            <div id="hitsbox"></div>
                            <div id="noske-pagination" class="p-4"></div>
                        </div>
                    </div>
                </main>
                <xsl:call-template name="html_footer"/>
                <script src="{$base}js/noske-search.js" type="module"></script>
    
            </body>
        </html>
    </xsl:template>
</xsl:stylesheet>
