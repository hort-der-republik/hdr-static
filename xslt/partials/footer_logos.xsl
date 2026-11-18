<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:i18n="urn:hdr-static:i18n"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="#all" version="3.0">
	<xsl:template name="footer_logos">
		<ul role="list">
			<li>
				<div>
					<xsl:variable name="fwf-logo-path" select="'images/logos/fwf/'||$lang||'/'"/>
					<xsl:variable name="fwf-logo" select="uri-collection('../../html/'||$fwf-logo-path||'?select=*')"/>
					<a href="{i18n:t('fwf__url')}">
						<img width="250" class="block" alt="" src="{$base||$fwf-logo-path||tokenize($fwf-logo,'/')[last()]}"/>
						<span class="sr-only"><xsl:value-of select="i18n:t('fwf__name')"/></span>
					</a>
						<p class="prose text-xs"><xsl:value-of select="i18n:t('fwf__tagline')"/></p>
				</div>
			</li>
		</ul>
  </xsl:template>
</xsl:stylesheet>
