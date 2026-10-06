<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:i18n="urn:hdr-static:i18n"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    version="2.0"
    exclude-result-prefixes="#all">

    <xsl:import href="./partials/shared.xsl"/>
    <xsl:import href="./partials/html_navbar.xsl"/>
    <xsl:import href="./partials/html_head.xsl"/>
    <xsl:import href="./partials/html_footer.xsl"/>
    <xsl:import href="./partials/zotero.xsl"/>
    <xsl:output encoding="UTF-8" media-type="text/html" method="html" version="5.0" indent="yes" omit-xml-declaration="yes"/>


    <xsl:template match="/">
        <xsl:variable name="titles" select=".//tei:titleStmt/tei:title[@type = 'main']"/>
        <xsl:variable name="doc_title" select="normalize-space(($titles[@level = 'a'][@xml:lang = $lang], $titles[@level = 'a'], $titles)[1])"/>
        <html class="h-full" lang="{$lang}">
            <head>
                <xsl:call-template name="html_head">
                    <xsl:with-param name="html_title" select="$doc_title"></xsl:with-param>
                </xsl:call-template>
                <xsl:call-template name="zoterMetaTags">
                    <xsl:with-param name="pageId" select="$page"></xsl:with-param>
                    <xsl:with-param name="zoteroTitle" select="$doc_title"></xsl:with-param>
                </xsl:call-template>
                <!-- add the name of the author of the current article -->
                <meta name="citation_author" content="Foo, Bar"/>
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
                    <div class="prose max-w-5xl">
                        <h1><xsl:value-of select="$doc_title"/></h1>
                        <xsl:apply-templates select=".//tei:body" />

                    </div>
                </main>
                <xsl:call-template name="html_footer">
                    <xsl:with-param name="pageId" select="$page"/>
                </xsl:call-template>
            </body>
        </html>
    </xsl:template>

    <!-- bilingual TEI: leave out content in the other language -->
    <xsl:template match="tei:*[@xml:lang][@xml:lang != $lang]" priority="10"/>

    <xsl:template match="tei:p">
        <p id="{generate-id()}"><xsl:apply-templates/></p>
    </xsl:template>
    <xsl:template match="tei:div">
        <div id="{generate-id()}"><xsl:apply-templates/></div>
    </xsl:template>
</xsl:stylesheet>
