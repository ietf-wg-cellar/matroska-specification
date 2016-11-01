<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
  <xsl:output encoding="UTF-8" method="text" version="1.0" indent="yes"/>
  <xsl:variable name="smallcase" select="'abcdefghijklmnopqrstuvwxyz'" />
  <xsl:variable name="uppercase" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZ'" />
  <xsl:template match="EBMLSchema">
    <xsl:apply-templates select="//element"/>
  </xsl:template>
  <xsl:template match="element">
    <xsl:text>### </xsl:text>
    <xsl:value-of select="@name"/>
    <xsl:text> Element&#xa;&#xa;</xsl:text>
    <xsl:if test="@name">
      <xsl:text>name: `</xsl:text>
      <xsl:value-of select="@name"/>
      <xsl:text>`&#xa;&#xa;</xsl:text>
    </xsl:if>
    <xsl:if test="@path">
      <xsl:text>path: `</xsl:text>
      <xsl:value-of select="@path"/>
      <xsl:text>`&#xa;&#xa;</xsl:text>
    </xsl:if>
    <xsl:if test="@id">
      <xsl:text>id: `</xsl:text>
      <xsl:value-of select="@id"/>
      <xsl:text>`&#xa;&#xa;</xsl:text>
    </xsl:if>
    <xsl:if test="@minOccurs">
      <xsl:text>minOccurs: `</xsl:text>
      <xsl:value-of select="@minOccurs"/>
      <xsl:text>`&#xa;&#xa;</xsl:text>
    </xsl:if>
    <xsl:if test="@maxOccurs">
      <xsl:text>maxOccurs: `</xsl:text>
      <xsl:value-of select="@maxOccurs"/>
      <xsl:text>`&#xa;&#xa;</xsl:text>
    </xsl:if>
    <xsl:if test="@range">
      <xsl:text>range: `</xsl:text>
      <xsl:value-of select="@range"/>
      <xsl:text>`&#xa;&#xa;</xsl:text>
    </xsl:if>
    <xsl:if test="@size">
      <xsl:text>size: `</xsl:text>
      <xsl:value-of select="@size"/>
      <xsl:text>`&#xa;&#xa;</xsl:text>
    </xsl:if>
    <xsl:if test="@default">
      <xsl:text>default: `</xsl:text>
      <xsl:value-of select="@default"/>
      <xsl:text>`&#xa;&#xa;</xsl:text>
    </xsl:if>
    <xsl:if test="@type">
      <xsl:text>type: `</xsl:text>
      <xsl:value-of select="@type"/>
      <xsl:text>`&#xa;&#xa;</xsl:text>
    </xsl:if>
    <xsl:if test="@unknownsizeallowed">
      <xsl:text>unknownsizeallowed: `</xsl:text>
      <xsl:value-of select="@unknownsizeallowed"/>
      <xsl:text>`&#xa;&#xa;</xsl:text>
    </xsl:if>
    <xsl:if test="@recursive">
      <xsl:text>recursive: `</xsl:text>
      <xsl:value-of select="@recursive"/>
      <xsl:text>`&#xa;&#xa;</xsl:text>
    </xsl:if>
    <xsl:if test="@minver">
      <xsl:text>minver: `</xsl:text>
      <xsl:value-of select="@minver"/>
      <xsl:text>`&#xa;&#xa;</xsl:text>
    </xsl:if>
    <xsl:if test="@maxver">
      <xsl:text>maxver: `</xsl:text>
      <xsl:value-of select="@maxver"/>
      <xsl:text>`&#xa;&#xa;</xsl:text>
    </xsl:if>
    <xsl:for-each select="documentation">
      <xsl:choose>
        <xsl:when test="@type">
          <xsl:value-of select="@type"/>
        </xsl:when>
        <xsl:otherwise>documentation</xsl:otherwise>
      </xsl:choose>
      <xsl:text>: </xsl:text>
      <xsl:value-of select="."/>
      <xsl:text>&#xa;&#xa;</xsl:text>
    </xsl:for-each>
    <xsl:text>&#xa;</xsl:text>
  </xsl:template>
</xsl:stylesheet>
