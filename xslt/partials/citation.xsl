<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:i18n="urn:hdr-static:i18n"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="#all"
    version="2.0">
    <!-- citation suggestion, shown in the footer (html_footer.xsl passes the pageId on) -->
    <xsl:template name="citation">
        <xsl:param name="pageId" select="''"></xsl:param>
        <xsl:param name="customUrl" select="concat($base_url, $lang, '/')"></xsl:param>
        <xsl:variable name="fullUrl" select="concat($customUrl, $pageId)"/>
        <div aria-labelledby="citation-label" class="prose text-left text-sm border-gray-200 text-gray-700">
            <dl>
                <dt id="citation-label" class="mb-1 font-semibold text-gray-900"><xsl:value-of select="i18n:t('cite__heading')"/></dt>
                <dd>
                    <cite class="italic"><xsl:value-of select="i18n:t('project__title')"/></cite>, <xsl:value-of select="i18n:t('cite__editors')"/> (<a href="{$fullUrl}"><xsl:value-of select="$fullUrl"/></a>)
                </dd>
            </dl>
        </div>
    </xsl:template>
</xsl:stylesheet>
