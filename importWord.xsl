<?xml version="1.0" encoding="UTF-8"?>
<!--
    @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
    @Name :         importWord01.xsl
    @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
    @version :      005
    @creaDate :     2013/05/31
    @modifDate      
    @vXslt:         2.0
    @autor :        Emmanuel Château emchateau@laposte.net
    @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
    @use :          Cette feuille de style assure l'importation à partir des textes pré-encodés sous Microsoft Word et passés dans Oxgarage pour le projet ANR Desgodets. 
    @knownBugs :    
    @todo :         
    @historique :   La transformation Oxgarage ne reconnaît pas les titres Desgodets.
                    Le mode équation avait été utilisé pour traiter certains caractères (1/8, etc.).
                    Il a fallu manuellement retirer les liens hypertextes du documents Word car ils créaient un document résultat inexploitable pour la transformation.
                    Intégrer les règles ci-dessous dans une personnalisation du framework de transformation TEI pourrait permettre de régler une partie des problèmes mentionnés ci-dessus 
                    Pour supprimer de manière spécifique les attributs rend="normal" et rend="Notedebasdepage" de p, avons rencontré un problème de logique pour le test (et/ou)
    @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
    @inspired :      
    @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
-->
<xsl:stylesheet 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
    xpath-default-namespace="http://www.tei-c.org/ns/1.0" 
    xmlns="http://www.tei-c.org/ns/1.0">
    <!-- xpath-default-namespace slmt en XSLT2.0 -->
    
    <xsl:output indent="yes" method="xml" encoding="UTF-8" />
    <xsl:strip-space elements="*" />
    
    <!-- Copie à l'identique du fichier -->
    <xsl:template match="node()|@*">
        <xsl:copy>
            <xsl:apply-templates select="node()|@*"/>
        </xsl:copy>
    </xsl:template>
    
    <!-- supprime les attributs rend="normal" et rend="Notesdebasdepage" des éléments p -->
    <xsl:template match="p/@rend[@rend='footnote text']">
    </xsl:template>
    
    <!-- mettre le contenu de hi[@rend='Desgodets_IndexLocorum'] dans placeName -->
    <xsl:template match="hi[@rend='Desgodets_IndexLocorum']">
        <xsl:element name="placeName">
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>
    
    <!-- mettre le contenu de hi[rend='Desgodets_IndexNominum'] dans persName -->
    <xsl:template match="hi[@rend='Desgodets_IndexNominum']">
        <xsl:element name="persName">
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>
    
    <!-- mettre le contenu de hi[rend='Desgodets_IndexRerum'] dans ? -->

    
    <!-- ENTITES CARACTERES -->
    <!-- &laquo; &raquo; &nbsp;	&thinsp; &hellip; &frac12; -->
    <!-- sélection des passages -->
    <!--
        //hi[@rend='Desgodets_IndexRerum']/tokenize(.,'\[')
        //hi[@rend='Desgodets_IndexRerum']/tokenize(.,'Ps')
        //hi[@rend='Desgodets_IndexRerum']/substring-before(.,'[')
        substring-before(substring-after(//*[@id="crumbtrail"]/div[5]/span/text(), "("), "
        //hi[@rend='Desgodets_IndexRerum']/substring-before(substring-after(., '['),']')
        contains(.,'http://')
    -->
    <!-- REGEX -->
    <!-- passages entre crochets \[.*\] -->
    <!-- sic entre crochets \[sic.*\] -->
    <!-- abs entre crochets \[abs.*\] -->
    <!-- abs entre crochets \[abréviation par suspension.*\] -->
    <!-- abc entre crochets \[abréviation par contraction.*\] -->
    <!-- ajout entre crochets \[ajouté.*\] -->
    <!-- correction entre crochets \[corrigé.*\] -->
    <!-- ajout entre crochets \[ajout.*\] -->
    <!-- pagination \[p\..*\] -->
    
    <!-- mettre le contenu de hi[rend='Desgodets_IndexRerum'] dans ? -->
    <xsl:template match="hi[@rend='Desgodets_IndexRerum']">
        <xsl:element name="term" namespace="http://www.tei-c.org/ns/1.0">
            <xsl:attribute name="type">glossariumTechnicae</xsl:attribute>
            <xsl:choose>
                <xsl:when test="contains(., '[')">
                    <xsl:element name="orig" namespace="http://www.tei-c.org/ns/1.0">
                        <xsl:copy-of select="substring-before(.,'[')" />
                    </xsl:element>
                    <xsl:element name="reg" namespace="http://www.tei-c.org/ns/1.0">
                        <xsl:copy-of select="substring-before(substring-after(., '['),']')" />
                    </xsl:element>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:apply-templates/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:element>
    </xsl:template>
    
    <!-- mettre le contenu de hi[rend='Desgodets_GlossaireTechnique'] dans ? -->
    <xsl:template match="hi[@rend='Desgodets_GlossaireTechnique']">
        <xsl:element name="term">
            <xsl:attribute name="type">glossariumTechnicae</xsl:attribute>
            <xsl:choose>
                <xsl:when test="contains(., '[')">
                    <xsl:element name="orig">
                        <xsl:copy-of select="substring-before(.,'[')" />
                    </xsl:element>
                    <xsl:element name="reg">
                        <xsl:copy-of select="substring-before(substring-after(., '['),']')" />
                    </xsl:element>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:apply-templates/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:element>
    </xsl:template>
    <!-- mettre le contenu de hi[rend='Desgodets_GlossaireJuridique'] dans ? -->
    <xsl:template match="hi[@rend='Desgodets_GlossaireJuridique']">
        <xsl:element name="term">
            <xsl:attribute name="type">glossariumJuris</xsl:attribute>
            <xsl:choose>
                <xsl:when test="contains(., '[')">
                    <xsl:element name="orig">
                        <xsl:copy-of select="substring-before(.,'[')" />
                    </xsl:element>
                    <xsl:element name="reg">
                        <xsl:copy-of select="substring-before(substring-after(., '['),']')" />
                    </xsl:element>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:apply-templates/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:element>
    </xsl:template>
</xsl:stylesheet>