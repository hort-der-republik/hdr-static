<?xml version="1.0" encoding="UTF-8"?>
<!-- html/index.html: GitHub Pages has no server-side redirects, so send visitors
     to the default language's start page from here -->
<xsl:stylesheet
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:i18n="urn:hdr-static:i18n"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    version="2.0"
    exclude-result-prefixes="#all">
    <xsl:include href="./partials/params.xsl"/>
    <xsl:include href="./partials/i18n.xsl"/>
    <xsl:output encoding="UTF-8" media-type="text/html" method="html" version="5.0" indent="yes" omit-xml-declaration="yes"/>

    <xsl:template match="/">
        <xsl:variable name="target" select="concat($default_lang, '/')"/>
        <html lang="{$default_lang}">
            <head>
                <meta charset="utf-8"/>
                <title><xsl:value-of select="i18n:t('project__short_title')"/></title>
                <meta http-equiv="refresh" content="0; url={$target}"/>
                <link rel="canonical" href="{$base_url}{$target}"/>
            </head>
            <body>
                <ul>
                    <xsl:for-each select="$languages">
                        <li><a href="{.}/" hreflang="{.}" lang="{.}"><xsl:value-of select="i18n:t('language__name', .)"/></a></li>
                    </xsl:for-each>
                </ul>
            </body>
        </html>
    </xsl:template>
</xsl:stylesheet>
