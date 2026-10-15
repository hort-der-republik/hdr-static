<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:i18n="urn:hdr-static:i18n"
    exclude-result-prefixes="#all" version="2.0">
    <xsl:import href="./badge.xsl"/>
    <xsl:template name="nav_bar">
        <a
            class="sr-only focus:not-sr-only focus:absolute focus:start-2 focus:top-2 focus:z-50 focus:rounded focus:bg-white focus:px-3 focus:py-2"
            href="#main">
            <xsl:value-of select="i18n:t('navbar__skip')"/>
        </a>
        <header class="py-4 border-b border-gray-200">
            <div class="container flex flex-wrap items-center gap-x-4">
                <a
                    class="me-auto py-2 text-xl text-gray-900 no-underline hover:text-gray-700 sm:me-0"
                    href="{$home}index.html">
                    <xsl:value-of select="i18n:t('project__short_title')"/>
                </a>
                <div class="order-last w-full sm:order-none sm:me-auto sm:w-auto lg:me-0">
                    <xsl:call-template name="badge">
                        <xsl:with-param name="text" select="'beta'"/>
                        <xsl:with-param name="class" select="'uppercase'"/>
                    </xsl:call-template>
                </div>
                <!-- desktop; on mobile the language links are in the drawer -->
                <xsl:call-template name="language_switch">
                    <xsl:with-param name="class" select="'hidden lg:order-last lg:flex'"/>
                </xsl:call-template>
                <!-- desktop -->
                <nav aria-label="{i18n:t('navbar__label')}" class="hidden lg:flex lg:grow"
                    id="nav-main">
                    <xsl:call-template name="nav_list">
                        <xsl:with-param name="drawer" select="false()"/>
                    </xsl:call-template>
                </nav>
                <!-- mobile: the landmark holds the menu button, the links are in the drawer -->
                <nav aria-label="{i18n:t('navbar__label')}" class="lg:hidden">
                    <button class="btn btn-outline" type="button" data-dialog="nav-drawer"
                        aria-haspopup="dialog" aria-controls="nav-drawer"
                        aria-label="{i18n:t('navbar__toggle')}">
                        <i class="icon-[lucide--menu] text-xl" aria-hidden="true"/>
                    </button>
                    <dialog id="nav-drawer" class="drawer" aria-label="{i18n:t('navbar__menu')}">
                        <!-- the dialog itself has no padding: a click on it (not on this box) is a backdrop click -->
                        <div class="flex min-h-full flex-col gap-4 p-4">
                            <!-- as high as the header's first row (title: py-2 text-xl), so the close
                                 button takes the place of the menu button -->
                            <form method="dialog" class="flex h-11 items-center justify-end">
                                <button class="btn btn-outline" type="submit"
                                    aria-label="{i18n:t('navbar__close')}">
                                    <i class="icon-[lucide--x] text-xl" aria-hidden="true"/>
                                </button>
                            </form>
                            <xsl:call-template name="nav_list">
                                <xsl:with-param name="drawer" select="true()"/>
                            </xsl:call-template>
                            <xsl:call-template name="language_switch">
                                <xsl:with-param name="class"
                                    select="'flex border-t border-gray-200 pt-4'"/>
                            </xsl:call-template>
                        </div>
                    </dialog>
                </nav>
            </div>
        </header>
    </xsl:template>

    <!-- links to the current page in the other languages; in the header and in the drawer -->
    <xsl:template name="language_switch">
        <xsl:param name="class" as="xs:string"/>
        <div class="{$class} gap-1" role="group" aria-label="{i18n:t('navbar__language')}">
            <xsl:for-each select="$languages">
                <a
                    class="rounded-md px-2 py-1 uppercase no-underline hover:bg-gray-200 hover:text-gray-900 aria-[current=page]:bg-gray-200 aria-[current=page]:font-semibold aria-[current=page]:text-gray-900 text-gray-600"
                    href="{$base}{.}/{$page}" hreflang="{.}" lang="{.}"
                    title="{i18n:t('language__name', .)}">
                    <xsl:if test=". = $lang">
                        <xsl:attribute name="aria-current">page</xsl:attribute>
                    </xsl:if>
                    <xsl:value-of select="."/>
                </a>
            </xsl:for-each>
        </div>
    </xsl:template>
    <xsl:template name="nav_list">
        <xsl:param name="drawer" as="xs:boolean"/>
        <!-- ids must be unique although the list is on the page twice -->
        <xsl:variable name="prefix" select="
                if ($drawer) then
                    'drawer-'
                else
                    ''"/>
        <ul class="{if ($drawer) then 'flex flex-col gap-1' else 'flex items-center gap-4'}">
            <li class="relative">
                <button class="flex items-center gap-1 py-2 text-gray-600 hover:text-gray-900"
                    type="button" data-toggle="dropdown" aria-controls="{$prefix}menu-project"
                    aria-expanded="false">
                    <span>
                        <xsl:value-of select="i18n:t('navbar__project')"/>
                    </span>
                    <i class="icon-[lucide--chevron-down] text-xs" aria-hidden="true"/>
                </button>
                <ul id="{$prefix}menu-project"
                    class="{if ($drawer) then 'hidden border-s border-gray-200' else 'hidden absolute start-0 top-full z-40 min-w-48 rounded-md border border-gray-200 bg-white py-1 shadow-lg'}">
                    <li>
                        <xsl:call-template name="nav_link">
                            <xsl:with-param name="href" select="'about.html'"/>
                            <xsl:with-param name="label" select="i18n:t('navbar__about')"/>
                        </xsl:call-template>
                    </li>
                    <li>
                        <xsl:call-template name="nav_link">
                            <xsl:with-param name="href" select="'glossary.html'"/>
                            <xsl:with-param name="label" select="i18n:t('navbar__glossary')"/>
                        </xsl:call-template>
                    </li>
                </ul>
            </li>
            <li>
                <xsl:call-template name="nav_link">
                    <xsl:with-param name="href" select="'imprint.html'"/>
                    <xsl:with-param name="label" select="i18n:t('navbar__imprint')"/>
                    <xsl:with-param name="top" select="true()"/>
                </xsl:call-template>
            </li>
        </ul>
    </xsl:template>

    <!-- link in the main navigation; aria-current marks the page being shown
         $top: a top-level entry, styled like the dropdown buttons next to it -->
    <xsl:template name="nav_link">
        <xsl:param name="href"/>
        <xsl:param name="label"/>
        <xsl:param name="top" as="xs:boolean" select="false()"/>
        <a
            class="{if ($top) then 'block py-2 text-gray-600 no-underline hover:text-gray-900 aria-[current=page]:text-gray-900' else 'block px-4 py-2 text-gray-900 no-underline hover:bg-gray-100'} aria-[current=page]:font-semibold"
            href="{$home}{$href}">
            <xsl:if test="$page = $href">
                <xsl:attribute name="aria-current">page</xsl:attribute>
            </xsl:if>
            <xsl:value-of select="$label"/>
        </a>
    </xsl:template>
</xsl:stylesheet>
