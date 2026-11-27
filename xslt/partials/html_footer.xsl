<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="#all" version="2.0">
    <xsl:import href="./citation.xsl"/>
		<xsl:import href="./footer_logos.xsl"/>
    <xsl:template name="html_footer">
        <!-- file name of the current page, cited in the footer; empty cites the language start page -->
        <xsl:param name="pageId" select="''"/>
        <footer class="py-4 mt-8 border-t border-gray-200">
				<div class="container py-8 px-8 flex flex-col gap-y-12">
							<xsl:call-template name="footer_logos"/>
            <div
                class="flex flex-col items-center gap-12 lg:flex-row justify-between">
                <xsl:call-template name="citation">
                    <xsl:with-param name="pageId" select="$pageId"/>
                </xsl:call-template>
                <div>
                    <a href="{$github_url}" class="text-gray-700 hover:text-gray-900">
                        <i aria-hidden="true" class="icon-[simple-icons--github] text-3xl"/>
                        <span class="sr-only">GitHub repo</span>
                    </a>
                </div>
            </div>
						</div>
        </footer>
    </xsl:template>
</xsl:stylesheet>
