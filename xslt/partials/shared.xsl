<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:i18n="urn:hdr-static:i18n"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="#all"
    version="2.0">

    <xsl:import href="entities.xsl"/>

    <xsl:template match="tei:div">
        <div><xsl:apply-templates/></div>
    </xsl:template>
    <xsl:template match="tei:pb">
        <span class="anchor-pb"></span>
        <span class="pb" source="{@facs}"><xsl:value-of select="./@n"/></span>
    </xsl:template>
    <xsl:template match="tei:unclear">
        <abbr title="unclear"><xsl:apply-templates/></abbr>
    </xsl:template>
    <xsl:template match="tei:del">
        <del><xsl:apply-templates/></del>
    </xsl:template>
    <xsl:template match="tei:cit">
        <cite><xsl:apply-templates/></cite>
    </xsl:template>
    <xsl:template match="tei:quote">
        <xsl:apply-templates/>
    </xsl:template>
    <xsl:template match="tei:date">
        <span class="date"><xsl:apply-templates/></span>
    </xsl:template>
    <xsl:template match="tei:figure">
        <figure class="mb-6">
            <xsl:apply-templates select="tei:graphic"/>
            <xsl:if test="tei:figDesc">
                <figcaption class="ps-2 mt-2 text-sm text-gray-600"><xsl:apply-templates select="tei:figDesc"/></figcaption>
            </xsl:if>
        </figure>
    </xsl:template>
    <!-- responsive WebP versions of the images in data/img/, written by tools/images.ts (run from build.xml) -->
    <xsl:variable name="image-manifest" select="if (doc-available('../../html/img/images.xml')) then doc('../../html/img/images.xml') else ()"/>
    <!-- rendered width of an image spanning the content column: .container width minus its padding -->
    <xsl:variable name="image-sizes" select="'(min-width: 96rem) 94rem, (min-width: 80rem) 78rem, (min-width: 64rem) 62rem, (min-width: 48rem) 46rem, (min-width: 40rem) 38rem, calc(100vw - 2rem)'"/>

    <xsl:template match="tei:graphic">
        <xsl:variable name="name" select="tokenize(@url, '/')[last()]"/>
        <xsl:variable name="image" select="$image-manifest/images/image[@name = $name]"/>
        <!-- the first image of a page is usually in view right away: load it eagerly and early -->
        <xsl:variable name="first" select="empty(preceding::tei:graphic)"/>
        <!-- natural size, capped at the column width; tei:graphic/@width (e.g. "100%", "12rem") overrides it -->
        <xsl:variable name="style" as="attribute()?">
            <xsl:if test="@width">
                <xsl:attribute name="style" select="concat('width: ', @width)"/>
            </xsl:if>
        </xsl:variable>
        <xsl:choose>
            <xsl:when test="$image">
                <!-- src: the first variant at least 1280px wide, for clients without srcset support -->
                <img src="{$base}img/{($image/variant[xs:integer(@width) ge 1280], $image/variant)[1]/@file}" srcset="{string-join($image/variant/concat($base, 'img/', @file, ' ', @width, 'w'), ', ')}" sizes="{$image-sizes}" width="{$image/@width}" height="{$image/@height}" alt="" class="h-auto max-w-full" loading="{if ($first) then 'eager' else 'lazy'}" fetchpriority="{if ($first) then 'high' else 'auto'}">
                    <xsl:sequence select="$style"/>
                </img>
            </xsl:when>
            <xsl:otherwise>
                <xsl:if test="not(ends-with(lower-case($name), '.svg'))">
                    <xsl:message>[images] <xsl:value-of select="$name"/> is not in html/img/images.xml – is it in data/img/?</xsl:message>
                </xsl:if>
                <!-- SVG logos have no intrinsic size and would span the column: half width on large screens -->
                <xsl:variable name="logo" select="ends-with(lower-case($name), '.svg') and contains(lower-case($name), 'logo')"/>
                <img src="{$base}img/{$name}" alt="" class="h-auto max-w-full{if ($logo) then ' w-full lg:w-1/2' else ''}">
                    <xsl:sequence select="$style"/>
                </img>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="tei:lb">
        <br/>
    </xsl:template>

    <xsl:template match="tei:note">
        <xsl:element name="a">
            <xsl:attribute name="name">
                <xsl:text>fna_</xsl:text>
                <xsl:number level="any" format="1" count="tei:note"/>
            </xsl:attribute>
            <xsl:attribute name="href">
                <xsl:text>#fn</xsl:text>
                <xsl:number level="any" format="1" count="tei:note"/>
            </xsl:attribute>
            <xsl:attribute name="title">
                <xsl:value-of select="normalize-space(.)"/>
            </xsl:attribute>
            <sup>
                <xsl:number level="any" format="1" count="tei:note"/>
            </sup>
        </xsl:element>
    </xsl:template>

    <xsl:template match="tei:list[@type='unordered']">
        <xsl:choose>
            <xsl:when test="ancestor::tei:body">
                <ul>
                    <xsl:apply-templates/>
                </ul>
            </xsl:when>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="tei:item">
        <xsl:choose>
            <xsl:when test="parent::tei:list[@type='unordered']|ancestor::tei:body">
                <li><xsl:apply-templates/></li>
            </xsl:when>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="tei:hi">
        <span>
            <xsl:choose>
                <xsl:when test="@rendition = '#em'">
                    <xsl:attribute name="class">
                        <xsl:text>italic</xsl:text>
                    </xsl:attribute>
                </xsl:when>
                <xsl:when test="@rendition = '#italic'">
                    <xsl:attribute name="class">
                        <xsl:text>italic</xsl:text>
                    </xsl:attribute>
                </xsl:when>
                <xsl:when test="@rendition = '#smallcaps'">
                    <xsl:attribute name="class">
                        <xsl:text>smallcaps</xsl:text>
                    </xsl:attribute>
                </xsl:when>
                <xsl:when test="@rendition = '#bold'">
                    <xsl:attribute name="class">
                        <xsl:text>bold</xsl:text>
                    </xsl:attribute>
                </xsl:when>
            </xsl:choose>
            <xsl:apply-templates/>
        </span>
    </xsl:template>

    <xsl:template match="tei:ref">
        <a class="ref {@type}" href="{@target}"><xsl:apply-templates/></a>
    </xsl:template>
    <xsl:template match="tei:lg">
        <p><xsl:apply-templates/></p>
    </xsl:template>
    <xsl:template match="tei:l">
        <xsl:apply-templates/><br/>
    </xsl:template>
    <xsl:template match="tei:p">
       <p><xsl:apply-templates/></p>
    </xsl:template>

    <xsl:template match="tei:table">
        <xsl:element name="table">
            <xsl:attribute name="class">
                <xsl:text>w-full border-collapse</xsl:text>
            </xsl:attribute>
            <xsl:element name="tbody">
                <xsl:apply-templates/>
            </xsl:element>
        </xsl:element>
    </xsl:template>
    <xsl:template match="tei:row">
        <xsl:element name="tr">
            <xsl:attribute name="class">odd:bg-gray-50 hover:bg-gray-100</xsl:attribute>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>
    <xsl:template match="tei:cell">
        <xsl:element name="td">
            <xsl:attribute name="class">border border-gray-300 px-2 py-1</xsl:attribute>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>
    <xsl:template match="tei:rs">
        <xsl:choose>
            <xsl:when test="count(tokenize(@ref, ' ')) > 1">
                <xsl:choose>
                    <xsl:when test="@type='person'">
                        <span class="persons">
                            <xsl:apply-templates/>
                            <xsl:for-each select="tokenize(@ref, ' ')">
                                <sup class="entity" data-dialog="{.}">
                                    <xsl:value-of select="position()"/>
                                </sup>
                                <xsl:if test="position() != last()">
                                    <sup class="entity">/</sup>
                                </xsl:if>
                            </xsl:for-each>
                        </span>
                    </xsl:when>
                    <xsl:when test="@type='place'">
                        <span class="places">
                            <xsl:apply-templates/>
                            <xsl:for-each select="tokenize(@ref, ' ')">
                                <sup class="entity" data-dialog="{.}">
                                    <xsl:value-of select="position()"/>
                                </sup>
                                <xsl:if test="position() != last()">
                                    <sup class="entity">/</sup>
                                </xsl:if>
                            </xsl:for-each>
                        </span>
                    </xsl:when>
                    <xsl:when test="@type='bibl'">
                        <span class="works">
                            <xsl:apply-templates/>
                            <xsl:for-each select="tokenize(@ref, ' ')">
                                <sup class="entity" data-dialog="{.}">
                                    <xsl:value-of select="position()"/>
                                </sup>
                                <xsl:if test="position() != last()">
                                    <sup class="entity">/</sup>
                                </xsl:if>
                            </xsl:for-each>
                        </span>
                    </xsl:when>
                    <xsl:when test="@type='org'">
                        <span class="orgs" id="{@xml:id}">
                            <xsl:apply-templates/>
                            <xsl:for-each select="tokenize(@ref, ' ')">
                                <sup class="entity" data-dialog="{.}">
                                    <xsl:value-of select="position()"/>
                                </sup>
                                <xsl:if test="position() != last()">
                                    <sup class="entity">/</sup>
                                </xsl:if>
                            </xsl:for-each>
                        </span>
                    </xsl:when>
                </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
                <xsl:choose>
                    <xsl:when test="@type='person'">
                        <span class="persons entity" data-dialog="{@ref}">
                            <xsl:apply-templates/>
                        </span>
                    </xsl:when>
                    <xsl:when test="@type='place'">
                        <span class="places entity" data-dialog="{@ref}">
                            <xsl:apply-templates/>
                        </span>
                    </xsl:when>
                    <xsl:when test="@type='bibl'">
                        <span class="works entity" data-dialog="{@ref}">
                            <xsl:apply-templates/>
                        </span>
                    </xsl:when>
                    <xsl:when test="@type='org'">
                        <span class="orgs entity" data-dialog="{@ref}">
                            <xsl:apply-templates/>
                        </span>
                    </xsl:when>
                    <xsl:when test="@type='institution'">
                        <span class="orgs entity" data-dialog="{@ref}">
                            <xsl:apply-templates/>
                        </span>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:apply-templates/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="tei:listPerson">
        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="tei:person">
        <xsl:variable name="selfLink">
            <xsl:value-of select="concat(data(@xml:id), '.html')"/>
        </xsl:variable>
        <xsl:variable name="name" select="normalize-space(string-join(./tei:persName[1]//text()))"></xsl:variable>
        <dialog id="{@xml:id}" aria-label="{$name}" class="m-auto w-full max-w-lg rounded-lg p-0 shadow-xl backdrop:bg-black/50">
            <div class="border-b border-gray-200 px-4 py-3">
                <h1 class="mb-0 text-xl"><a href="{$selfLink}"><xsl:value-of select="$name"/></a></h1>
            </div>
            <div class="prose max-w-none px-4 py-3">
                <xsl:call-template name="person_detail"/>
            </div>
            <form method="dialog" class="border-t border-gray-200 px-4 py-3 text-end">
                <button class="btn btn-secondary"><xsl:value-of select="i18n:t('common__close')"/></button>
            </form>
        </dialog>
    </xsl:template>

    <xsl:template match="tei:listPlace">
        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="tei:place">
        <xsl:variable name="selfLink">
            <xsl:value-of select="concat(data(@xml:id), '.html')"/>
        </xsl:variable>
        <xsl:variable name="name" select="normalize-space(string-join(./tei:placeName[1]//text()))"></xsl:variable>
        <dialog id="{@xml:id}" aria-label="{$name}" class="m-auto w-full max-w-lg rounded-lg p-0 shadow-xl backdrop:bg-black/50">
            <div class="border-b border-gray-200 px-4 py-3">
                <h1 class="mb-0 text-xl"><a href="{$selfLink}"><xsl:value-of select="$name"/></a></h1>
            </div>
            <div class="prose max-w-none px-4 py-3">
                <xsl:call-template name="place_detail"/>
            </div>
            <form method="dialog" class="border-t border-gray-200 px-4 py-3 text-end">
                <button class="btn btn-secondary"><xsl:value-of select="i18n:t('common__close')"/></button>
            </form>
        </dialog>
    </xsl:template>

    <xsl:template match="tei:listOrg">
        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="tei:org">
        <xsl:variable name="selfLink">
            <xsl:value-of select="concat(data(@xml:id), '.html')"/>
        </xsl:variable>
        <xsl:variable name="name" select="normalize-space(string-join(./tei:orgName[1]//text()))"></xsl:variable>
        <dialog id="{@xml:id}" aria-label="{$name}" class="m-auto w-full max-w-lg rounded-lg p-0 shadow-xl backdrop:bg-black/50">
            <div class="border-b border-gray-200 px-4 py-3">
                <h1 class="mb-0 text-xl"><a href="{$selfLink}"><xsl:value-of select="$name"/></a></h1>
            </div>
            <div class="prose max-w-none px-4 py-3">
                <xsl:call-template name="org_detail"/>
            </div>
            <form method="dialog" class="border-t border-gray-200 px-4 py-3 text-end">
                <button class="btn btn-secondary"><xsl:value-of select="i18n:t('common__close')"/></button>
            </form>
        </dialog>
    </xsl:template>


    <xsl:template match="tei:listBibl">
        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="tei:bibl">
        <xsl:variable name="selfLink">
            <xsl:value-of select="concat(data(@xml:id), '.html')"/>
        </xsl:variable>
        <xsl:variable name="name" select="normalize-space(string-join(./tei:title[1]//text()))"></xsl:variable>
        <dialog id="{@xml:id}" aria-label="{$name}" class="m-auto w-full max-w-lg rounded-lg p-0 shadow-xl backdrop:bg-black/50">
            <div class="border-b border-gray-200 px-4 py-3">
                <h1 class="mb-0 text-xl"><a href="{$selfLink}"><xsl:value-of select="$name"/></a></h1>
            </div>
            <div class="prose max-w-none px-4 py-3">
                <xsl:call-template name="bibl_detail"/>
            </div>
            <form method="dialog" class="border-t border-gray-200 px-4 py-3 text-end">
                <button class="btn btn-secondary"><xsl:value-of select="i18n:t('common__close')"/></button>
            </form>
        </dialog>
    </xsl:template>
</xsl:stylesheet>
