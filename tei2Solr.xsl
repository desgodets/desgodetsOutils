<?xml version="1.0" encoding="UTF-8"?>
<!--
    @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
    @Name :         tei2Solr.xsl
    @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
    @version :      003
    @creaDate :     2013/06/12
    @modifDate      
    @vXslt:         2.0
    @autor :        Emmanuel Château emchateau@laposte.net
    @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
    @use :          Cette XSLT transforme un document XML-TEI en un document d'index pour Solr
    @knownBugs :    Améliorer la gestion des espaces
    @todo :         Traiter les régularisations [préparer le texte de deux manières dans une variable à transmettre aux règles]
                    ajouter les entités nommées dans le texte. Traitement des espaces.
                    Régler la question des espaces pour la normalisation
                    pb avec argument et byline ss id. et premiers id 2 fois
    @historique :   
    @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
    @gratefulness : Kiln
    @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
-->
<xsl:stylesheet exclude-result-prefixes="#all" 
    version="2.0" 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:tei="http://www.tei-c.org/ns/1.0">
    
    <xsl:output indent="yes" method="xml" encoding="UTF-8" />
    <xsl:strip-space elements="*" />
    
    <!-- chemin du fichier indexé, à remplacer par une autonomisation quand part de la racine -->
    <xsl:param name="file-path" select="'www.desgodets.net'"/>
    
    <xsl:variable name="documentMetadata">
        <xsl:apply-templates mode="documentMetadata" select="/*/tei:teiHeader" />
    </xsl:variable>
    
    
    <!--<xsl:variable name="fullTextOrig">
        <xsl:apply-templates mode="fullTextOrig" select="/*/tei:text" />
    </xsl:variable>-->
    
    
    <xsl:template match="/">
    <!-- Entity mentions are restricted to the text of the document;
           entities keyed in the TEI header are document metadata. -->
        <!--<xsl:apply-templates mode="entity-mention" select="/*/tei:text//tei:*[@ref]" />-->
        <xsl:apply-templates mode="fullText" select="/*/tei:text" />
    </xsl:template>
    
    <!-- mode fullTextOrig -->
    <xsl:template match="tei:p | tei:seg | tei:note | tei:list | tei:table | tei:argument | tei:byline | tei:figure" mode="fullText">
        <xsl:if test="normalize-space(.)">
            <doc>
                <field name="id">
                    <xsl:value-of select="@xml:id" />
                </field>
                <xsl:sequence select="$documentMetadata" />
                <field name="teiPart">
                    <xsl:value-of select="ancestor::*[parent::tei:text]/name()" />
                </field>
                <field name="teiType">
                    <xsl:value-of select="name()" />
                </field>
                <field name="fullTextOrig">
                    <xsl:apply-templates mode="getFullTextOrig" />
                </field>
                <field name="fullTextReg">
                    <xsl:apply-templates mode="getFullTextReg" />
                </field>
            </doc>
        </xsl:if>
    </xsl:template>
    
    <xsl:template match="tei:head | tei:titlePart" mode="fullText">
        <xsl:if test="normalize-space(.)">
            <doc>
                <field name="id">
                    <xsl:value-of select="parent::tei:div[1]/@xml:id | ancestor::tei:titlePage/@xml:id" />
                </field>
                <xsl:sequence select="$documentMetadata" />
                <field name="teiPart">
                    <xsl:value-of select="ancestor::*[parent::tei:text]/name()" />
                </field>
                <field name="teiType">
                    <xsl:value-of select="name()" />
                </field>
                <field name="fullTextOrig">
                    <!--<xsl:value-of select="normalize-space(.)" />-->
                    <xsl:apply-templates mode="getFullTextOrig" />
                </field>
                <field name="fullTextReg">
                    <!--<xsl:value-of select="normalize-space(.)" />-->
                    <xsl:apply-templates mode="getFullTextReg" />
                </field>
            </doc>
        </xsl:if>
    </xsl:template>
    
    <!-- voir comment faire un normalize space sur le fullText tout en régularisant -->
    <xsl:template match="tei:choice/tei:orig" mode="getFullTextReg"/>
    <xsl:template match="tei:choice/tei:reg" mode="getFullTextOrig"/>
    
    <!-- sans doute préférable de les traiter comme synonymes avec Solr -->
    <xsl:template match="tei:choice/tei:expan" mode="getFullTextReg"/>
    <xsl:template match="tei:choice/tei:abbr" mode="getFullTextOrig"/>
    
    <!-- TODO Régler le problème de la normalisation des espaces -->
    <!--<xsl:template match="text()" mode="getFullTextOrig getFullTextReg">
        <xsl:value-of select="normalize-space(.)"/>
    </xsl:template>-->
    
    
    
    <!-- production des métadonnées -->
    <xsl:template match="tei:fileDesc/tei:titleStmt/tei:title[@type='main']" mode="documentMetadata">
        <field name="mainTitle">
            <xsl:value-of select="normalize-space(.)" />
        </field>
    </xsl:template>
    
    <xsl:template match="tei:fileDesc/tei:titleStmt/tei:title[@type='sub']" mode="documentMetadata">
        <field name="subTitle">
            <xsl:value-of select="normalize-space(.)" />
        </field>
    </xsl:template>
    
    <xsl:template match="tei:fileDesc/tei:publicationStmt/tei:idno" mode="documentMetadata">
        <xsl:variable name="idno" select="."/>
        <field name="idno">
            <xsl:value-of select="normalize-space(.)" />
        </field>
        <field name="criticalEdition">
            <xsl:choose>
                <xsl:when test="@n='criticalEdition'">
                    <xsl:text>true</xsl:text>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:text>false</xsl:text>
                </xsl:otherwise>
            </xsl:choose>
        </field>
        <field name="presentation">
            <xsl:choose>
                <xsl:when test="@n='presentation'">
                    <xsl:text>true</xsl:text>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:text>false</xsl:text>
                </xsl:otherwise>
            </xsl:choose>
        </field>
        <!--<field name="file">
            <xsl:value-of select="$file-path" />
            <xsl:text>/</xsl:text>
            <xsl:value-of select="$idno" />
        </field>-->
    </xsl:template>
    
    <!--<xsl:template match="tei:fileDesc/tei:titleStmt/tei:author" mode="documentMetadata">
        <field name="author">
            <xsl:value-of select="." />
        </field>
    </xsl:template>-->
    
    <!--<xsl:template match="tei:fileDesc/tei:titleStmt/tei:editor" mode="documentMetadata">
        <field name="editor">
            <xsl:value-of select="." />
        </field>
    </xsl:template>-->
    
    <xsl:template match="text()" mode="documentMetadata" />
    
    
    <!-- mode entity-mention -->
    <!--<xsl:template match="tei:*[@ref]" mode="entity-mention">
        <doc>
            <field name="id">
                <xsl:value-of
                    select="ancestor::tei:*[self::tei:div or self::tei:body or self::tei:front or self::tei:back or self::tei:group or self::tei:text][@xml:id][1]/@xml:id"
                />
            </field>
            <xsl:sequence select="$documentMetadata" />
            <field name="teiPart">
                <xsl:value-of select="ancestor::*[parent::tei:text]/name()" />
            </field>
            <field name="teiType">
                <xsl:value-of select="name()" />
            </field>
            <field name="entityRef">
                <xsl:value-of select="@ref" />
            </field>
            <field name="entityName">
                <xsl:value-of select="normalize-space(.)" />
            </field>
            <!-\- faire mieux pour récupérer la valeur de l'entité normalisée -\->
            <!-\-<field name="file">
                <xsl:value-of select="$file-path" />
            </field>-\->
        </doc>
    </xsl:template>-->
    <!-- voir ong_texte_cours.xsl pour récupérer le contenu de l'entité et l'insérer dans le texte -->
    
    
    <!-- règles nommées-->
    
    
</xsl:stylesheet>