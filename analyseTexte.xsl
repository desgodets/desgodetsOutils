<?xml version="1.0" encoding="UTF-8"?>
<!--
    @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
    @Name :         analyseTexte.xsl
    @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
    @version :      001
    @creaDate :     2013/06/01
    @modifDate      
    @vXslt:         1.0
    @autor :        Emmanuel Château emchateau@laposte.net
    @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
    @use :          Cette feuille de style se charge de traiter les chaînes de caractères par le biais d'expressions régulières 
    @knownBugs :    
    @todo :         
    @historique :   
    @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
    @gratefulness : http://www.saxonica.com/papers/ideadb-1.1/mhk-paper.xml
                    http://stackoverflow.com/questions/15593106/extract-text-between-single-quotes-in-xslt
    @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
-->
<!-- [aps : « pi. » ; pieds] -->
<!-- [apc : « po<hi rend="superscript">s</hi> » ; pouces]


<!-- [rature : « texte »] -->
<!-- [sic : « texte »] -->
<!-- ceintre[sic : « ceintre »] 
         impossible à récupérer par ailleurs, souvent pas de vrais sic. -->
<!-- [sic : « pieds » ; pieds] -->
<!-- [sic : « de la tête (sic)tête » ; répétition] -->
<!-- [manque ; blanc] -->
<!-- AF  [« AF » correction] 
         impossible à récupérer -->
<!-- [correction : « et des voûtes neuves »] -->
<!-- [correction : « 3922 » corrigé en « 392 »] -->
<!-- [ajouté : au dessus ; « ne »] -->
<!-- [ajout : au-dessus ; « de neuf pieds »] -->
<!-- [ajout : « de ce » au-dessus lignes] -->
<!-- [mise en valeur : centré « Exemple »] -->
<!-- [mise en valeur : plus grand « Autre exemple »] -->
<!-- [mise en valeur : plus grand, centré « Exemple »] -->
<!-- [planche n° 1] [planche n° 1 v.] -->
<!-- [abréviation par suspension : « fig. » ; « figure »] -->
<!-- [abréviation 1<hi rend="superscript">er</hi> ; premier] -->
<!-- <hi rend="Desgodets_IndexRerum">voûtes sur noyau [voûte sur noyau] [voûte sur noyau]</hi> -->
<xsl:stylesheet 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0" 
    xpath-default-namespace="http://www.tei-c.org/ns/1.0" 
    xmlns="http://www.tei-c.org/ns/1.0">
    <!-- xpath-default-namespace slmt en XSLT2.0 -->
    
    <xsl:output indent="yes" method="xml" encoding="UTF-8" />

    <!-- choix du préfixe -->
    <xsl:param name="prefix" select="'t9'" />

    <!-- Copie à l'identique du fichier -->
    <xsl:strip-space elements="*" />
    
    <!-- Copie à l'identique du fichier (toutes les passes) -->
    <xsl:template match="node()|@*" mode="#all">
        <xsl:copy>
            <xsl:apply-templates select="node()|@*" mode="#current" />
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="/">
        <xsl:variable name="intermediate">
            <xsl:apply-templates mode="phase1" />
        </xsl:variable>
        <xsl:apply-templates select="$intermediate" mode="phase2"/>
    </xsl:template>
    
    <!-- pagination -->
    <xsl:template match="p/text()" mode="phase1">
        <xsl:analyze-string select="." regex="\[a\.(.*?)\]">
            <xsl:matching-substring>
                <xsl:element name="pb"/>
                <xsl:element name="fw">
                    <xsl:attribute name="type">
                        <xsl:value-of select="$foliotation"/>
                    </xsl:attribute>
                    <xsl:value-of select="normalize-space( regex-group(1) )" />
                    <!-- fournir une valeur de n -->
                </xsl:element>
            </xsl:matching-substring>
            <xsl:non-matching-substring>
                <xsl:value-of select="." />
            </xsl:non-matching-substring>
            <xsl:fallback>bug</xsl:fallback>
        </xsl:analyze-string>
    </xsl:template>
    
    <!-- numérotation des pb -->
    <xsl:template match="pb" mode="phase2">
        <xsl:variable name="autoNum">
            <xsl:number level="any" />
        </xsl:variable>
        <xsl:variable name="autoNum">
            <xsl:choose>
                <xsl:when test="($foliotation='folio') and ($autoNum mod 2 != 1)">
                    <xsl:sequence
                        select="concat( format-number($autoNum  div 2, '000') , 'v' )" />
                </xsl:when>
                <xsl:when test="($foliotation='folio') and ($autoNum mod 2 = 1)">
                    <xsl:sequence select="format-number( ( $autoNum + 1 ) div 2 , '000' ) " />
                </xsl:when>
                <xsl:otherwise>
                    <xsl:sequence select="format-number( $autoNum, '000' )" />
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:copy>
            <xsl:attribute name="xml:id">
                <xsl:choose>
                    <xsl:when test="($foliotation='folio')">
                        <xsl:sequence
                            select="concat( $prefix , 'Fol' , $autoNum )" />
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:sequence select="concat( $prefix, 'P' , $autoNum )"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:attribute>
            <xsl:attribute name="n">
                <xsl:choose>
                    <xsl:when test="($foliotation='folio')">
                        <xsl:sequence
                            select="$autoNum" />
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:sequence select="concat( 'p' , format-number($autoNum, '0' ) )"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:attribute>
            <xsl:apply-templates select="@*|node()" />
        </xsl:copy>
    </xsl:template>
    
    
</xsl:stylesheet>