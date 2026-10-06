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

    <xsl:variable name="prev">
        <xsl:value-of select="replace(tokenize(data(tei:TEI/@prev), '/')[last()], '.xml', '.html')"/>
    </xsl:variable>
    <xsl:variable name="next">
        <xsl:value-of select="replace(tokenize(data(tei:TEI/@next), '/')[last()], '.xml', '.html')"/>
    </xsl:variable>
    <xsl:variable name="teiSource">
        <xsl:value-of select="data(tei:TEI/@xml:id)"/>
    </xsl:variable>
    <xsl:variable name="link">
        <xsl:value-of select="replace($teiSource, '.xml', '.html')"/>
    </xsl:variable>
    <xsl:variable name="doc_title">
        <xsl:value-of select=".//tei:titleStmt/tei:title[1]/text()"/>
    </xsl:variable>


    <xsl:template match="/">
        <html class="h-full" lang="{$lang}">
            <head>
                <xsl:call-template name="html_head">
                    <xsl:with-param name="html_title" select="$doc_title"></xsl:with-param>
                </xsl:call-template>
                <xsl:call-template name="zoterMetaTags">
                    <xsl:with-param name="pageId" select="$link"></xsl:with-param>
                    <xsl:with-param name="zoteroTitle" select="$doc_title"></xsl:with-param>
                </xsl:call-template>
                <!-- Provide the names of the authors/editors of the current unit, ideally fetched from the data via xslt or hard coded as below -->
                <meta name="citation_author" content="Foo, Bar"/>
                <meta name="citation_author" content="Bar, Foo"/> 
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
                            <li>
                                <a href="toc.html">
                                    <xsl:value-of select="'Inhaltsverzeichnis'"/>
                                </a>
                            </li>
                            <li aria-current="page">
                                <xsl:value-of select="$doc_title"/>
                            </li>
                        </ol>
                    </nav>
                    <div class="prose max-w-none">
                        <div class="mb-6 grid grid-cols-1 items-center gap-4 md:grid-cols-12">
                            <div class="md:col-span-2">
                                <xsl:if test="ends-with($prev,'.html')">
                                    <a>
                                        <xsl:attribute name="href">
                                            <xsl:value-of select="$prev"/>
                                        </xsl:attribute>
                                        <i class="text-3xl icon-[lucide--chevron-left]" title="Zurück zum vorigen Dokument">
                                            <span class="sr-only">Zurück zum vorigen Dokument</span>
                                        </i>
                                    </a>
                                </xsl:if>
                            </div>
                            <div class="text-center md:col-span-8">
                                <h1>
                                    <xsl:value-of select="$doc_title"/>
                                </h1>
                                <div>
                                    <a href="{$teiSource}">
                                        <i class="icon-[lucide--download] text-3xl" title="Zum TEI/XML Dokument">
                                            <span class="sr-only">Zum TEI/XML Dokument</span>
                                        </i>
                                    </a>
                                </div>
                            </div>
                            <div class="md:col-span-2 md:text-end">
                                <xsl:if test="ends-with($next, '.html')">
                                    <a>
                                        <xsl:attribute name="href">
                                            <xsl:value-of select="$next"/>
                                        </xsl:attribute>
                                        <i class="text-3xl icon-[lucide--chevron-right]" title="Weiter zum nächsten Dokument">
                                            <span class="sr-only">Weiter zum nächsten Dokument</span>
                                        </i>
                                    </a>
                                </xsl:if>
                            </div>
                        </div>
                        <xsl:apply-templates select=".//tei:body"></xsl:apply-templates>
                        <p style="text-align:center;">
                            <xsl:for-each select=".//tei:note[not(./tei:p)]">
                                <div class="footnotes">
                                    <xsl:element name="a">
                                        <xsl:attribute name="name">
                                            <xsl:text>fn</xsl:text>
                                            <xsl:number level="any" format="1" count="tei:note"/>
                                        </xsl:attribute>
                                        <a>
                                            <xsl:attribute name="href">
                                                <xsl:text>#fna_</xsl:text>
                                                <xsl:number level="any" format="1" count="tei:note"/>
                                            </xsl:attribute>
                                            <span style="font-size:7pt;vertical-align:super; margin-right: 0.4em">
                                                <xsl:number level="any" format="1" count="tei:note"/>
                                            </span>
                                        </a>
                                    </xsl:element>
                                    <xsl:apply-templates/>
                                </div>
                            </xsl:for-each>
                        </p>


                    </div>
                    <xsl:for-each select="//tei:back">
                        <div class="tei-back">
                            <xsl:apply-templates/>
                        </div>
                    </xsl:for-each>
                </main>
                <xsl:call-template name="html_footer">
                    <xsl:with-param name="pageId" select="$link"/>
                </xsl:call-template>
                <script src="{$base}vendor/openseadragon-bin-4.1.1/openseadragon.min.js"/>
            </body>
        </html>
    </xsl:template>
</xsl:stylesheet>
