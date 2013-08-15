<?xml version="1.0" encoding="UTF-8"?>
<!--
    @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
    @Name :         sortEntries.xsl
    @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
    @version :      00#
    @creaDate :     2013/08/01
    @modifDate      
    @vXslt:         2.0
    @autor :        Emmanuel Château emchateau@laposte.net
    @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
    @use :          Cette XSLT extrait trie alphabétiquement les entrées d'index
    @knownBugs :    
    @todo :         
    @historique :   
    @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
    @gratefulness : 
    @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    version="2.0"
    xpath-default-namespace="http://www.tei-c.org/ns/1.0"
    xmlns="http://www.tei-c.org/ns/1.0">
    <xsl:output indent="yes" method="xml" encoding="UTF-8" />
    
    <xsl:strip-space elements="*"/>
    
    <xsl:template match="text/body/div">
        <div xml:lang="fre" type="glossariumTechnicae">
            <xsl:for-each select="entry">
                <!--<xsl:sort select="@ref" collation="http://www.w3.org/2005/xpath-functions/collation/codepoint" />-->
                <xsl:sort select="@xml:id"/>
                <xsl:copy-of select="."/>
            </xsl:for-each>
        </div>
    </xsl:template>    
    
    
    <!-- Copie à l'identique du fichier -->
    <xsl:template match="node()|@*">
        <xsl:copy>
            <xsl:apply-templates select="node()|@*" />
        </xsl:copy>
    </xsl:template>
    
</xsl:stylesheet>