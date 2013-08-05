<?xml version="1.0" encoding="UTF-8"?>
<!--
    @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
    @Name :         figures.xsl
    @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
    @version :      001
    @creaDate :     2013/05/30
    @modifDate      
    @vXslt:         1.0
    @autor :        Emmanuel Château emchateau@laposte.net
    @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
    @use :          cette feuille de style importe les tableaux des figures pour l'édition des manuscrits 
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
    
    <!-- choix du préfixe -->
    <xsl:param name="prefix" select="'o1'" />
    <xsl:param name="type" select="'plate'" />
    
    <xsl:strip-space elements="*" />
    
    <xsl:template match="text" />
    <xsl:template match="head" />
    <xsl:template match="p" />
    
    <xsl:template match="table">
        <div xmlns="http://www.tei-c.org/ns/1.0" type="figures"
            xml:id="{$prefix}BackFr03" xml:lang="fre">
            <head>Liste des figures</head>
            <xsl:apply-templates />
        </div>
    </xsl:template>
    
    <xsl:template match="row">
        <xsl:variable name="count">
            <xsl:choose>
                <xsl:when test="$type='plate'">
                    <xsl:text>Pl</xsl:text>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:text>Fig</xsl:text>
                </xsl:otherwise>
            </xsl:choose>
            <xsl:number format="0000" />
        </xsl:variable>
        <figure xml:id="{$prefix}{$count}" 
            type="plate"
            facs="#{$prefix}Facs{$count}" >
            <fw type="header">
                <xsl:value-of select="cell[4]" />
            </fw>
            <figDesc>
                <locus from="#{$prefix}" />
                <label>
                    <num n="{position()}">
                        <xsl:value-of select="position()"></xsl:value-of>
                    </num>
                </label>
                <title>
                    <xsl:value-of select="cell[3]" />
                </title>
                <desc>
                    <xsl:value-of select="cell[7]" />
                </desc>
                <dimensions>
                    <xsl:apply-templates select="cell[6]" />
                </dimensions>
            </figDesc>
            <note><xsl:value-of select="cell[5]" /></note>
        </figure>
    </xsl:template>
    
    <xsl:template match="cell[1] | cell[2]"/>
    
    <xsl:template match="cell[6]">
        <height quantity="{substring-before(.,'x')}" unit="mm" />
        <width quantity="{substring-after(.,'x')}" unit="mm" />
    </xsl:template>
    
    <!-- Copie à l'identique du fichier -->
    <xsl:template match="node()|@*">
        <xsl:copy>
            <xsl:apply-templates select="node()|@*"/>
        </xsl:copy>
    </xsl:template>
   
</xsl:stylesheet>