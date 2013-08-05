<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
        xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0" 
        xpath-default-namespace="http://www.tei-c.org/ns/1.0" 
        xmlns="http://www.tei-c.org/ns/1.0">
        
        <xsl:output indent="yes" method="xml" encoding="UTF-8" />
        
        <xsl:strip-space elements="*" />
        
        <!-- Copie à l'identique du fichier (toutes les passes) -->
        <xsl:template match="node()|@*">
            <xsl:copy>
                <xsl:apply-templates select="node()|@*"/>
            </xsl:copy>
        </xsl:template>
        
        <xsl:template match="hi[child::seg]">
            <xsl:text>toto</xsl:text>
            <xsl:apply-templates select="./seg/ref"/>
        </xsl:template>
    
</xsl:stylesheet>