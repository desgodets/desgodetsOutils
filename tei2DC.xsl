<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.1" exclude-result-prefixes="tei"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns="http://www.w3.org/1999/xhtml">

    <xsl:output indent="yes" method="xml" encoding="UTF-8"
        doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN" />
    
    <xsl:strip-space elements="*" />
    
    <!-- pour l'intégration -->
    <xsl:template match="tei:TEI">
        <xsl:apply-templates select="tei:teiHeader" mode="meta" />
    </xsl:template>
    
    <!-- production des méta -->
    <xsl:template match="tei:teiHeader" mode="meta">
        <!-- Si on traite le corpus général de l'édition avec seriesStmt, sinon @type='subSub' et @type='subSubSub' -->
        <xsl:variable name="title">
            <xsl:value-of
                select="normalize-space( tei:fileDesc/tei:titleStmt/tei:title[@type='main'] )" />
            <xsl:text> | </xsl:text>
            <xsl:value-of
                select="normalize-space( tei:fileDesc/tei:titleStmt/tei:title[@type='sub'] )" />
        </xsl:variable>
        <head>
            <meta http-equiv="Content-language" content="fr" />
            <title>
                <xsl:value-of select="$title"/>
            </title>
            <!-- TODO : générer l'url de la page -->
            <meta name="url" content="http://desgodets.net/xxx" />
            <!-- TODO : fournir l'url de la version pdf si elle existe -->
            <!--<link rel="alternate" href="http://desgodets.net/pdf/xxx" type="application/pdf" title="$title" />-->
            <link rel="schema.DCTERMS" href="http://purl.org/dc/terms/" />
            <meta>
                <xsl:attribute name="name">DCTERMS.type</xsl:attribute>
                <xsl:attribute name="content">
                    <xsl:value-of
                        select="normalize-space( tei:profileDesc/tei:textClass/tei:classCode/tei:term )"
                     />
                </xsl:attribute>
            </meta>
            <meta>
                <xsl:attribute name="name">DCTERMS.format</xsl:attribute>
                <xsl:attribute name="content">text/html</xsl:attribute>
            </meta>
            <meta>
                <xsl:attribute name="name">DCTERMS.identifier</xsl:attribute>
                <xsl:attribute name="content">
                    <xsl:value-of
                        select="normalize-space( tei:fileDesc/tei:publicationStmt/tei:idno )" />
                </xsl:attribute>
            </meta>
            <meta>
                <xsl:attribute name="name">DCTERMS.title</xsl:attribute>
                <xsl:attribute name="content">
                    <xsl:value-of select="$title"/>
                </xsl:attribute> 
            </meta>
            <meta>
                <!-- voir ce que cela donne sans sélectionner séparément les orgName -->
                <xsl:attribute name="name">DCTERMS.publisher</xsl:attribute>
                <xsl:attribute name="content">
                    <xsl:value-of
                        select="normalize-space( tei:fileDesc/tei:publicationStmt/tei:publisher/tei:orgName )"
                     />
                </xsl:attribute>
            </meta>
            <meta>
                <xsl:attribute name="name">DCTERMS.language</xsl:attribute>
                <xsl:attribute name="content">fr</xsl:attribute>
            </meta>
            <meta>
                <xsl:attribute name="name">author</xsl:attribute>
                <xsl:attribute name="content">
                    <xsl:apply-templates select="tei:fileDesc/tei:titleStmt/tei:author/tei:persName" mode="meta" />
                </xsl:attribute>
            </meta>
            <meta>
                <xsl:attribute name="name">DCTERMS.creator</xsl:attribute>
                <xsl:attribute name="content">
                    <xsl:apply-templates select="tei:fileDesc/tei:titleStmt/tei:author/tei:persName" mode="meta" />
                </xsl:attribute>
            </meta>
            <!-- générer les meta DCTERMS.contributor.sponsors -->
            <xsl:apply-templates select="tei:fileDesc/tei:titleStmt/tei:funder" mode="meta" />
            <!-- générer les meta DCTERMS.contributor.editor -->
            <xsl:apply-templates select="tei:fileDesc/tei:titleStmt/tei:respStmt[child::tei:resp[@key='edt']]" mode="meta"/>
            
            <!-- générer les meta DCTERMS.contributor.encoder -->
            <xsl:apply-templates select="tei:fileDesc/tei:titleStmt/tei:respStmt[child::tei:resp[@key='mrk']]" mode="meta" />
            
            <meta>
                <xsl:attribute name="name">description</xsl:attribute>
                <xsl:attribute name="content">
                    <xsl:value-of
                        select="normalize-space( tei:fileDesc/tei:notesStmt/tei:note[@lang='fre'] )"
                     />
                </xsl:attribute>
                <xsl:attribute name="xml:lang">fr</xsl:attribute>
                <xsl:attribute name="lang">fr</xsl:attribute>
            </meta>
            <meta>
                <xsl:attribute name="name">DCTERMS.description</xsl:attribute>
                <xsl:attribute name="content">
                    <xsl:value-of
                        select="normalize-space(tei:fileDesc/tei:notesStmt/tei:note[@lang='fre'])"
                     />
                </xsl:attribute>
                <xsl:attribute name="xml:lang">fr</xsl:attribute>
                <xsl:attribute name="lang">fr</xsl:attribute>
            </meta>
            <meta>
                <xsl:attribute name="name">keywords</xsl:attribute>
                <xsl:attribute name="content">
                    <xsl:apply-templates select="tei:profileDesc/tei:textClass/tei:keywords[@xml:lang='fre']" mode="meta"/>
                </xsl:attribute>
                <xsl:attribute name="xml:lang">fr</xsl:attribute>
                <xsl:attribute name="lang">fr</xsl:attribute>
            </meta>
            <meta>
                <xsl:attribute name="name">DCTERMS.subject</xsl:attribute>
                <xsl:attribute name="content">
                    <xsl:apply-templates select="tei:profileDesc/tei:textClass/tei:keywords[@xml:lang='fre']" mode="meta"/>
                </xsl:attribute>
                <xsl:attribute name="xml:lang">fr</xsl:attribute>
                <xsl:attribute name="lang">fr</xsl:attribute>
            </meta>
            <meta>
                <xsl:attribute name="name">description</xsl:attribute>
                <xsl:attribute name="content">
                    <xsl:value-of
                        select="normalize-space( tei:fileDesc/tei:notesStmt/tei:note[@lang='eng'] )"
                     />
                </xsl:attribute>
                <xsl:attribute name="xml:lang">en</xsl:attribute>
                <xsl:attribute name="lang">en</xsl:attribute>
            </meta>
            <meta>
                <xsl:attribute name="name">DCTERMS.description</xsl:attribute>
                <xsl:attribute name="content">
                    <xsl:value-of
                        select="normalize-space( tei:fileDesc/tei:notesStmt/tei:note[@lang='eng'] )"
                     />
                </xsl:attribute>
                <xsl:attribute name="xml:lang">en</xsl:attribute>
                <xsl:attribute name="lang">en</xsl:attribute>
            </meta>
            <meta>
                <xsl:attribute name="name">keywords</xsl:attribute>
                <xsl:attribute name="content">
                    <xsl:apply-templates select="tei:profileDesc/tei:textClass/tei:keywords[@xml:lang='eng']" mode="meta"/>
                </xsl:attribute>
                <xsl:attribute name="xml:lang">en</xsl:attribute>
                <xsl:attribute name="lang">en</xsl:attribute>
            </meta>
            <meta>
                <xsl:attribute name="name">DCTERMS.subject</xsl:attribute>
                <xsl:attribute name="content">
                    <xsl:apply-templates select="tei:profileDesc/tei:textClass/tei:keywords[@xml:lang='eng']" mode="meta"/>
                </xsl:attribute>
                <xsl:attribute name="xml:lang">en</xsl:attribute>
                <xsl:attribute name="lang">en</xsl:attribute>
            </meta>
            <meta>
                <xsl:attribute name="name">DCTERMS.date</xsl:attribute>
                <!-- on doit pouvoir se passer de text() -->
                <xsl:attribute name="content">
                    <xsl:value-of
                        select="tei:profileDesc/tei:creation/@notBefore" />
                    <xsl:text>/</xsl:text>
                    <xsl:value-of
                        select="tei:profileDesc/tei:creation/@notAfter" />
                    <xsl:value-of select="tei:profileDesc/tei:creation/@when" />
                </xsl:attribute>
            </meta>
            <meta>
                <xsl:attribute name="name">DCTERMS.date.modified</xsl:attribute>
                <xsl:attribute name="content">
                    <xsl:value-of select="tei:revisionDesc/tei:change[1]/@when" />
                </xsl:attribute>
            </meta>
            <meta>
                <xsl:attribute name="name">DCTERMS.rights</xsl:attribute>
                <xsl:attribute name="content">
                    <xsl:value-of
                        select="tei:fileDesc/tei:publicationStmt/tei:availability/tei:licence/@target"
                     />
                </xsl:attribute>
            </meta>
            <meta>
                <xsl:attribute name="name"
                    >DCTERMS.relation.isPartOf</xsl:attribute>
                <xsl:attribute name="content">
                    <xsl:value-of select="normalize-space( tei:fileDesc/tei:seriesStmt/tei:idno )"
                     />
                </xsl:attribute>
            </meta>
            <!--<meta>
                <xsl:attribute name="name"
                    >DCTERMS.source</xsl:attribute>
                <xsl:attribute name="content">
                    <xsl:value-of select="normalize-space( tei:fileDesc/tei:seriesStmt/tei:idno )"
                    />
                </xsl:attribute>
            </meta>-->
            <!--<meta>
                <xsl:attribute name="name"
                    >DCTERMS.conformsTo</xsl:attribute>
                <xsl:attribute name="content">
                    <xsl:value-of select="normalize-space( tei:fileDesc/tei:seriesStmt/tei:idno )"
                    />
                </xsl:attribute>
            </meta>-->
        </head>
    </xsl:template>
    
    <xsl:template match="tei:keywords" mode="meta">
        <xsl:for-each select="tei:term">
            <xsl:value-of select="normalize-space(.)" />
            <xsl:if test="position() != last()">
                <xsl:text> , </xsl:text>
            </xsl:if>
        </xsl:for-each>
    </xsl:template>
    
    <xsl:template match="tei:funder" mode="meta">
        <meta>
            <xsl:attribute name="name"
                >DCTERMS.contributor.sponsors</xsl:attribute>
            <xsl:attribute name="content">
                <xsl:value-of select="normalize-space(tei:orgName)" />
                <xsl:value-of
                    select="concat( ' (' , normalize-space( tei:orgName[@type='acronym']) , ')' )"
                 />
            </xsl:attribute>
        </meta>
    </xsl:template>
    
    <xsl:template match="tei:respStmt" mode="meta">
        <xsl:variable name="metaName">
            <xsl:choose>
                <xsl:when test="child::tei:resp[@key='edt']">
                    <xsl:text>DCTERMS.contributor.editor</xsl:text>
                </xsl:when>
                <xsl:when test="child::tei:resp[@key='mrk']">
                    <xsl:text>DCTERMS.contributor.encoder</xsl:text>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:text>DCTERMS.contributor</xsl:text>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:for-each select="tei:persName">
            <meta>
                <xsl:attribute name="name">
                    <xsl:value-of select="$metaName"/>
                </xsl:attribute> 
                <xsl:attribute name="content">
                    <xsl:apply-templates select="." mode="meta" />
                </xsl:attribute>
            </meta>
        </xsl:for-each>
    </xsl:template>
    
    <xsl:template match="tei:persName" mode="meta">
        <xsl:value-of
            select="normalize-space( tei:surname )" />
        <xsl:text>, </xsl:text>
        <xsl:value-of
            select="normalize-space( tei:forename )"
        />
    </xsl:template>
</xsl:stylesheet>
