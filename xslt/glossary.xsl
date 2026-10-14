<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:i18n="urn:hdr-static:i18n"
    xmlns:gl="urn:hdr-static:glossary"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    version="2.0"
    exclude-result-prefixes="#all">

    <!-- data model glossary, rendered from data/meta/glossary.xml (a TEI dictionary: entry/form/sense/def/note) -->
    <xsl:import href="./partials/shared.xsl"/>
    <xsl:import href="./partials/html_navbar.xsl"/>
    <xsl:import href="./partials/html_head.xsl"/>
    <xsl:import href="./partials/html_footer.xsl"/>
    <xsl:output encoding="UTF-8" media-type="text/html" method="html" version="5.0" indent="yes" omit-xml-declaration="yes"/>

    <xsl:key name="by-id" match="*[@xml:id]" use="@xml:id"/>

    <!-- label of a taxonomy category (note types, mapping relations) in the page language -->
    <xsl:function name="gl:label" as="xs:string">
        <xsl:param name="context" as="node()"/>
        <xsl:param name="id" as="xs:string"/>
        <xsl:param name="fallback" as="xs:string"/>
        <xsl:variable name="catDesc" select="key('by-id', $id, root($context))/tei:catDesc"/>
        <xsl:sequence select="normalize-space(($catDesc[@xml:lang = $lang], $catDesc[not(@xml:lang)], $fallback)[1])"/>
    </xsl:function>

    <xsl:template match="/">
        <xsl:variable name="titles" select="/tei:TEI/tei:teiHeader/tei:fileDesc/tei:titleStmt/tei:title[@type = 'main']"/>
        <xsl:variable name="doc_title" select="normalize-space($titles[@level = 'a'][@xml:lang = $lang])"/>
        <!-- the draft note, e.g. "Arbeitsfassung." -->
        <xsl:variable name="draft" select="/tei:TEI/tei:teiHeader/tei:revisionDesc[@status = 'draft']/tei:change[not(@xml:lang != $lang)][1]"/>
        <html class="h-full" lang="{$lang}">
            <head>
                <xsl:call-template name="html_head">
                    <xsl:with-param name="html_title" select="$doc_title"/>
                </xsl:call-template>
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
                        <xsl:if test="$draft">
                            <p class="text-gray-600"><xsl:value-of select="normalize-space($draft)"/></p>
                        </xsl:if>
                        <xsl:apply-templates select="/tei:TEI/tei:text/tei:body/tei:div"/>
                    </div>
                </main>
                <xsl:call-template name="html_footer">
                    <xsl:with-param name="pageId" select="$page"/>
                </xsl:call-template>
            </body>
        </html>
    </xsl:template>

    <!-- bilingual TEI: leave out content in the other language;
         language-neutral content has no xml:lang -->
    <xsl:template match="tei:*[@xml:lang][@xml:lang != $lang]" priority="10"/>

    <!-- the page title is the h1; the entries follow directly -->
    <xsl:template match="tei:div[@type = 'glossary']">
        <xsl:apply-templates select="tei:entry"/>
    </xsl:template>

    <xsl:template match="tei:entry">
        <xsl:variable name="lemma" select="(tei:form[@type = 'lemma'][@xml:lang = $lang], tei:form[@type = 'lemma'])[1]/tei:orth"/>
        <xsl:variable name="notes" select="tei:note[not(@xml:lang != $lang)]"/>
        <section id="{@xml:id}" class="border-t border-gray-200 pt-6">
            <h2><xsl:value-of select="normalize-space($lemma)"/></h2>
            <xsl:apply-templates select="tei:sense"/>
            <xsl:if test="$notes">
                <dl>
                    <!-- one term/description pair per note type, in document order -->
                    <xsl:for-each-group select="$notes" group-by="@type">
                        <xsl:variable name="label" select="gl:label(., concat('note-', current-grouping-key()), current-grouping-key())"/>
                        <dt><xsl:value-of select="concat(upper-case(substring($label, 1, 1)), substring($label, 2))"/></dt>
                        <dd class="break-words">
                            <xsl:apply-templates select="current-group()"/>
                        </dd>
                    </xsl:for-each-group>
                </dl>
            </xsl:if>
        </section>
    </xsl:template>

    <!-- senses a./b. keep their id: other entries link to them (#traeger-a) -->
    <xsl:template match="tei:sense">
        <div>
            <xsl:if test="@xml:id">
                <xsl:attribute name="id" select="@xml:id"/>
            </xsl:if>
            <xsl:apply-templates select="tei:def"/>
        </div>
    </xsl:template>

    <xsl:template match="tei:def">
        <p>
            <xsl:if test="../@n">
                <span class="me-2 font-semibold"><xsl:value-of select="../@n"/>.</span>
            </xsl:if>
            <xsl:apply-templates/>
        </p>
    </xsl:template>

    <!-- notes are structured fields of an entry, not footnotes (shared.xsl turns tei:note into footnote anchors) -->
    <xsl:template match="tei:note">
        <div>
            <xsl:apply-templates/>
        </div>
    </xsl:template>

    <xsl:template match="tei:list">
        <ul>
            <xsl:apply-templates select="tei:item"/>
        </ul>
    </xsl:template>

    <xsl:template match="tei:item">
        <li><xsl:apply-templates/></li>
    </xsl:template>

    <!-- mapping to an external concept: relation (@ana → taxonomy mappingRelations),
         sense it applies to (@corresp), certainty (@cert) -->
    <xsl:template match="tei:item[@ana or @corresp or @cert]">
        <xsl:variable name="relations" select="for $r in tokenize(@ana, '\s+')[starts-with(., '#')] return gl:label(current(), substring($r, 2), substring($r, 2))"/>
        <xsl:variable name="senses" select="for $s in tokenize(@corresp, '\s+')[starts-with(., '#')] return key('by-id', substring($s, 2))"/>
        <li>
            <xsl:apply-templates/>
            <span class="text-gray-600">
                <xsl:if test="exists($relations)">
                    <xsl:text> – </xsl:text>
                    <xsl:value-of select="string-join($relations, ', ')"/>
                </xsl:if>
                <xsl:for-each select="$senses[@n]">
                    <xsl:text> (</xsl:text>
                    <a href="#{@xml:id}"><xsl:value-of select="@n"/>.</a>
                    <xsl:text>)</xsl:text>
                </xsl:for-each>
                <xsl:if test="@cert != 'high'">
                    <xsl:text> [cert: </xsl:text>
                    <xsl:value-of select="@cert"/>
                    <xsl:text>]</xsl:text>
                </xsl:if>
            </span>
        </li>
    </xsl:template>

    <!-- the typography plugin wraps code in backticks; the angle brackets of gi are enough -->
    <xsl:template match="tei:gi">
        <code class="before:content-none after:content-none">&lt;<xsl:apply-templates/>&gt;</code>
    </xsl:template>
    <xsl:template match="tei:idno">
        <code class="before:content-none after:content-none"><xsl:apply-templates/></code>
    </xsl:template>
    <xsl:template match="tei:num">
        <span class="whitespace-nowrap"><xsl:apply-templates/></span>
    </xsl:template>

    <!-- resources used for the mapping, below the entries -->
    <xsl:template match="tei:div[@type = 'sources']">
        <xsl:apply-templates select="tei:listBibl"/>
    </xsl:template>

    <xsl:template match="tei:listBibl">
        <section id="{@xml:id}" class="border-t border-gray-200 pt-6">
            <xsl:apply-templates select="tei:head"/>
            <ul>
                <xsl:apply-templates select="tei:bibl"/>
            </ul>
        </section>
    </xsl:template>

    <xsl:template match="tei:listBibl/tei:head">
        <h2><xsl:apply-templates/></h2>
    </xsl:template>

    <!-- xml:lang on a bibl is the language of the cited resource, not of the page: show all of them -->
    <xsl:template match="tei:bibl" priority="11">
        <li id="{@xml:id}"><xsl:apply-templates/></li>
    </xsl:template>

    <xsl:template match="tei:bibl/tei:title">
        <cite class="italic"><xsl:apply-templates/></cite>
    </xsl:template>
</xsl:stylesheet>
