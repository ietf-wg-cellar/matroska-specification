<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns:str="http://exslt.org/strings" xmlns:ebml="urn:ietf:rfc:8794" >
  <xsl:output encoding="UTF-8" method="text" version="1.0" indent="yes"/>
  <xsl:variable name="smallcase_link" select="'abcdefghijklmnopqrstuvwxyz-'"/>
  <xsl:variable name="uppercase_link" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZ '"/>
  <xsl:template match="matroska_tagging_registry">
    <xsl:text>Tag Name | Tag Type            | Reference&#xa;</xsl:text>
    <xsl:text>----------:|:------------------------|:-------------------------------------------&#xa;</xsl:text>
    <xsl:apply-templates select="//tags/tag">
      <!-- <xsl:sort select="@id" order="ascending" /> -->
    </xsl:apply-templates>
    <xsl:text>Table: Names and Types for Matroska Tags assigned by this document&#xa;&#xa;</xsl:text>
  </xsl:template>
  <xsl:template match="tag">
    <xsl:value-of select="@name"/>
    <xsl:text> | </xsl:text>
    <xsl:value-of select="@type"/>
    <xsl:text> | Described in this (#</xsl:text><xsl:value-of select="translate(@class, $uppercase_link, $smallcase_link)"/><xsl:text>)</xsl:text>
    <xsl:text>&#xa;</xsl:text>
  </xsl:template>
</xsl:stylesheet>
