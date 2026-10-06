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
        <xsl:variable name="doc_title" select="i18n:t('search__title')"/>
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
                        <div class="p-4 text-center">
                            <div class="mb-4 flex items-center gap-2">
                                <button id="filter-button" aria-label="{i18n:t('search__filter')}" aria-controls="refinements-section"
                                    class="btn btn-outline size-8 shrink-0 p-0 md:hidden" type="button">
                                    <i class="icon-[lucide--sliders-horizontal]" aria-hidden="true"/>
                                </button>
                                <div class="grow" id="searchbox"/>
                            </div>
                            <div id="stats-container"/>
                            <div class="flex items-center justify-between">
                                <div id="current-refinements"/>
                                <div id="clear-refinements"/>
                            </div>
                        </div>

                        <div class="grid gap-6 md:grid-cols-12">
                            <!-- Facets column - sticky -->
                            <div class="md:col-span-3">
                                <div class="sticky top-5 hidden max-h-[calc(100vh-2.5rem)] overflow-y-auto md:block"
                                    id="refinements-section">
                                    <h2 class="sr-only"><xsl:value-of select="i18n:t('search__facets')"/></h2>

                                    <!-- Entitäten Section -->
                                    <div class="mb-4 rounded-lg border border-gray-200 shadow-sm">
                                        <div class="rounded-lg bg-sky-50 p-4">
                                            <h3 class="mb-4 text-lg font-bold">
                                                <i class="icon-[lucide--tags]"/>&#160;<xsl:value-of select="i18n:t('search__entities')"/></h3>
                                            <div id="rf-persons" class="pb-4"/>
                                            <div id="rf-places" class="pb-4"/>
                                            <div id="rf-works" class="pb-4"/>
                                            <div id="rf-bibl" class="pb-4"/>
                                        </div>
                                    </div>
                                    <!-- Sortierung Section -->
                                    <div class="mb-4 rounded-lg border border-gray-200 shadow-sm">
                                        <div class="rounded-lg bg-sky-50 p-4">
                                            <h3 class="mb-4 text-lg font-bold">
                                                <i class="icon-[lucide--arrow-down-wide-narrow]"/>&#160;<xsl:value-of select="i18n:t('search__sort')"/></h3>
                                            <div id="sort-by"/>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <!-- Results column - scrollable -->
                            <div class="md:col-span-9">
                                <div id="hits" class="max-h-[70vh] overflow-y-auto"/>
                                <div id="pagination" class="p-4"/>
                            </div>
                        </div>
                    </div>
                </main>
                <xsl:call-template name="html_footer"/>
                <xsl:call-template name="typesense_libs"/>
                <script src="{$base}js/search.js"/>
            </body>
        </html>
    </xsl:template>
</xsl:stylesheet>
