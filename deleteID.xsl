<?xml version="1.0" encoding="UTF-8"?>
<!--
    @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
    @Name :         deleteAttributeEtc.xsl
    @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
    @version :      001
    @creaDate :     2013/04/14
    @modifDate      
    @vXslt:         2.0
    @autor :        Emmanuel Château emchateau@laposte.net
    @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
    @use :          cette feuille de style supprime les attributs xml:id des divisions textuelles d'un document tei et remplace une structure ref avec type="plate" par figure 
    @knownBugs :    
    @todo :         
    @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
    @inspired :     
    @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
-->
<xsl:stylesheet 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
    xpath-default-namespace="http://www.tei-c.org/ns/1.0" 
    xmlns="http://www.tei-c.org/ns/1.0">
    <!-- xpath-default-namespace slmt en XSLT2.0 -->
    
    <xsl:output indent="yes" method="xml" encoding="UTF-8" />
    
    <!-- Copie à l'identique du fichier -->
    <xsl:strip-space elements="*" />
    <xsl:template match="node()|@*">
        <xsl:if
            test="not(front/@xml:id|body/@xml:id|back/@xml:id|div/@xml:id|titlePage/@xml:id|p[parent::div|parent::argument|parent::postscript|parent::epigraph]/@xml:id)">
            <xsl:copy>
                <xsl:apply-templates select="node()|@*" />
            </xsl:copy>
        </xsl:if>
    </xsl:template>
    
    
    
</xsl:stylesheet>