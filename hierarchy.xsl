<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    version="1.0">
    <!--For completeness, here's Stuart's demonstration source:--> 
    <!-- source : http://tei-l.970651.n3.nabble.com/XSLT-caveats-was-Re-Bible-Markup-tt2339249.html#a2339258 -->
    <!--<seg type="verse" n="1"> 
        
        <milestone unit="p" id="Ob.1.p1"/> 
        The vision of Obadiah. 
        <ptr type="p" target="Ob.1.p1"/> 
        
        <milestone unit="p" id="Ob.1.p2"/> 
        This is what the Sovereign Lord says about Edom- 
        <ptr type="p" target="Ob.1.p2"/> 
        
        <milestone unit="lg" id="Ob.1.lg1"/> 
        
        <milestone unit="l" id="Ob.1.lg1.l1"/> 
        We have heard a message from the Lord : 
        <ptr type="l" target="Ob.1.lg1.l1"/> 
        
        <milestone unit="l" id="Ob.1.lg1.l2"/> 
        An envoy was sent to the nations to say, 
        <ptr type="l" target="Ob.1.lg1.l2"/> 
        
        <milestone unit="l" id="Ob.1.lg1.l3"/> 
        "Rise, and let us go against her for battle"- 
        <ptr type="l" target="Ob.1.lg1.l3"/> 
        
        <ptr type="lg" id="Ob.1.lg1"/> 
        
    </seg> -->
    
    <!--and here's a Pure XSLT solution (will work in any compliant processor): -->
    

        <xsl:output indent="yes"/> 
        
        <xsl:strip-space elements="seg"/> 
        
        <xsl:template match="seg"> 
            <milestone unit="{@type}" id="{@n}"/> 
            <xsl:apply-templates select="milestone[@unit='p' or @unit='lg']"/> 
            <!-- we're going to pull the hierarchy up by its milestones ... 
        in this case, they're the ones that mark the start of (what 
        will be) p and lg elements --> 
        </xsl:template> 
        
        <xsl:key name="text-by-container" match="text()" 
            use="generate-id(preceding::milestone[@unit='p' or @unit='l'][1])"/> 
        <!-- this key allows us to retrieve text nodes that "belong" to what 
      will be their "container" elements (p and l elements); 
      we could extend this to include inline elements if we had 
      mixed content and they were never split by our milestones 
      (if they were we'd have lots more work) --> 
        
        <xsl:key name="l-by-lg" match="milestone[@unit='l']" 
            use="generate-id(preceding::milestone[@unit='lg'][1])"/> 
        <!-- this key allows us to retrieve l nodes that belong to an lg --> 
        
        <xsl:template match="ptr"/> 
        <!-- this template rule is actually redundant since ptr elements 
      never get selected in any case.... --> 
        
        <xsl:template match="milestone[@unit='p' or @unit='l']"> 
            <xsl:element name="{@unit}"> 
                <!-- we generate a p or l element accordingly --> 
                <xsl:apply-templates 
                    select="key('text-by-container', generate-id(.))"/> 
                <!-- and when we do, we want the text that goes inside: 
            in an example with mixed content, our key would have 
            to pull other sorts of nodes too --> 
            </xsl:element> 
        </xsl:template> 
        
        <xsl:template match="milestone[@unit='lg']"> 
            <xsl:element name="{@unit}"> 
                <xsl:apply-templates select="key('l-by-lg', generate-id(.))"/> 
                <!-- when we generate an lg, we'll want its l elements --> 
            </xsl:element> 
        </xsl:template> 
        
        <xsl:template match="text()"> 
            <!-- we could use the default, but let's clean up whitespace 
        (in a more complex application you might not be able to do this 
safely) --> 
            <xsl:value-of select="normalize-space()"/> 
        </xsl:template> 
        
        <!--Here's the output this stylesheet creates: -->
        
        <!--<?xml version="1.0" encoding="utf-8"?> 
    <milestone unit="verse" id="1"/> 
    <p>The vision of Obadiah.</p> 
    <p>This is what the Sovereign Lord says about Edom-</p> 
    <lg> 
        <l>We have heard a message from the Lord :</l> 
        <l>An envoy was sent to the nations to say,</l> 
        <l>"Rise, and let us go against her for battle"-</l> 
    </lg> 
    -->
        <!--If you want more of an explanation for how this technique works, see Jeni's 
    site at http://www.jenitennison.com under "creating hierarchy", or her book 
    _XSLT and XPath on the Edge_.-->
    </xsl:stylesheet>