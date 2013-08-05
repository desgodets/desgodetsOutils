<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    version="2.0"
    xpath-default-namespace="http://www.tei-c.org/ns/1.0"
    xmlns="http://www.tei-c.org/ns/1.0">
    <!-- choix du préfixe -->
    <xsl:param name="prefix" select="'t9P'" />
    <xsl:param name="foliotation" select="'pageNum'" />
    
    <xsl:output indent="yes" method="xml" encoding="UTF-8" />
    
    <!-- Copie à l'identique du fichier -->
    <xsl:strip-space elements="*" />
    <xsl:template match="node()|@*">
        <xsl:copy>
            <xsl:apply-templates select="node()|@*" />
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="pb">
        <!--<xsl:variable name="autoNum">
            <xsl:number from="/*" format="001"/>
        </xsl:variable>
        <xsl:choose>
            <xsl:when test="(autoNum mod 2)">
                <xsl:attribute name="xml:id" select="concat('t8',($autoNum)-1)"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:attribute name="xml:id" select="concat('t8',$autoNum)"/>
            </xsl:otherwise>
        </xsl:choose>-->
            
            
            <xsl:copy>
                <xsl:attribute name="xml:id">
                    <xsl:text>T8</xsl:text>
                    <xsl:number />
                </xsl:attribute>
            </xsl:copy>           
        
        
    </xsl:template>
</xsl:stylesheet>