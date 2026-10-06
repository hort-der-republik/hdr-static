<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0">
    <xsl:param name="directory_name">hdr-static</xsl:param>
    <xsl:param name="project_title">Karl Kraus: Der Hort der Republik – Digitale Genetische Edition</xsl:param>
    <xsl:param name="redmine_id">29149</xsl:param>
    <xsl:param name="project_short_title">HdR – Digital Edition</xsl:param>
    <xsl:param name="default_lang">de</xsl:param>
    <xsl:param name="github_url">https://github.com/hort-der-republik/hdr-static</xsl:param>
    <xsl:param name="html_title">HdR Digital Edition</xsl:param>
    <xsl:param name="project_logo">images/logo.png</xsl:param>
    <xsl:param name="base_url">https://hort-der-republik.github.io/hdr-static/</xsl:param>
    <xsl:param name="data_repo">https://github.com/hort-der-republik/hdr-para-texts</xsl:param>
    <!-- path the site is served under, with trailing slash; ant -Dbase=/hdr-static/ -->
    <xsl:param name="base">/</xsl:param>
    <!-- cache buster for the Vite bundle; ant -Dversion=... -->
    <xsl:param name="version">dev</xsl:param>
    <!-- languages the site is built in; pages go to html/{lang}/ -->
    <xsl:param name="languages" select="('de', 'en')"/>
    <!-- language of the page being built; set per run by build.xml -->
    <xsl:param name="lang" select="$default_lang"/>
    <!-- file name of the page being built (used for the language switch);
         defaults to the source file name, build.xml sets it for fixed outputs -->
    <xsl:param name="page" select="replace(tokenize(document-uri(/), '/')[last()], '\.xml$', '.html')"/>
    <!-- start of the current language's pages -->
    <xsl:variable name="home" select="concat($base, $lang, '/')"/>
</xsl:stylesheet>
