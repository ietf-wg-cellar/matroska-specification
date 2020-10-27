<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
  <xsl:output encoding="UTF-8" method="text" version="1.0" indent="yes"/>
  <xsl:template match="*">
    <xsl:apply-templates/>
  </xsl:template>
  <xsl:template match="matroska_tagging_registry">
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template name="string-to-markdown">
    <xsl:param name="text" />
    <xsl:choose>
      <xsl:when test="contains($text, '_')">
        <xsl:value-of select="substring-before($text,'_')" />
        <xsl:value-of select="'\_'" />
        <xsl:call-template name="string-to-markdown">
          <xsl:with-param name="text" select="substring-after($text,'_')" />
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$text" />
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="class">
    <xsl:text>## </xsl:text>
    <xsl:value-of select="@name"/>
    <xsl:text>&#xa;&#xa;</xsl:text>
    <xsl:value-of select="description"/>
    <xsl:text>&#xa;&#xa;</xsl:text>
    <!-- markdown table header -->
    <xsl:text>Tag Name             | Type   | Description&#xa;</xsl:text>
    <xsl:text>:--------------------|:-------|:-----------&#xa;</xsl:text>
    <xsl:variable name="thisclass">
      <xsl:value-of select="@name"/>
    </xsl:variable>
    <xsl:for-each select="../../tags/tag[@class=$thisclass]">
      <!-- build markdown table with whitespace padding for alignment -->
      <xsl:variable name="name_md">
        <xsl:call-template name="string-to-markdown">
          <xsl:with-param name="text" select="@name" />
        </xsl:call-template>
      </xsl:variable>
      <xsl:variable name="titlewidth">22</xsl:variable>
      <xsl:variable name="typewidth">8</xsl:variable>
      <xsl:value-of select="$name_md"/>
      <xsl:value-of select="substring('                                          ',0,$titlewidth - string-length($name_md))"/>
      <xsl:text>| </xsl:text>
      <xsl:value-of select="@type"/>
      <xsl:value-of select="substring('                                          ',0,$typewidth - string-length(@type))"/>
      <xsl:text>| </xsl:text>
      <xsl:value-of select="translate(description,'&#xA;',' ')"/>
      <xsl:text>&#xa;</xsl:text>
    </xsl:for-each>
    <xsl:text>&#xa;</xsl:text>
  </xsl:template>
  <xsl:template match="text()"/>
</xsl:stylesheet>
