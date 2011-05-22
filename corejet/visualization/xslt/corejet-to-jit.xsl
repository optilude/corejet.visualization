<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    version="1.0">
    <xsl:output omit-xml-declaration="yes"/>
    
    <xsl:template match="//requirementscatalogue">
        // corejet-output.js, generated from Corejet Requirements Catalogue
        
        var custom_color_for = function(num_passing, num_pending, total) {
            var weighted = ( num_passing + (0.3 * num_pending) ) / total;
        
            var red = (255 * weighted) / 100;
            var green = (255*(100-weighted)) / 100;
            
            if (total==0) {
                red = 0;
                green = 0;
            }
        
            return 'rgb('+red+','+green+',0)';
        }
        
        var metadata = {
            'project':  '<xsl:value-of select="@project"/>',
            'testTime': '<xsl:value-of select="@testTime"/>'
        }
        
        var json = {
            'id':       'root',
            'name':     '<xsl:value-of select="@project"/>',
            'data':     {},
            'children': [
                            <xsl:apply-templates select="epic"/>
                        ]
                   };
    </xsl:template>
    
    <xsl:template match="epic">
                         {   
                            'id':    'epic-<xsl:value-of select="@id"/>',
                            'name':  "<xsl:value-of select="translate(@title, '&quot;', '')"/>",
                            'data': {
                                        '$area': <xsl:value-of select="sum(child::story/@points)"/> * 10,
                                        <xsl:variable name="num_passing"><xsl:value-of select="count(story/scenario[@testStatus='pass'])"/></xsl:variable>
                                        <xsl:variable name="num_pending"><xsl:value-of select="count(story/scenario[@testStatus='pending'])"/></xsl:variable>
                                        <xsl:variable name="total_scenarios"><xsl:value-of select="count(story/scenario)"/></xsl:variable>
                                        '$color': custom_color_for(<xsl:number value="$num_passing"/>, <xsl:number value="$num_pending"/>, <xsl:number value="$total_scenarios"/>)
                                        
                                    },
                            'children': [
                                            <xsl:apply-templates select="story"/>
                                        ]
                         },
    </xsl:template>
    
    <xsl:template match="story">
                                        {
                                            'id': 'story-<xsl:value-of select="@id"/>',
                                            'name': '<xsl:value-of select="@id"/>',
                                            'data': {
                                                      'title': "<xsl:value-of select="translate(@title, '&quot;', '')"/>",
                                                      '$area': 
                                                            <xsl:choose>
                                                                <xsl:when test="@points=''">10</xsl:when>
                                                                <xsl:when test="not(@points)">10</xsl:when>
                                                                <xsl:otherwise><xsl:value-of select="@points"/> * 10</xsl:otherwise>
                                                            </xsl:choose>,
                                                            <xsl:variable name="num_passing"><xsl:value-of select="count(scenario[@testStatus='pass'])"/></xsl:variable>
                                                            <xsl:variable name="num_pending"><xsl:value-of select="count(scenario[@testStatus='pending'])"/></xsl:variable>
                                                            <xsl:variable name="total_scenarios"><xsl:value-of select="count(scenario)"/></xsl:variable>
                                                      '$color': custom_color_for(<xsl:number value="$num_passing"/>, <xsl:number value="$num_pending"/>, <xsl:number value="$total_scenarios"/>)
                                                    },
                                            'children': [
                                                            <xsl:apply-templates select="scenario"/>
                                                        ]
                                         },
    </xsl:template>
    
    <xsl:template match="scenario">
                                                          {
                                                            'id':   'scenario-<xsl:value-of select="@name"/>',
                                                            'name': '',
                                                            'data': {
                                                                      'title': '<xsl:value-of select="@name"/>',
                                                                      '$color': 
                                                                                <xsl:choose>
                                                                                    <xsl:when test="@testStatus='pass'">
                                                                                        '#0a0'
                                                                                    </xsl:when>
                                                                                    <xsl:when test="@testStatus='pending'">
                                                                                        '#aa0'
                                                                                    </xsl:when>
                                                                                    <xsl:otherwise>
                                                                                        '#a00'
                                                                                    </xsl:otherwise>
                                                                                </xsl:choose>,
                                                                      '$area': (
                                                                        <xsl:choose>
                                                                            <xsl:when test="../@points=''">1</xsl:when>
                                                                            <xsl:when test="not(../@points)">1</xsl:when>
                                                                            <xsl:otherwise><xsl:value-of select="../@points"/></xsl:otherwise>
                                                                        </xsl:choose>
                                                                            / <xsl:value-of select="count(../scenario)"/>) * 10,
                                                                    },
                                                            'children': [],
                                                          },
    </xsl:template>
</xsl:stylesheet>