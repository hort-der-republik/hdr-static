<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:i18n="urn:hdr-static:i18n"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="#all" version="3.0">
	<xsl:template name="footer_logos">
		<ul role="list" class="items-start flex flex-col md:flex-row gap-12">
			<li class="shrink-0">
				<div class="w-fit max-w-full">
					<xsl:variable name="fwf-logo-path" select="'images/logos/fwf/'||$lang||'/'"/>
					<xsl:variable name="fwf-logo" select="uri-collection('../../html/'||$fwf-logo-path||'?select=*')
					"/>
					<a href="{i18n:t('fwf__url')}">
						<img class="block  w-full h-22 object-contain" alt="" src="{$base||$fwf-logo-path||tokenize($fwf-logo,'/')[last()]}"/>
						<span class="sr-only"><xsl:value-of select="i18n:t('fwf__name')"/></span>
					</a>
						<p class="prose text-xs  [contain:inline-size]"><xsl:value-of select="i18n:t('fwf__tagline')"/></p>
				</div>
			</li>
			<li class="shrink-0">
				<div>
					<a href="{i18n:t('lbidh__url')}">
						<img class="block  w-full h-16 object-contain" alt="" src="https://geschichte.lbg.ac.at/wp-content/uploads/sites/10/2022/10/EN_DH.svg"/>
						<span class="sr-only"><xsl:value-of select="i18n:t('lbidh__name')"/></span>
					</a>
				</div>
			</li>
			<li class="shrink-0">
				<div>
					<xsl:variable name="acdh-logo-path" select="'images/logos/acdh/'||$lang||'/'"/>
					<xsl:variable name="acdh-logo" select="uri-collection('../../html/'||$acdh-logo-path||'?select=*')"/>
					<a href="{i18n:t('acdh__url')}">
						<img class="block w-full h-16 object-contain" alt="" src="{$base||$acdh-logo-path||tokenize($acdh-logo,'/')[last()]}"/>
						<span class="sr-only"><xsl:value-of select="i18n:t('acdh__name')"/></span>
					</a>
				</div>
			</li>
		</ul>
  </xsl:template>
</xsl:stylesheet>
