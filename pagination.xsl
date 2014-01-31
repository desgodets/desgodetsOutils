<?xml version="1.0" encoding="UTF-8"?>
<!--
    @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
    @Name :         pagination.xsl
    @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
    @version :      001
    @creaDate :     2013/03/26
    @modifDate      
    @vXslt:         1.0
    @autor :        Emmanuel Château emchateau@laposte.net
    @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
    @use :          Cette feuille de style se charge de traiter les chaînes de caractères par le biais d'expressions régulières 
    @knownBugs :    Positionnement de départ à déterminer
                    Bug sur les attributs par défaut de TEI
    @todo :         Ajuster le positionnement des pb par rapport à la structure et supprimer les paragraphes inutiles
                    Améliorer la numérotation des pb (on ne peut pas employer l'instruction xsl:number car le contexte n'est pas un noeud mais une valeur atomique), faire une repasse
                    Numérotation folio recto/verso qui m'a donné du grain à moudre
                    Remplacer <xsl:sequence> par <xsl:text>
    @historique :   La numérotation des pb avec number est impossible lorsque l'on traite la chaîne avec analyze-string car le nœud contexte n'est pas un nœud courrant mais une valeur atomique
                    La numérotation implique un deuxième phase de traitement
                    Ce deuxième traitement prend en charge les folio ou la pagination en utilisant une suite arithmétique et le modulo (peut-être à améliorer)
    @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
    @gratefulness : http://www.saxonica.com/papers/ideadb-1.1/mhk-paper.xml
                    http://stackoverflow.com/questions/15593106/extract-text-between-single-quotes-in-xslt
    @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
-->
<xsl:stylesheet 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0" 
    xpath-default-namespace="http://www.tei-c.org/ns/1.0" 
    xmlns="http://www.tei-c.org/ns/1.0">
    <!-- xpath-default-namespace slmt en XSLT2.0 -->
    
    <xsl:output indent="yes" method="xml" encoding="UTF-8" />

    <!-- choix du préfixe -->
    <xsl:param name="prefix" select="'t9'" />
    <xsl:param name="foliotation" select="'pageNum'" />

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
        <!--<xsl:analyze-string select="." regex="\[p\.(.*?)\]" flags="s">-->
        <xsl:analyze-string select="." regex="\[fol\.(.*?)\]" flags="s">
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