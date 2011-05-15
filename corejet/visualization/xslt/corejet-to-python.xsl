<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    version="1.0">
    <xsl:template match="//story">
        import unittest2 as unittest
        from corejet.core import story, scenario, given, when, then
        
        @story(id="<xsl:value-of select="@id"/>", title="<xsl:value-of select="@title"/>")
        class <xsl:value-of select="translate(@title,' -&quot;','_')"/>(unittest.TestCase):
            
            <xsl:for-each select="given">
                @given("<xsl:value-of select="text()"/>")
                def <xsl:value-of select="translate(text(),' -&quot;','_')"/>(self):
                    pass
                    
            </xsl:for-each>
            
            <xsl:for-each select="when">
                @when("<xsl:value-of select="text()"/>")
                def <xsl:value-of select="translate(text(),' -&quot;','_')"/>(self):
                    pass
                
            </xsl:for-each>
            
            <xsl:for-each select="then">
                @then("<xsl:value-of select="text()"/>")
                def <xsl:value-of select="translate(text(),' -&quot;','_')"/>(self):
                    pass
            
            </xsl:for-each>
            
            <xsl:apply-templates select="scenario"/>
    </xsl:template>
    
    <xsl:template match="scenario">
        
            @scenario("<xsl:value-of select="@name"/>")
            class <xsl:value-of select="translate(@name,' -&quot;','_')"/>:
            
                <xsl:for-each select="given">
                    @given("<xsl:value-of select="text()"/>")
                    def <xsl:value-of select="translate(text(),' -&quot;','_')"/>(self):
                        pass
                        
                </xsl:for-each>
                
                <xsl:for-each select="when">
                    @when("<xsl:value-of select="text()"/>")
                    def <xsl:value-of select="translate(text(),' -&quot;','_')"/>(self):
                        pass
                    
                </xsl:for-each>
                
                <xsl:for-each select="then">
                    @then("<xsl:value-of select="text()"/>")
                    def <xsl:value-of select="translate(text(),' -&quot;','_')"/>(self):
                        pass
                
                </xsl:for-each>

    </xsl:template>
    
</xsl:stylesheet>