<?xml version="1.0" encoding="UTF-8"?>
<!--
    @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
    @Name :         .xsl
    @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
    @version :      001
    @creaDate :     2013/01/07
    @modifDate      
    @vXslt:         2.0
    @autor :        Emmanuel Château emchateau@laposte.net
    @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
    @use :           
    @knownBugs :    
    @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
    @inspired :     
    @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
-->
<xsl:stylesheet 
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0">
    
    <xsl:output indent="yes" method="xml" encoding="UTF-8" />
    
    <xsl:strip-space elements="*"/>
    <xsl:template match="node()|@*">
        <xsl:apply-templates />
    </xsl:template>
    
    <xsl:template match="tei:front|tei:body|tei:back|tei:div|tei:p">
        <xsl:element name="link">
            <xsl:variable name="test">
                <xsl:value-of select="substring(@xml:id, 2, 1)"/>
            </xsl:variable>
            <xsl:attribute name="targets">
                <xsl:text>#</xsl:text>
                <xsl:value-of select="@xml:id" />
                <xsl:text>  </xsl:text>
                <xsl:value-of select="concat('#t5', substring(@xml:id, 3))" />
            </xsl:attribute>
            <xsl:apply-templates />
        </xsl:element>
    </xsl:template>
    
</xsl:stylesheet>