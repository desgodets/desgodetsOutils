<?xml version="1.0" encoding="UTF-8"?>
<!--
    @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
    @Name :         ttmtChaines.xsl
    @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
    @version :      009
    @creaDate :     2013/05/20
    @modifDate      
    @vXslt:         1.0
    @autor :        Emmanuel Château emchateau@laposte.net
    @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
    @use :          Cette feuille de style se charge de traiter les chaînes de caractères par le biais d'expressions régulières 
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

    <xsl:variable name="apos">'</xsl:variable>
   
    <xsl:strip-space elements="*"/>

    <xsl:template match="/">
        <xsl:variable name="intermediate">
            <xsl:apply-templates mode="phase1"/>
        </xsl:variable>
        <xsl:apply-templates select="$intermediate" mode="phase2"/>
    </xsl:template>
    
    <!-- factoriser avec une règle nommée paramétrisée -->
    
    <!-- glossaire juridique -->
    <xsl:template match="hi[@rend='Desgodets_GlossaireJuridique' or @rend='gJ']" mode="phase1">
        <xsl:element name="term">
            <xsl:attribute name="type">
                <xsl:text>gJ</xsl:text>
            </xsl:attribute>
            <xsl:analyze-string select="." regex="(.*?)\s?\[(.*?)\]\s?" flags="s">
                <xsl:matching-substring>
                    <xsl:attribute name="ref">
                        <xsl:value-of select="concat( '#' , functx:words-to-camel-case(replace(normalize-unicode(regex-group(2), 'NFKD'), '[&#x0300;-&#x036F;]', '') ) )"/>
                    </xsl:attribute>
                    <xsl:value-of select="normalize-space( regex-group(1) )" />
                        <!-- fournir une valeur de n -->
                </xsl:matching-substring>
                <xsl:non-matching-substring>
                    <xsl:attribute name="ref">
                        <xsl:value-of select="concat( '#' , functx:words-to-camel-case(replace(normalize-unicode(., 'NFKD'), '[&#x0300;-&#x036F;]', '') ) )"/>
                    </xsl:attribute>
                    <xsl:value-of select="." />
                </xsl:non-matching-substring>
                <xsl:fallback>bug</xsl:fallback>
            </xsl:analyze-string>
        </xsl:element>
    </xsl:template>

    <!-- glossaire technique -->
    <xsl:template match="hi[@rend='Desgodets_GlossaireTechnique' or @rend='gT']" mode="phase1">
        <xsl:element name="term">
            <xsl:attribute name="type">
                <xsl:text>gT</xsl:text>
            </xsl:attribute>
            <xsl:analyze-string select="." regex="(.*?)\s?\[(.*?)\]\s?" flags="s">
                <xsl:matching-substring>
                    <xsl:attribute name="ref">
                        <xsl:value-of
                            select="concat( '#' , functx:words-to-camel-case(replace(normalize-unicode(regex-group(2), 'NFKD'), '[&#x0300;-&#x036F;]', '') ) )"
                        />
                    </xsl:attribute>
                    <xsl:value-of select="normalize-space( regex-group(1) )"/>
                    <!-- fournir une valeur de n -->
                </xsl:matching-substring>
                <xsl:non-matching-substring>
                    <xsl:attribute name="ref">
                        <xsl:value-of
                            select="concat( '#' , functx:words-to-camel-case(replace(normalize-unicode(., 'NFKD'), '[&#x0300;-&#x036F;]', '') ) )"
                        />
                    </xsl:attribute>
                    <xsl:value-of select="."/>
                </xsl:non-matching-substring>
                <xsl:fallback>bug</xsl:fallback>
            </xsl:analyze-string>
        </xsl:element>
    </xsl:template>
    
    <!-- glossaire technique et index rerum -->
    <xsl:template match="hi[@rend='Desgodets_IndexRerum']" mode="phase1">
        <xsl:element name="term">
            <xsl:attribute name="type">
                <xsl:text>gT</xsl:text>
            </xsl:attribute>
            <xsl:analyze-string select="." regex="(.*?)\s?\[(.*?)\]\s?" flags="s">
                <xsl:matching-substring>
                    <xsl:attribute name="ref">
                        <xsl:value-of
                            select="concat( '#' , functx:words-to-camel-case(replace(normalize-unicode(regex-group(2), 'NFKD'), '[&#x0300;-&#x036F;]', '') ) )"
                        />
                    </xsl:attribute>
                    <xsl:attribute name="ana">
                        <xsl:value-of
                            select="concat( '#i' , functx:words-to-camel-case(replace(normalize-unicode(regex-group(2), 'NFKD'), '[&#x0300;-&#x036F;]', '') ) )"
                        />
                    </xsl:attribute>
                    <xsl:value-of select="normalize-space( regex-group(1) )"/>
                    <!-- fournir une valeur de n -->
                </xsl:matching-substring>
                <xsl:non-matching-substring>
                    <xsl:attribute name="ref">
                        <xsl:value-of
                            select="concat( '#' , functx:words-to-camel-case(replace(normalize-unicode(., 'NFKD'), '[&#x0300;-&#x036F;]', '') ) )"
                        />
                    </xsl:attribute>
                    <xsl:attribute name="ana">
                        <xsl:value-of
                            select="concat( '#i' , functx:words-to-camel-case(replace(normalize-unicode(., 'NFKD'), '[&#x0300;-&#x036F;]', '') ) )"
                        />
                    </xsl:attribute>
                    <xsl:value-of select="."/>
                </xsl:non-matching-substring>
                <xsl:fallback>bug</xsl:fallback>
            </xsl:analyze-string>
        </xsl:element>
    </xsl:template>

    <!--<xsl:template match="hi[@rend='Desgodets_GlossaireTechnique']" mode="phase1">
        <xsl:element name="term">
            <xsl:analyze-string select="." regex="\[(.*?)\]">
                <xsl:matching-substring>
                    <xsl:attribute name="type">
                        <xsl:value-of select="concat( '#' , normalize-space( $regex-group(2) ) )" />
                    </xsl:attribute>
                    <xsl:value-of select="normalize-space( regex-group(1) )" />
                    <!-\- fournir une valeur de n -\->
                </xsl:matching-substring>
                <xsl:non-matching-substring>
                    <xsl:value-of select="." />
                </xsl:non-matching-substring>
                <xsl:fallback>bug</xsl:fallback>
            </xsl:analyze-string>
        </xsl:element>
    </xsl:template>-->

    <!-- numérotation des pb -->
    <!-- <xsl:template match="pb" mode="phase2">
        <xsl:variable name="autoNum">
            <xsl:number level="any" />
        </xsl:variable>
        <xsl:variable name="autoNum"> </xsl:variable>
        <xsl:copy>
            <xsl:apply-templates select="@*|node()" />
        </xsl:copy>
    </xsl:template>-->

    <!-- TRAITEMENT DES CHAINES DE CARACTERES -->
    <!-- chaînes à traiter -->
    <!-- <head>[titre]</head>
         ne rien faire -->
    <!-- [p. 134v] -->
    <!-- regex : p\..*\ -->
    <!-- [p. [corrigé : « 66 »]] -->
    <!-- [p. 67] [corrigé : « 7 » ] -->
    <!-- [p. 74 [« 7 » coupé]] -->
    <!-- <hi rend=”Desgodets_IndexRerum">arcades [arcade]</hi> 
         transformer hi en term
         mettre le premier item dans un orig,
         le second terme dans reg,
         le second terme sur term ref="#valeur" -->
    <!-- <hi rend=”Desgodets_GlossaireTechnique">toisé [toise]</hi> -->
    <!-- <hi rend=”Desgodets_GlossaireTechnique">toisé</hi> -->
    <!-- <hi rend=”Desgodets_GlossaireJuridique">devis</hi> -->
    <!-- <hi rend=”Desgodets_GlossaireJuridique">devis [devis]</hi> -->
    <!-- [item ; item ; item] -->
    <!-- [« item » ; item ; item] -->

    <!-- <placeName>Paris [Paris (France) ;
        http://catalogue.bnf.fr/ark:/12148/cb152821567/PUBLIC]</placeName> -->
    <!-- [aps : « pi. » ; pieds] -->
    <!-- [apc : « po<hi rend="superscript">s</hi> » ; pouces]
         les traiter à la sortie de word pour éviter les pb de chevauchement ? ou impossible -->


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

    <!-- Rechercher tous les neouds texte qui dispose de texte entre crochets
    //*/text()[matches( . , '\[.+\]' )] -->


    <!-- pagination -->
    <!--<xsl:template match="p/text()" mode="pass2">
        <xsl:analyze-string select="." regex="\[a(.*?)\]">
            <xsl:matching-substring>
                <xsl:element name="toto">
                    <xsl:attribute name="n">
                        <xsl:value-of
                            select="normalize-space( regex-group(1) )" />
                    </xsl:attribute>
                    <xsl:element name="tata">
                    <xsl:value-of select="normalize-space( regex-group(1) )" />
                    </xsl:element>
                    <!-\- fournir une valeur de n -\->
                </xsl:element>
            </xsl:matching-substring>
            <xsl:non-matching-substring>
                <xsl:value-of select="." />
            </xsl:non-matching-substring>
            <xsl:fallback>bug</xsl:fallback>
        </xsl:analyze-string>
    </xsl:template>-->

    
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
