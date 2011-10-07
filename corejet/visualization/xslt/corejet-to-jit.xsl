<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
<xsl:output method="text" omit-xml-declaration="yes"/>
<xsl:template match="//requirementscatalogue">
// corejet-output.js, generated from Corejet Requirements Catalogue

var custom_color_for = function(num_passing, num_pending, total) {
  var num_failing, red, green;

  if (total === 0) {
    red = green = 0;
  } else {
    num_failing = total - (num_passing + num_pending);
    red = green = 170;  // #aa0
    if (num_passing > num_failing) {
      red = 170 - 170 * ((num_passing - num_failing) / total);
    } else if (num_failing > num_passing) {
      green = 170 - 170 * ((num_failing - num_passing) / total);
    }
  }

  return 'rgb(' + Math.floor(red) + ',' + Math.floor(green) + ',0)';
};

var metadata = {
  'project':  "<xsl:value-of select="@project"/>",
  'testTime': "<xsl:value-of select="@testTime"/>"
};

var json = {
  'id':       'root',
  'name':     "<xsl:value-of select="@project"/>",
  'data':     {},
  'children': [<xsl:apply-templates select="epic"/>
  ]
};
</xsl:template>
<xsl:template match="epic">
  <xsl:variable name="num_passing" select="count(story/scenario[@testStatus='pass'])"/>
  <xsl:variable name="num_pending" select="count(story/scenario[@testStatus='pending'])"/>
  <xsl:variable name="total_scenarios" select="count(story/scenario)"/>
    {
      'id':   "epic-<xsl:value-of select="@id"/>",
      'name': "<xsl:value-of select="@title"/>",
      'data': {
        '$area':  <xsl:value-of select="sum(child::story/@points)"/> * 10,
        '$color': custom_color_for(<xsl:number value="$num_passing"/>, <xsl:number value="$num_pending"/>, <xsl:number value="$total_scenarios"/>)
      },
      'children': [<xsl:apply-templates select="story"/>
      ]
    }<xsl:choose><xsl:when test="following-sibling::epic"><xsl:text>,</xsl:text></xsl:when></xsl:choose>
</xsl:template>
<xsl:template match="story">
  <xsl:variable name="num_passing" select="count(scenario[@testStatus='pass'])"/>
  <xsl:variable name="num_pending" select="count(scenario[@testStatus='pending'])"/>
  <xsl:variable name="total_scenarios" select="count(scenario)"/>
        {
          'id':   "story-<xsl:value-of select="@id"/>",
          'name': "<xsl:value-of select="@id"/>",
          'data': {
            'title':  "<xsl:value-of select="@title"/>",
            '$area':  <xsl:call-template name="area-for-story"/>,
            '$color': custom_color_for(<xsl:number value="$num_passing"/>, <xsl:number value="$num_pending"/>, <xsl:number value="$total_scenarios"/>)
          },
          'children': [<xsl:apply-templates select="scenario"/>
          ]
        }<xsl:choose><xsl:when test="following-sibling::story"><xsl:text>,</xsl:text></xsl:when></xsl:choose>
</xsl:template>
<xsl:template match="scenario">
            {
              'id':   "story-<xsl:value-of select="parent::node()/@id"/>-scenario-<xsl:value-of select="@name"/>",
              'name': "",
              'data': {
                'title':  "<xsl:value-of select="@name"/>",
                '$area':  <xsl:call-template name="area-for-scenario"/>,
                '$color': <xsl:call-template name="status-color"/>
              },
              'children': []
            }<xsl:choose><xsl:when test="following-sibling::scenario"><xsl:text>,</xsl:text></xsl:when></xsl:choose>
</xsl:template>
<xsl:template name="area-for-story">
  <xsl:choose>
    <xsl:when test="@points=''">10</xsl:when>
    <xsl:when test="not(@points)">10</xsl:when>
    <xsl:otherwise><xsl:value-of select="@points"/> * 10</xsl:otherwise>
  </xsl:choose>
</xsl:template>
<xsl:template name="area-for-scenario">
  <xsl:text>(</xsl:text>
  <xsl:choose>
    <xsl:when test="../@points=''">1</xsl:when>
    <xsl:when test="not(../@points)">1</xsl:when>
    <xsl:otherwise><xsl:value-of select="../@points"/></xsl:otherwise>
  </xsl:choose>
  <xsl:text> / </xsl:text>
  <xsl:value-of select="count(../scenario)"/>
  <xsl:text>) * 10</xsl:text>
</xsl:template>
<xsl:template name="status-color">
  <xsl:choose>
    <xsl:when test="@testStatus='pass'">'#0a0'</xsl:when>
    <xsl:when test="@testStatus='pending'">'#aa0'</xsl:when>
    <xsl:otherwise>'#a00'</xsl:otherwise>
  </xsl:choose>
</xsl:template>
</xsl:stylesheet>
