<?xml version="1.0" encoding="UTF-8"?>
<!--
    @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
    @Name :         ttmtChaines.xsl
    @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
    @version :      003
    @creaDate :     2013/05/20
    @modifDate      
    @vXslt:         1.0
    @autor :        Emmanuel Château emchateau@laposte.net
    @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
    @use :          Cette feuille de style se charge de traiter les @ref normalisées pour les éléments term 
    @knownBugs :    Ne traite pas les singuliers pluriels
    @todo :         
    @historique :   
    @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
    @gratefulness : http://www.saxonica.com/papers/ideadb-1.1/mhk-paper.xml
                    http://stackoverflow.com/questions/15593106/extract-text-between-single-quotes-in-xslt
                    http://www.dpawson.co.uk/xsl/sect2/N7150.html#d9570e1770
    @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
    xpath-default-namespace="http://www.tei-c.org/ns/1.0"
    xmlns="http://www.tei-c.org/ns/1.0" xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:functx="http://www.metaphoricalweb.org/xmlns/string-utilities">
    
    <xsl:output indent="yes" method="xml" encoding="UTF-8"/>
    
    <xsl:strip-space elements="*"/>
    
    <!-- phases de traitement -->
    <xsl:template match="/*/text">
        <xsl:variable name="intermediate">
            <xsl:element name="text">
                <xsl:apply-templates mode="phase1"/>
            </xsl:element>
        </xsl:variable>
        <xsl:apply-templates select="$intermediate" mode="phase2"/>
    </xsl:template>
    
    <xsl:template match="link/@target">
        <xsl:
    </xsl:template>
    
    
    <!--
    @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
    @   copie à l'identique
    @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
    -->
    
    <xsl:template match="node()|@*" mode="#all">
        <xsl:copy>
            <xsl:apply-templates select="node()|@*" mode="#current"/>
        </xsl:copy>
    </xsl:template>
    
    
</xsl:stylesheet>
