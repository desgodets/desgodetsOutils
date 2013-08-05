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

    <xsl:template match="/*/text">
        <xsl:variable name="intermediate">
            <xsl:element name="text">
                <xsl:apply-templates mode="phase1"/>
            </xsl:element>
        </xsl:variable>
        <xsl:apply-templates select="$intermediate" mode="phase2"/>
    </xsl:template>

    <!-- supprimer les @ref -->
    <xsl:template match="term/@ref" mode="phase1"/>

    <!-- création des @ref normalisées -->
    <xsl:template match="term" mode="phase2">
        <xsl:for-each select=".">
            <!--<xsl:sort></xsl:sort>-->
            <xsl:element name="term">
                <xsl:apply-templates select="@type"/> <!-- ici pour forcer l'ordre des attributs, sinon pas nécessaire -->
                <xsl:attribute name="ref">
                    <xsl:variable name="reg">
                        <xsl:call-template name="makeRef"/>
                    </xsl:variable>
                    <xsl:value-of
                        select="concat( '#' , functx:words-to-camel-case(replace(normalize-unicode( $reg , 'NFKD'), '[&#x0300;-&#x036F;]', '') ) )"
                    />
                </xsl:attribute>
                <xsl:apply-templates />
            </xsl:element>
        </xsl:for-each>
    </xsl:template>
    
    <xsl:template name="makeRef">
        <xsl:apply-templates select="." mode="toto"/>
    </xsl:template>
    <xsl:template match="orig" mode="toto" />
        
    <!--<xsl:attribute name="ref">
            <xsl:variable name="reg" select="./choice/reg"/>
            <xsl:choose>
                <xsl:when test="$reg != ''">
                    <xsl:value-of
                        select="concat( '#' , functx:words-to-camel-case(replace(normalize-unicode( $reg , 'NFKD'), '[&#x0300;-&#x036F;]', '') ) )"
                    />
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of
                        select="concat( '#' , functx:words-to-camel-case(replace(normalize-unicode( ./choice/reg , 'NFKD'), '[&#x0300;-&#x036F;]', '') ) )"
                    />
                </xsl:otherwise>
            </xsl:choose>
        </xsl:attribute>-->
    
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
    
    <!--
    @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
    @   fonctions
    @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
    -->
    <xsl:function name="functx:words-to-camel-case" as="xs:string">
        <xsl:param name="arg" as="xs:string?"/>
        <xsl:sequence
            select="string-join((tokenize($arg,'\W+')[1], for $word in tokenize($arg,'\W+')[position() > 1]return concat(upper-case(substring($word,1,1)),
            substring($word,2))) ,'')  "
        />
        <!-- j'ai modifié la fonction originale avec \W de manière à tenir compte des apostrophes -->
    </xsl:function>

</xsl:stylesheet>
