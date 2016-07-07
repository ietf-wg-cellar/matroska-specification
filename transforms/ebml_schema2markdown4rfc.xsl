<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
  <xsl:output encoding="UTF-8" method="text" version="1.0" indent="yes"/>
  <xsl:variable name="smallcase" select="'abcdefghijklmnopqrstuvwxyz'" />
  <xsl:variable name="uppercase" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZ'" />
  <xsl:template match="EBMLSchema">
    <xsl:apply-templates select="//element"/>
  </xsl:template>
  <xsl:template match="element">
    <xsl:text># </xsl:text>
    <xsl:value-of select="@name"/>
    <xsl:text>&#xa;</xsl:text>
    <xsl:text>&#xa;</xsl:text>
    <xsl:call-template name="table-header">
        <xsl:with-param name="label">Element Name      </xsl:with-param>
        <xsl:with-param name="value" select="@name"/>
    </xsl:call-template>
    <xsl:call-template name="table-row">
      <xsl:with-param name="label">Element ID</xsl:with-param>
      <xsl:with-param name="value" select="@id"/>
    </xsl:call-template>
    <xsl:call-template name="table-row">
      <xsl:with-param name="label">Element Type</xsl:with-param>
      <xsl:with-param name="value" select="@type"/>
    </xsl:call-template>
    <xsl:call-template name="table-row">
      <xsl:with-param name="label">Version</xsl:with-param>
      <xsl:with-param name="value">
        <xsl:choose>
          <xsl:when test="@minver">
            <xsl:value-of select="@minver"/>
          </xsl:when>
          <xsl:otherwise>1</xsl:otherwise>
        </xsl:choose>
        <xsl:text>-</xsl:text>
        <xsl:choose>
          <xsl:when test="@maxver">
            <xsl:value-of select="@maxver"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="//EBMLSchema/@version"/>
          </xsl:otherwise>
        </xsl:choose>
        <xsl:if test="//EBMLSchema/@version > @maxver">
          <xsl:text> DEPRECATED</xsl:text>
        </xsl:if>
      </xsl:with-param>
    </xsl:call-template>
    <xsl:call-template name="table-row">
      <xsl:with-param name="label">Parent Element</xsl:with-param>
      <xsl:with-param name="value">
        <xsl:choose>
          <xsl:when test="parent::element/@name">
            <xsl:value-of select="parent::element/@name"/>
          </xsl:when>
          <xsl:otherwise>None</xsl:otherwise>
        </xsl:choose>
      </xsl:with-param>
    </xsl:call-template>
    <xsl:call-template name="table-row">
      <xsl:with-param name="label">Child Elements</xsl:with-param>
      <xsl:with-param name="value">
        <xsl:choose>
          <xsl:when test="element">
            <xsl:for-each select="element">
              <xsl:value-of select="@name"/>
              <xsl:text> </xsl:text>
            </xsl:for-each>
          </xsl:when>
          <xsl:otherwise>None</xsl:otherwise>
        </xsl:choose>
      </xsl:with-param>
    </xsl:call-template>
    <xsl:call-template name="table-row">
      <xsl:with-param name="label">Element Context</xsl:with-param>
      <xsl:with-param name="value">
        <xsl:choose>
          <xsl:when test="ancestor::element">
            <xsl:for-each select="ancestor::element">
              <xsl:text>/</xsl:text>
              <xsl:value-of select="@name"/>
            </xsl:for-each>
            <xsl:text>/</xsl:text>
            <xsl:value-of select="@name"/>
          </xsl:when>
          <xsl:otherwise>None</xsl:otherwise>
        </xsl:choose>
      </xsl:with-param>
    </xsl:call-template>
    <xsl:call-template name="table-row">
      <xsl:with-param name="label">Mandatory</xsl:with-param>
      <xsl:with-param name="value">
        <xsl:choose>
          <xsl:when test="not(@minOccurs)">Not Mandatory</xsl:when>
          <xsl:when test="@minOccurs = 0">Not Mandatory</xsl:when>
          <xsl:when test="@minOccurs = 1">Mandatory</xsl:when>
          <xsl:otherwise>
            <xsl:text>A minimum of </xsl:text>
            <xsl:value-of select="@minOccurs"/>
            <xsl:text> must occur.</xsl:text>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:with-param>
    </xsl:call-template>
    <xsl:call-template name="table-row">
      <xsl:with-param name="label">Repeatability</xsl:with-param>
      <xsl:with-param name="value">
        <xsl:choose>
          <xsl:when test="not(@maxOccurs)">Not Repeatable</xsl:when>
          <xsl:when test="@maxOccurs = 'unbounded'">Repeatable</xsl:when>
          <xsl:when test="@maxOccurs = 'identical'">Repeatable, but must only repeat as identical copies (for redundancy)</xsl:when>
          <xsl:when test="@maxOccurs = '1'">Not Repeatable</xsl:when>
          <xsl:otherwise>
            <xsl:text>A maximum of </xsl:text>
            <xsl:value-of select="@maxOccurs"/>
            <xsl:text> may occur.</xsl:text>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:with-param>
    </xsl:call-template>
    <xsl:call-template name="table-row">
      <xsl:with-param name="label">Recursive</xsl:with-param>
      <xsl:with-param name="value">
        <xsl:choose>
          <xsl:when test="@recursive = 1">Recursive</xsl:when>
          <xsl:otherwise>Not Recursive</xsl:otherwise>
        </xsl:choose>
      </xsl:with-param>
    </xsl:call-template>
    <xsl:call-template name="table-row">
      <xsl:with-param name="label">Documentation</xsl:with-param>
      <xsl:with-param name="value" select="documentation"/>
    </xsl:call-template>
    <xsl:text>&#xa;</xsl:text>
  </xsl:template>
  <xsl:template name="table-header">
    <xsl:param name="label"/>
    <xsl:param name="value"/>
    <xsl:value-of select="$label"/>
    <xsl:text>|</xsl:text>
    <xsl:value-of select="$value"/>
    <xsl:text>&#xa;</xsl:text>
    <xsl:text>:---|:----</xsl:text>
    <xsl:text>&#xa;</xsl:text>
  </xsl:template>
  <xsl:template name="table-row">
    <xsl:param name="label"/>
    <xsl:param name="value"/>
    <xsl:value-of select="$label"/>
    <xsl:text>|</xsl:text>
    <xsl:value-of select="$value"/>
    <xsl:text>&#xa;</xsl:text>
  </xsl:template>
</xsl:stylesheet>