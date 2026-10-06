<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:i18n="urn:hdr-static:i18n" exclude-result-prefixes="#all" version="2.0">
    <xsl:template name="nav_bar">
        <a class="sr-only focus:not-sr-only focus:absolute focus:start-2 focus:top-2 focus:z-50 focus:rounded focus:bg-white focus:px-3 focus:py-2" href="#main"><xsl:value-of select="i18n:t('navbar__skip')"/></a>
        <header class="py-4 border-b border-gray-200">
            <div class="flex container justify-between">
                <nav aria-label="Primary" class="flex flex-wrap items-center gap-x-6 gap-y-12 py-2">
                    <a class="text-xl text-gray-900 no-underline hover:text-gray-700" href="{$home}index.html">
                        <xsl:value-of select="i18n:t('project__short_title')"/>
                    </a>
                    <button class="btn btn-outline ms-auto lg:hidden" type="button" data-toggle="collapse" aria-controls="navbarSupportedContent" aria-expanded="false" aria-label="{i18n:t('navbar__toggle')}">
                        <i class="icon-[lucide--menu] text-xl" aria-hidden="true"></i>
                    </button>
                    <div class="hidden w-full lg:flex lg:w-auto lg:grow" id="navbarSupportedContent">
                        <ul class="flex flex-col gap-1 pb-2 lg:flex-row lg:items-center lg:gap-4 lg:pb-0">
                            <li class="relative">
                                <button class="flex items-center gap-1 py-2 text-gray-600 hover:text-gray-900" type="button" data-toggle="dropdown" aria-controls="menu-project" aria-expanded="false">
                                    <span><xsl:value-of select="i18n:t('navbar__project')"/></span>
                                    <i class="icon-[lucide--chevron-down] text-xs" aria-hidden="true"></i>
                                </button>
                                <ul id="menu-project" class="hidden min-w-48 rounded-md border border-gray-200 bg-white py-1 shadow-lg lg:absolute lg:start-0 lg:top-full lg:z-40">
                                    <li>
                                        <a class="block px-4 py-2 text-gray-900 no-underline hover:bg-gray-100" href="{$home}about.html"><xsl:value-of select="i18n:t('navbar__about')"/></a>
                                    </li>
                                    <li>
                                        <a class="block px-4 py-2 text-gray-900 no-underline hover:bg-gray-100" href="{$home}imprint.html"><xsl:value-of select="i18n:t('navbar__imprint')"/></a>
                                    </li>
                                </ul>
                            </li>
                        </ul>
                    </div>
                </nav>
                <div class="flex gap-1 py-2" aria-label="{i18n:t('navbar__language')}">
                    <xsl:for-each select="$languages">
                        <a class="rounded-md px-2 py-1 uppercase no-underline hover:bg-gray-200 hover:text-gray-900 aria-[current=page]:bg-gray-200 aria-[current=page]:font-semibold aria-[current=page]:text-gray-900 text-gray-600" href="{$base}{.}/{$page}" hreflang="{.}" lang="{.}" title="{i18n:t('language__name', .)}">
                            <xsl:if test=". = $lang">
                                <xsl:attribute name="aria-current">page</xsl:attribute>
                            </xsl:if>
                            <xsl:value-of select="."/>
                        </a>
                    </xsl:for-each>
                </div>
            </div>
        </header>
    </xsl:template>
</xsl:stylesheet>
