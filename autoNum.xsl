<?xml version="1.0" encoding="UTF-8"?>
<!--
    @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
    @Name :         autoNum.xsl
    @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
    @version :      003
    @creaDate :     2013/01/03
    @modifDate      
    @vXslt:         2.0
    @autor :        Emmanuel Château emchateau@laposte.net
    @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
    @use :          Cette feuille de style assure la numérotation automatique des divisions textuelles dans un document XML-TEI selon le système d'identifiants uniques établi pour le projet ANR Desgodets. 
    @knownBugs :    Traite de manière inopportune les éléments du header TEI et certains éléments p
                    Les règles ne s'appliquent pas lorsque l'élément xml:id est déjà défini.
                    L'unicité des éléments xml:id n'est donc pas garantie.
                    = problème de validité du document résultat.
    @todo :         Exclure le header du traitement
                    Récupérer le numéro d'ordre du manuscrit dans le corpus à partir du header TEI
                    Produire des xml:id pour les éléments list/item
    @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
    @inspired :      http://stackoverflow.com/questions/12752317/xslt-generate-unique-id-for-root-element-and-append-that-value-to-the-id-of-c
                    Solution proposée par Sebastian Rahtz, http://listserv.brown.edu/archives/cgi-bin/wa?A2=ind0809&L=TEI-L&D=0&P=3109
    @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
-->
<xsl:stylesheet 
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
    xpath-default-namespace="http://www.tei-c.org/ns/1.0">
    
    <xsl:output indent="yes" method="xml" encoding="UTF-8" />
    
    <xsl:strip-space elements="*"/>
    
    <!-- choix du préfixe -->
    <xsl:param name="prefix" select="'t4'" />
    
    <!-- Copie à l'identique du fichier -->
    <xsl:template match="node()|@*">
        <xsl:copy>
            <xsl:apply-templates select="node()|@*"/>
        </xsl:copy>
    </xsl:template>
    
    <!-- prévoir une règle pour automatiser la récupération de l'identifiant dans le corpus -->
    <!-- @bug : les règles ne s'appliquent pas lorsqu'un attribut xml:id est déjà défini -->
    
    <!-- définition du motif -->
    <xsl:template match="front|body|back">
        <!-- copie le nœud courant et lui ajoute un attribut xml:id, puis descend dans les nœuds fils en passant en paramètre la dernière valeur utilisée -->
        <xsl:copy>
            <!-- passe en variable le nom de l'élément de travail concaténé avec l'identifiant du cours -->
            <xsl:variable name="curId">
                <!-- utilisation d'une fonction XSLT 2.0 pour la notation camelCase (plus simple qu'en XSLT 1.0) -->
                <xsl:value-of
                    select="concat($prefix, upper-case(substring(local-name(.),1,1)),
                    substring(local-name(.), 2))"
                 />
            </xsl:variable>
            <!-- ajoute l'attribut -->
            <xsl:attribute name="xml:id">
                <xsl:value-of select="$curId" />
            </xsl:attribute>
            <!-- descendre dans les nœuds enfants -->
            <xsl:apply-templates select="node()|@*">
                <!-- à tester mais le select n'est sans doute pas nécessaire -->
                <xsl:with-param name="prevId" select="$curId" />
            </xsl:apply-templates>
        </xsl:copy>
    </xsl:template>
    <xsl:template
        match="div|titlePage|p[parent::div|parent::argument|parent::postscript|parent::epigraph]">
        <!-- attention, on n'exclue pas le header du traitement -->
        <!-- récupère la variable -->
        <xsl:param name="prevId" />
        <!-- copie le nœud courant et lui ajoute un attribut xml:id, puis descend dans les nœuds fils en passant en paramètre le dernier id utilisé -->
        <xsl:copy>
            <!-- passe en variable le nom de l'élément de travail concaténé avec l'identifiant du cours -->
            <xsl:variable name="curId">
                <xsl:choose>
                    <xsl:when test="self::div[@xml:lang][parent::front]|self::div[@xml:lang][parent::body]|self::div[@xml:lang][parent::back]">
                        <xsl:value-of select="$prevId" />
                        <!--<xsl:number level="single" from="/*" format="01"/>-->
                        <xsl:text>Fr</xsl:text>
                    </xsl:when>
                    <xsl:when test="self::div[parent::div[@xml:lang]]">
                        <xsl:value-of select="$prevId" />
                        <xsl:number level="single" from="/*" format="01"/>
                    </xsl:when>
                    <!-- 3 chiffres précédés de p pour les paragraphes (priorité sur la condition suivante) -->
                    <xsl:when test="self::p">
                        <xsl:value-of select="concat($prevId,'.p')" />
                        <xsl:number level="single" from="/*" format="001" />
                    </xsl:when>
                    <!-- trois chiffres à la profondeur 5 -->
                    <!-- (solution à améliorer) -->
                    <xsl:when test="count(ancestor::*)>5">
                        <xsl:value-of select="concat($prevId,'.')" />
                        <xsl:number level="single" from="/*" format="001" />
                    </xsl:when>
                    <!-- autres cas  -->
                    <xsl:otherwise>
                        <xsl:value-of select="concat($prevId,'.')" />
                        <xsl:number level="single" from="/*" format="01" />
                    </xsl:otherwise>
                    <!-- TODO : raffiner pour traiter les éléments list et item, et seg -->
                </xsl:choose>
            </xsl:variable>
            <!-- ajoute l'attribut -->
            <xsl:attribute name="xml:id">
                <xsl:value-of select="$curId" />
            </xsl:attribute>
            <!-- descendre dans les nœuds enfants -->
            <!-- descendre dans les nœuds enfants -->
            <xsl:apply-templates select="node()|@*">
                <!-- à tester mais le select n'est sans doute pas nécessaire -->
                <xsl:with-param name="prevId" select="$curId" />
            </xsl:apply-templates>
        </xsl:copy>
    </xsl:template>
</xsl:stylesheet>