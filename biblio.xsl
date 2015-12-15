<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.1" exclude-result-prefixes="tei"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns="http://www.w3.org/1999/xhtml">
    
    <xsl:output indent="yes" method="xml" encoding="UTF-8"
        doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN" />
    
    <xsl:strip-space elements="*" />
    
    <!-- ci-dessous à remplacer pour l'intégration -->
    <xsl:template match="/">
        <html>
            <head></head>
            <body>
                <div>
                    <xsl:apply-templates />
                </div>
            </body>
        </html>
    </xsl:template>
    
    <!-- instanciation de la règle -->
    <xsl:template match="tei:listBibl">
        <div class="listBibl">
            <xsl:for-each select="tei:biblStruct">
                <!-- TODO : introduire un sort ? -->
                <xsl:call-template name="biblStruct"/>
            </xsl:for-each>
        </div>
    </xsl:template>
    
    <xsl:template name="biblStruct" mode="bibl">
        <div class="biblStruct" id="{@xml:id}">
            <xsl:apply-templates select="tei:analytic" mode="bibl"/>
            <xsl:apply-templates select="tei:monogr" mode="bibl"/>
            <xsl:text>.</xsl:text>
            <xsl:apply-templates select="tei:series" mode="bibl"/>
            <!-- afficher extent si présent -->
            <xsl:if test="tei:monogr/tei:extent">
                <xsl:value-of
                    select="tei:monogr/tei:extent" />
            </xsl:if>
            <!-- instanciation des identifiants -->
            <xsl:apply-templates select="tei:idno[@type='isbn10']" mode="bibl"/>
            <xsl:apply-templates select="tei:idno[@type='catBnf']" mode="bibl"/>
        </div>
    </xsl:template>
    
    
    <!-- traitement de analytic -->
    <xsl:template match="tei:analytic" mode="bibl">
        <xsl:apply-templates select="tei:author | tei:editor" mode="bibl"/>
        <xsl:apply-templates select="tei:title" mode="bibl"/>
        <xsl:choose>
            <xsl:when test="following-sibling::tei:monogr/tei:title[@level='m']" >
                <xsl:text>. In </xsl:text>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text>. </xsl:text>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <!-- traitement de monogr-->
    <xsl:template match="tei:monogr" mode="bibl">
        <xsl:choose>
            <!-- lorsque suit un analytic -->
            <xsl:when test="preceding-sibling::tei:analytic and preceding-sibling::tei:title[@level='a']">
                <xsl:apply-templates select="tei:author | tei:editor" mode="bibl" />
                <xsl:apply-templates select="tei:title" mode="bibl" />
                <xsl:if test="tei:edition">
                    <xsl:text>, </xsl:text>
                    <xsl:apply-templates select="tei:edition" mode="bibl"/>
                </xsl:if>
                <xsl:if test="tei:meeting">
                    <xsl:text>, </xsl:text>
                    <xsl:apply-templates select="tei:meeting" mode="bibl"/>
                </xsl:if>
                <xsl:text>, </xsl:text>
            </xsl:when>
            <xsl:otherwise>
                <xsl:apply-templates select="tei:author | tei:editor" mode="bibl"/>
                <xsl:apply-templates select="tei:title" mode="bibl"/>
                <xsl:if test="tei:edition">
                    <xsl:text>. </xsl:text>
                    <xsl:apply-templates select="tei:edition" mode="bibl" />
                </xsl:if>
                <xsl:if test="tei:meeting">
                    <xsl:text>. </xsl:text>
                    <xsl:apply-templates select="tei:meeting" mode="bibl" />
                </xsl:if>
                <xsl:text>. </xsl:text>
            </xsl:otherwise>
        </xsl:choose>
        <xsl:choose>
            <xsl:when test="ancestor-or-self::tei:biblStruct/*/tei:title/@level='u'">
                <xsl:value-of select="tei:imprint"/>
            </xsl:when>
            <xsl:when test="tei:title/@level='m'">
                <xsl:apply-templates select="tei:imprint" mode="monographie"/>
            </xsl:when>
            <xsl:when test="tei:title/@level='j'">
                <xsl:apply-templates select="tei:imprint" mode="journal" />
            </xsl:when>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template match="tei:series" mode="bibl">
        <xsl:text>(</xsl:text>
        <xsl:value-of select="tei:title"/>
        <xsl:if test="tei:biblScope">
            <xsl:text>, n°&#160;</xsl:text>
            <xsl:value-of select="."/>
        </xsl:if>
        <xsl:text>)</xsl:text>
    </xsl:template>
    
    <!-- mentions de responsabilités -->
    <xsl:template match="tei:editor | tei:author" mode="bibl">
        <span class="persName">
            <xsl:for-each select="tei:persName">
                <xsl:apply-templates select="." mode="bibl" />
                <xsl:if test="parent::tei:editor and position() = last()">
                    <xsl:choose>
                        <xsl:when test="position() &gt;2">
                            <xsl:text>, (éds.) </xsl:text>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:text>, (éd.) </xsl:text>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:if>
            </xsl:for-each>
            <xsl:text>.</xsl:text>
        </span>
        <xsl:text> </xsl:text>
    </xsl:template>
    
    <xsl:template match="tei:persName" mode="bibl">
        <xsl:value-of select="normalize-space(tei:forename)" />
        <xsl:text> </xsl:text>
        <span class="surname">
            <xsl:value-of select="normalize-space(tei:surname)" />
        </span>
        <xsl:if
            test="following-sibling::tei:persName | following-sibling::tei:editor">
            <xsl:text>, </xsl:text>
        </xsl:if>
    </xsl:template>
    
    <!-- traitement des titres -->
    <xsl:template match="tei:title" mode="bibl">
        <em class="title">
            <xsl:value-of select="normalize-space(.)" />
        </em>
    </xsl:template>
    
    <xsl:template match="tei:title[@level='a']" mode="bibl">
        <span class="title">
            <xsl:text>« </xsl:text>
            <xsl:value-of select="normalize-space(.)" />
            <xsl:text> »</xsl:text>
        </span>
    </xsl:template>
    
    <!-- mentions d'édition -->
    <xsl:template match="tei:edition" mode="bibl">
        <span class="edition">
            <xsl:value-of select="normalize-space(.)"/>
        </span>
    </xsl:template>
    <xsl:template match="tei:meeting" mode="bibl">
        <span class="meeting">
            <xsl:value-of select="normalize-space(.)"/>
        </span>
    </xsl:template>
    
    <xsl:template match="tei:imprint" mode="monographie">
        <span class="imprint">
            <xsl:if test="tei:biblScope/@type='vol'">
                <xsl:value-of select="tei:biblScope[@type='vol']" /> vol. </xsl:if>
            <xsl:choose>
                <xsl:when test="tei:pubPlace">
                    <xsl:value-of select="tei:pubPlace" />
                    <xsl:text>&#160;: </xsl:text>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:text>s.l.&#160;: </xsl:text>
                </xsl:otherwise>
            </xsl:choose>
            <xsl:choose>
                <xsl:when test="tei:publisher" >
                    <xsl:value-of select="tei:publisher" />
                    <xsl:text>, </xsl:text>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:text>s.p., </xsl:text>
                </xsl:otherwise>
            </xsl:choose>
            <xsl:choose>
                <xsl:when test="tei:date">
                    <xsl:value-of select="tei:date" />
                </xsl:when>
                <xsl:otherwise>
                    <xsl:text>s.d</xsl:text>
                </xsl:otherwise>
            </xsl:choose>
        </span>
    </xsl:template>
    
    <xsl:template match="tei:imprint" mode="journal">
        <span class="imprint">
            <xsl:if test="tei:biblScope/@type='vol'">
                <xsl:text>Vol.&#160;:</xsl:text>
                <xsl:value-of select="tei:imprint/tei:biblScope[@type='vol']" />
                <xsl:text>, </xsl:text>
            </xsl:if>
            <xsl:if test="tei:biblScope/@type='no'">
                <xsl:text>n°&#160;</xsl:text>
                <xsl:value-of select="tei:biblScope[@type='no']" />
                <xsl:text>, </xsl:text>
            </xsl:if>
            <xsl:if test="tei:date">
                <xsl:text>&#160;</xsl:text>
                <xsl:value-of select="tei:date" />
                <xsl:text>, </xsl:text>
            </xsl:if>
            <xsl:if test="tei:biblScope/@type='pp'">
                <xsl:text>p.&#160;</xsl:text>
                <xsl:value-of select="tei:biblScope[@type='pp']" />
            </xsl:if>
        </span>
    </xsl:template>
    
    <!-- traitement des identifiants -->
    <xsl:template match="tei:idno[@type='catBnf']" mode="bibl">
        <div class="bnf">
            <a target="_blank">
                <xsl:attribute name="href">
                    <xsl:value-of select="."/>
                </xsl:attribute>
                <xsl:text>Bnf</xsl:text>
            </a>
        </div>
    </xsl:template>
    
    <xsl:template match="tei:idno[@type='isbn10']" mode="bibl">
        <div>
            <xsl:text>ISBN </xsl:text>
            <xsl:apply-templates/>
        </div>
    </xsl:template>
    
</xsl:stylesheet>
