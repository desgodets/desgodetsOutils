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
