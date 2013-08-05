<?xml version="1.0" encoding="UTF-8"?>
<!--
    @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
    @Name :         notes.xsl
    @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
    @version :      001
    @creaDate :     2013/06/01
    @modifDate      
    @vXslt:         2.0
    @autor :        Emmanuel Château emchateau@laposte.net
    @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
    @use :          converti les notes à la sortie de Oxgarage dans le cadre du projet Desgodets
    @knownBugs :    
    @todo :         améliorer le parcours //note
                    sérialiser si possible
    @historique :   
    @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
    @gratefulness : 
    @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
-->
<!-- on a remplacé @place='end' par @place='comment' -->
<xsl:stylesheet 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
    xpath-default-namespace="http://www.tei-c.org/ns/1.0" 
    xmlns="http://www.tei-c.org/ns/1.0">
    <!-- xpath-default-namespace slmt en XSLT2.0 -->
    
    <xsl:output indent="yes" method="xml" encoding="UTF-8" />
    
    <!-- choix du préfixe -->
    <xsl:param name="prefix" select="'c'" />
    
    <!-- commenter pour ne pas appliquer la transformation -->
    <xsl:param name="presentation" select="'yes'" />
    
    <!-- Copie à l'identique du fichier (toutes les passes) -->
    <xsl:template match="node()|@*">
        <xsl:copy>
            <xsl:apply-templates select="node()|@*" />
        </xsl:copy>
    </xsl:template>
    
    
    <xsl:template match="note[@place='foot']">
        <xsl:variable name="countFootNotes">
            <xsl:choose>
                <xsl:when test="$presentation = 'yes'">
                    <xsl:sequence select="concat($prefix , 'N' )"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:sequence select="concat($prefix , 'Nc' )"/>
                </xsl:otherwise>
            </xsl:choose>
            <xsl:number format="0001" level="any" count="note[@place='foot']"/>
        </xsl:variable>
        <xsl:choose>
            <xsl:when test="$presentation = 'yes'">
                <xsl:variable name="note">
                    <xsl:copy-of select="."/>
                </xsl:variable>
            </xsl:when>
            <xsl:otherwise>
                <xsl:variable name="noteCritical">
                    <xsl:copy-of select="."/>
                </xsl:variable>
            </xsl:otherwise>
        </xsl:choose>
        <xsl:element name="ref">
            <xsl:choose>
                <xsl:when test="$presentation = 'yes'">
                    <xsl:attribute name="type">note</xsl:attribute>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:attribute name="type">noteCritical</xsl:attribute>
                </xsl:otherwise>
            </xsl:choose>
            <xsl:attribute name="target" select="$countFootNotes" />
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="note[@place='comment']">
        <xsl:variable name="countFootNotes">
            <xsl:sequence select="concat($prefix , 'Nh' )"/>
            <xsl:number format="0001" level="any" count="note[@place='comment']"/>
        </xsl:variable>
        <xsl:variable name="noteCritical">
            <xsl:copy-of select="."/>
        </xsl:variable>
        <xsl:element name="ref">
            <xsl:attribute name="type">noteHistorical</xsl:attribute>
            <xsl:attribute name="target" select="$countFootNotes" />
        </xsl:element>
    </xsl:template>
    
    
    <xsl:template match="note[@place='foot']" mode="notes">
        <xsl:variable name="countFootNotes">
            <xsl:choose>
                <xsl:when test="$presentation = 'yes'">
                    <xsl:sequence select="concat($prefix , 'N' )"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:sequence select="concat($prefix , 'Nc' )"/>
                </xsl:otherwise>
            </xsl:choose>
            <xsl:number format="0001" level="any" count="note[@place='foot']"/>
        </xsl:variable>
        <xsl:element name="note">
            <xsl:attribute name="xml:id" select="$countFootNotes"/>
            <xsl:apply-templates />                
        </xsl:element>
    </xsl:template>
    <xsl:template match="note[@place='comment']" mode="notes">
        <xsl:variable name="countFootNotes">
            <xsl:sequence select="concat($prefix , 'Nh' )"/>
            <xsl:number format="0001" level="any" count="note[@place='comment']"/>
        </xsl:variable>
        <xsl:element name="note">
            <xsl:attribute name="xml:id" select="$countFootNotes"/>
            <xsl:apply-templates />                
        </xsl:element>
    </xsl:template>
    
    <!--<xsl:template match="p">
        <p><xsl:apply-templates/></p>
    </xsl:template>-->
    
    <xsl:template match="divGen[@type='notesCritical']">
        <div type="{@type}">
            <xsl:copy-of select="head"/>
            <xsl:apply-templates select="//note[@place='foot']" mode="notes" /><!-- solution trash, sortir le reste du traitement -->
        </div>
    </xsl:template>
    
    <xsl:template match="divGen[@type='notes']">
        <div type="{@type}">
            <xsl:copy-of select="head"/>
            <xsl:apply-templates select="//note[@place='foot']" mode="notes" /><!-- solution trash, sortir le reste du traitement -->
        </div>
    </xsl:template>
    
    <xsl:template match="divGen[@type='notesHistorical']">
        <div type="{@type}">
            <xsl:copy-of select="head"/>
            <xsl:apply-templates select="//note[@place='comment']" mode="notes" /><!-- solution trash, sortir le reste du traitement -->
        </div>
        <!-- @place='comment' -->
    </xsl:template>
    
</xsl:stylesheet>