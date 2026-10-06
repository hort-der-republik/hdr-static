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
    <xsl:import href="./partials/tabulator_dl_buttons.xsl"/>
    <xsl:import href="./partials/tabulator_js.xsl"/>
    <xsl:import href="./partials/entities.xsl"/>
    <xsl:import href="./partials/zotero.xsl"/>
    <xsl:output encoding="UTF-8" media-type="text/html" method="html" version="5.0" indent="yes" omit-xml-declaration="yes"/>


    <xsl:template match="/">
        <xsl:variable name="doc_title">
            <xsl:value-of select=".//tei:titleStmt/tei:title[1]/text()"/>
        </xsl:variable>
        <xsl:variable name="link" select="'listplace.html'"/>
        <html class="h-full" lang="{$lang}">
            <head>
                <xsl:call-template name="html_head">
                    <xsl:with-param name="html_title" select="$doc_title"></xsl:with-param>
                </xsl:call-template>
                <xsl:call-template name="zoterMetaTags">
                    <xsl:with-param name="pageId" select="$link"></xsl:with-param>
                    <xsl:with-param name="zoteroTitle" select="$doc_title"></xsl:with-param>
                </xsl:call-template>
                <link href="{$base}vendor/tabulator-tables/css/tabulator.min.css" rel="stylesheet"/>
                <link rel="stylesheet" href="{$base}vendor/leaflet/leaflet.css"/>
                <script src="{$base}vendor/leaflet/leaflet.js"/>
                <link rel="stylesheet"
                    href="{$base}vendor/leaflet.markercluster/MarkerCluster.css"/>
                <link rel="stylesheet"
                    href="{$base}vendor/leaflet.markercluster/MarkerCluster.Default.css"/>
                <script src="{$base}vendor/leaflet.markercluster/leaflet.markercluster.js"/>
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
                        <h1><xsl:value-of select="$doc_title"/></h1>
                        <div id="map"/>
                        <table id="placesTable">
                            <thead>
                                <tr>
                                    <th scope="col">Ortsname</th>
                                    <th scope="col">Erwähnungen</th>
                                    <th scope="col">lat</th>
                                    <th scope="col">lng</th>
                                    <th scope="col">linkToEntity</th>
                                </tr>
                            </thead>
                            <tbody>
                                <xsl:for-each select=".//tei:place[@xml:id]">
                                    <xsl:variable name="id">
                                        <xsl:value-of select="data(@xml:id)"/>
                                    </xsl:variable>
                                    <tr>
                                        <td>
                                            <xsl:value-of select="./tei:placeName[1]/text()"/>
                                        </td>
                                        <td>
                                            <xsl:value-of select="count(.//tei:note[@type='mentions'])"/>
                                        </td>
                                        <td>
                                            <xsl:choose>
                                                <xsl:when test="./tei:location/tei:geo">
                                                    <xsl:value-of select="replace(tokenize(./tei:location[1]/tei:geo/text(), ' ')[1], ',', '.')"/>
                                                </xsl:when>
                                            </xsl:choose>
                                        </td>
                                        <td>
                                            <xsl:choose>
                                                <xsl:when test="./tei:location/tei:geo">
                                                    <xsl:value-of select="replace(tokenize(./tei:location[1]/tei:geo/text(), ' ')[last()], ',', '.')"/>
                                                </xsl:when>
                                            </xsl:choose>
                                        </td>
                                        <td>
                                            <xsl:value-of select="$id"/>
                                        </td>
                                    </tr>
                                </xsl:for-each>
                            </tbody>
                        </table>
                    </div>
                </main>
                <xsl:call-template name="html_footer">
                    <xsl:with-param name="pageId" select="'listplace.html'"/>
                </xsl:call-template>
                <script type="text/javascript" src="{$base}vendor/tabulator-tables/js/tabulator.min.js"/>
                <script src="{$base}js/map_table_cfg.js"/>
                <script src="{$base}js/make_map_and_table.js"/>
                
                <script>
                    build_map_and_table(map_cfg, table_cfg, wms_cfg=null, tms_cfg=tms_cfg);
                </script>
            </body>
        </html>
        <xsl:for-each select=".//tei:place[@xml:id]">
            <xsl:variable name="filename" select="concat(./@xml:id, '.html')"/>
            <xsl:variable name="name" select="normalize-space(string-join(./tei:placeName[1]//text()))"></xsl:variable>
            <xsl:result-document href="{$filename}">
                <html class="h-full" lang="{$lang}">
                    <head>
                        <xsl:call-template name="html_head">
                            <xsl:with-param name="html_title" select="$name"></xsl:with-param>
                        </xsl:call-template>
                        <xsl:call-template name="zoterMetaTags">
                            <xsl:with-param name="pageId" select="$filename"></xsl:with-param>
                            <xsl:with-param name="zoteroTitle" select="$name"></xsl:with-param>
                        </xsl:call-template>
                    </head>

                    <body class="flex min-h-full flex-col">
                        <xsl:call-template name="nav_bar"/>
                        <main id="main" tabindex="-1" class="container flex grow flex-col gap-y-12 py-6">
                            <nav aria-label="{i18n:t('breadcrumb__label')}">
                                <ol class="breadcrumb">
                                    <li>
                                        <a href="index.html"><xsl:value-of select="i18n:t('project__short_title')"/></a>
                                    </li>
                                    <li>
                                        <a href="listplace.html"><xsl:value-of select="$doc_title"/></a>
                                    </li>
                                </ol>
                            </nav>
                            <div class="prose max-w-none">
                                <h1>
                                    <xsl:value-of select="$name"/>
                                </h1>
                                <xsl:call-template name="place_detail"/>
                                <xsl:if test="./tei:location/tei:geo">
                                    <div id="map_detail"/>
                                </xsl:if>
                            </div>
                        </main>
                        <xsl:call-template name="html_footer">
                            <xsl:with-param name="pageId" select="$filename"/>
                        </xsl:call-template>
                        <xsl:if test="./tei:location/tei:geo">
                            <link rel="stylesheet" href="{$base}vendor/leaflet/leaflet.css"/>
                            <script src="{$base}vendor/leaflet/leaflet.js"></script>
                            <script>
                                var lat = <xsl:value-of select="replace(tokenize(./tei:location[1]/tei:geo[1]/text(), ' ')[1], ',', '.')"/>;
                                var long = <xsl:value-of select="replace(tokenize(./tei:location[1]/tei:geo[1]/text(), ' ')[2], ',', '.')"/>;
                                document.getElementById("map_detail").style.height = "500px";
                                var map = L.map('map_detail').setView([Number(lat), Number(long)], 13);
                                L.tileLayer('https://tile.openstreetmap.org/{z}/{x}/{y}.png', {
                                maxZoom: 19,
                                attribution: '&amp;copy; <a href="http://www.openstreetmap.org/copyright">OpenStreetMap</a>'
                                }).addTo(map);
                                var marker = L.marker([Number(lat), Number(long)]).addTo(map);
                            </script>
                        </xsl:if>
                    </body>
                </html>
            </xsl:result-document>
        </xsl:for-each>
    </xsl:template>
</xsl:stylesheet>