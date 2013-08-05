<?xml version="1.0" encoding="UTF-8"?>
<!--
    @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
    @Name :         entities.xsl
    @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
    @version :      003
    @creaDate :     2013/07/17
    @modifDate      
    @vXslt:         2.0
    @autor :        Emmanuel Château emchateau@laposte.net
    @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
    @use :          Cette XSLT récupère les entités nommées pour l'index
    @knownBugs :    
    @todo :         Travailler en évaluant les entités présentes dans le fichier d'index
    @historique :   
    @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
    @gratefulness : Kiln
    @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    version="2.0"
    xpath-default-namespace="http://www.tei-c.org/ns/1.0"
    xmlns="http://www.tei-c.org/ns/1.0">
    <xsl:output indent="yes" method="xml" encoding="UTF-8" />
    
    <xsl:template match="/">
        <div>
            <div type="gT">
                <xsl:apply-templates mode="gT" select="/*/text" />
            </div>
            <div type="gJ">
                <xsl:apply-templates mode="gJ" select="/*/text" />
            </div>
        </div>
    </xsl:template>
    
    <xsl:template match="text()" mode="gT gJ"/>
    
    <xsl:template match="text" mode="gT">
        <xsl:call-template name="listeUniqueTriee">
            <xsl:with-param name="type" select="'gT'" />
        </xsl:call-template>
    </xsl:template>
    <xsl:template match="text" mode="gJ">
        <xsl:call-template name="listeUniqueTriee">
            <xsl:with-param name="type" select="'gJ'" />
        </xsl:call-template>
    </xsl:template>
    
    <xsl:template name="listeUniqueTriee">
        <xsl:param name="type"/>
        <xsl:for-each-group select="//term[@type = $type ]" group-by="@ref">
            <!-- chercher moyen plus efficace -->
            <xsl:sort select="@ref" />
            <xsl:for-each select="current-group()[1]">
                <entry xml:id="{replace( current-grouping-key() , '#' , '' )}">
                    <form>
                        <orth>
                            <xsl:value-of select="current-group()[1]" />
                        </orth>
                    </form>
                    <sense>
                        <def/>
                    </sense>
                </entry>
            </xsl:for-each>
        </xsl:for-each-group>
    </xsl:template>
    
</xsl:stylesheet>