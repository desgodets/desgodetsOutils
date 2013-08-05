<?xml version="1.0" encoding="UTF-8"?>
<!-- xpath-default-namespace slmt en XSLT2.0 -->
<!--
    @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
    @Name :         mettrePdansDiv.xsl
    @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
    @version :      005
    @creaDate :     2014/05/16
    @modifDate      
    @vXslt:         2.0
    @autor :        Emmanuel Château emchateau@laposte.net
    @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
    @use :          cette feuille de style place les éléments P qui commencent par des chiffres dans un div.
    @knownBugs :    amusant de constater que créé une hiéarchie dans l'état
    @todo :         
    @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
    @inspired :     http://www.ibm.com/developerworks/library/x-addstructurexslt/
    @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
-->    

<xsl:stylesheet 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
    xpath-default-namespace="http://www.tei-c.org/ns/1.0" 
    xmlns="http://www.tei-c.org/ns/1.0">
    <!-- xpath-default-namespace slmt en XSLT2.0 -->
    
    <xsl:output indent="yes" method="xml" encoding="UTF-8" />
    
    <xsl:variable name="number" select="'^\s*(\d+.?)\s*(.*)$'"/>
    <xsl:variable name="secRegex" select="'^\s*(\d+\.\d+)\s*(.*)$'"/>

    <xsl:template match="document">
        <xsl:variable name="renamed" as="element()*">
            <xsl:apply-templates select="*" mode="rename"/>
        </xsl:variable>
        <document>
            <xsl:for-each-group select="$renamed" group-starting-with="chapTitle">
                <chapter num="{replace(current-group()[self::chapTitle],number,'$1')}">
                    <xsl:for-each-group select="current-group()" group-starting-with="secTitle">
                        <xsl:choose>
                            <xsl:when test="current-group()[self::secTitle]">
                                <section num="{replace(current-group()[self::secTitle],$secRegex,'$1')}">
                                    <xsl:apply-templates select="current-group()"/>
                                </section>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:apply-templates select="current-group()"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:for-each-group>
                </chapter>
            </xsl:for-each-group>
        </document>
    </xsl:template>
    
    <xsl:template match="p[matches(.,$number)]" mode="rename">
        <chapTitle>
            <xsl:copy-of select="node()"/>
        </chapTitle>
    </xsl:template>
    
    <xsl:template match="text()" priority="1">
        <xsl:choose>
            <xsl:when test="matches(.,$number) and (. is parent::chapTitle/node()[1])">
                <xsl:value-of select="replace(.,$number,'$2')"/>
            </xsl:when>
            <!--<xsl:when test="matches(.,$secRegex) and (. is parent::secTitle/node()[1])">
                <xsl:value-of select="replace(.,$secRegex,'$2')"/>
            </xsl:when>-->
            <xsl:otherwise>
                <xsl:copy-of select="."/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <!-- Copie à l'identique du fichier (toutes les passes) -->
    <xsl:template match="node()" mode="#all">
        <xsl:copy>
            <xsl:copy-of select="@*"/>
            <xsl:apply-templates mode="#current"/>
        </xsl:copy>
    </xsl:template>
    
</xsl:stylesheet>

    
    <!--<xsl:template match="p[matches(.,'^\d')]">
        
        <xsl:analyze-string select="." regex="^(\d+.?\s)((.*\n?)*)">
            <xsl:matching-substring>
                <div type="number">    
                    <label>
                        <num>
                            <xsl:value-of select="regex-group(1)" />
                        </num>
                    </label>
                    <p>
                        <xsl:value-of select="regex-group(2)" />
                    </p>
                </div>
            </xsl:matching-substring>
            <xsl:non-matching-substring>
                <p rend="prb"><xsl:copy-of select="."></xsl:copy-of></p>
            </xsl:non-matching-substring>
            <xsl:fallback />
        </xsl:analyze-string>
  
    </xsl:template>-->
