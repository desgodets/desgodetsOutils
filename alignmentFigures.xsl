<?xml version="1.0" encoding="UTF-8"?>
<!--
    @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
    @Name :         .xsl
    @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
    @version :      001
    @creaDate :     2013/05/29
    @modifDate      
    @vXslt:         1.0
    @autor :        Emmanuel Château emchateau@laposte.net
    @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
    @use :           
    @knownBugs :    
    @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
    @inspired :     
    @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    version="1.0">
    <xsl:output indent="yes" method="xml" encoding="UTF-8" />
    
    <xsl:template match="root">
        <div type="alignmentFigures">
            <linkGrp><xsl:apply-templates select="group"/></linkGrp>
        </div>
    </xsl:template>
    <xsl:template match="group">
        <xsl:variable name="count">
            <xsl:number format="0001"/>
        </xsl:variable>
        <link>
            <xsl:attribute name="target">
                <xsl:for-each select="ms">

                    <xsl:text>#</xsl:text>
                    <xsl:value-of select="." />
                    <xsl:text>Fig</xsl:text>
                    <xsl:value-of select="$count"/>
                    <xsl:text>  </xsl:text>
                </xsl:for-each>
            </xsl:attribute>
        </link>
    </xsl:template>
</xsl:stylesheet>