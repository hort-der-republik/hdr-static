<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    version="2.0">
    <xsl:template name="tabulator_dl_buttons">
        <h4>Download Table</h4>
        <div class="flex gap-2">
            <button type="button" class="btn btn-outline" id="download-csv" title="Download CSV">
                <i class="icon-[lucide--file-spreadsheet]"></i>
                <span class="sr-only">Download CSV</span>
            </button>
            <button type="button" class="btn btn-outline" id="download-json" title="Download JSON">
                <i class="icon-[lucide--file-braces]"></i>
                <span class="sr-only">Download JSON</span>
            </button>
            <button type="button" class="btn btn-outline" id="download-html" title="Download HTML">
                <i class="icon-[lucide--file-code]"></i>
                <span class="sr-only">Download HTML</span>
            </button>
        </div>
    </xsl:template>
</xsl:stylesheet>