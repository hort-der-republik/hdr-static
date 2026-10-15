<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:i18n="urn:hdr-static:i18n"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="#all" version="2.0">
    <xsl:template name="badge">
        <xsl:param name="text" select="''"/>
        <xsl:param name="class" select="''"/>
        <span class="{$class||' text-sm py-0.5 px-1.5 rounded-md bg-[#333333] text-white'}">
            <xsl:value-of select="$text"/>
        </span>
    </xsl:template>
</xsl:stylesheet>
