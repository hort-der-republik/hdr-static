<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="#all" version="2.0">
    <xsl:template name="nav_bar">
        <a class="sr-only focus:not-sr-only focus:absolute focus:start-2 focus:top-2 focus:z-50 focus:rounded focus:bg-white focus:px-3 focus:py-2" href="#main">Zum Inhalt springen</a>
        <header class="container">
            <nav aria-label="Primary" class="flex flex-wrap items-center gap-x-6 gap-y-2 px-4 py-2">
                <a class="text-xl text-gray-900 no-underline hover:text-gray-700" href="index.html">
                    <xsl:value-of select="$project_short_title"/>
                </a>
                <button class="btn btn-outline ms-auto lg:hidden" type="button" data-toggle="collapse" aria-controls="navbarSupportedContent" aria-expanded="false" aria-label="Toggle navigation">
                    <i class="icon-[lucide--menu] text-xl" aria-hidden="true"></i>
                </button>
                <div class="hidden w-full lg:flex lg:w-auto lg:grow" id="navbarSupportedContent">
                    <ul class="flex flex-col gap-1 pb-2 lg:flex-row lg:items-center lg:gap-4 lg:pb-0">
                        <li class="relative">
                            <button class="flex items-center gap-1 py-2 text-gray-600 hover:text-gray-900" type="button" data-toggle="dropdown" aria-controls="menu-project" aria-expanded="false">
                                <span>Projekt</span>
                                <i class="icon-[lucide--chevron-down] text-xs" aria-hidden="true"></i>
                            </button>
                            <ul id="menu-project" class="hidden min-w-48 rounded-md border border-gray-200 bg-white py-1 shadow-lg lg:absolute lg:start-0 lg:top-full lg:z-40">
                                <li>
                                    <a class="block px-4 py-2 text-gray-900 no-underline hover:bg-gray-100" href="about.html">Über das Projekt</a>
                                </li>
                                <li>
                                    <a class="block px-4 py-2 text-gray-900 no-underline hover:bg-gray-100" href="imprint.html">Impressum</a>
                                </li>
                            </ul>
                        </li>
                        <li>
                            <a class="block py-2 text-gray-600 no-underline hover:text-gray-900" href="toc.html">Editionseinheiten</a>
                        </li>
                        <li class="relative">
                            <button class="flex items-center gap-1 py-2 text-gray-600 hover:text-gray-900" type="button" data-toggle="dropdown" aria-controls="menu-register" aria-expanded="false">
                                <span>Register</span>
                                <i class="icon-[lucide--chevron-down] text-xs" aria-hidden="true"></i>
                            </button>
                            <ul id="menu-register" class="hidden min-w-48 rounded-md border border-gray-200 bg-white py-1 shadow-lg lg:absolute lg:start-0 lg:top-full lg:z-40">
                                <li>
                                    <a class="block px-4 py-2 text-gray-900 no-underline hover:bg-gray-100" href="listperson.html">Personen</a>
                                </li>
                                <li>
                                    <a class="block px-4 py-2 text-gray-900 no-underline hover:bg-gray-100" href="listplace.html">Orte</a>
                                </li>
                                <li>
                                    <a class="block px-4 py-2 text-gray-900 no-underline hover:bg-gray-100" href="listorg.html">Organisationen</a>
                                </li>
                                <li>
                                    <a class="block px-4 py-2 text-gray-900 no-underline hover:bg-gray-100" href="listbibl.html">Werke</a>
                                </li>
                            </ul>
                        </li>
                        <li>
                            <a title="API" class="block py-2 text-gray-600 no-underline hover:text-gray-900" href="api.xml">API</a>
                        </li>
                        <li>
                            <a title="Suche" class="block py-2 text-gray-600 no-underline hover:text-gray-900" href="search.html">Suche</a>
                        </li>
                        <li>
                            <a title="Suche" class="block py-2 text-gray-600 no-underline hover:text-gray-900" href="noske-search.html">Noske-Suche</a>
                        </li>
                    </ul>
                </div>
            </nav>
        </header>
    </xsl:template>
</xsl:stylesheet>
