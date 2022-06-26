<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns:str="http://exslt.org/strings" xmlns:ebml="urn:ietf:rfc:8794" >
  <xsl:output encoding="UTF-8" method="text" version="1.0" indent="yes"/>
  <xsl:variable name="smallcase" select="'abcdefghijklmnopqrstuvwxyz'"/>
  <xsl:variable name="uppercase" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZ'"/>
  <xsl:template match="ebml:EBMLSchema">
    <xsl:apply-templates select="//ebml:element[contains(@path,'\Segment') and @maxver='0']"/>
  </xsl:template>
  <xsl:template match="ebml:element">
     <xsl:text>## </xsl:text>
    <xsl:value-of select="@name"/>
    <xsl:text> Element&#xa;&#xa;</xsl:text>
    <xsl:text>type / id:&#xa;: </xsl:text>
    <xsl:value-of select="@type"/>
    <xsl:text> / </xsl:text>
    <xsl:value-of select="@id"/>
    <xsl:text>&#xa;&#xa;</xsl:text>
    <xsl:if test="@path">
      <xsl:text>path:&#xa;: `</xsl:text>
      <xsl:value-of select="@path"/>
      <xsl:text>`&#xa;&#xa;</xsl:text>
    </xsl:if>
    <xsl:for-each select="ebml:documentation">
      <xsl:if test="@purpose='definition'">
        <xsl:text>documentation:&#xa;: </xsl:text>
        <xsl:value-of select="."/>
        <xsl:text>&#xa;&#xa;</xsl:text>
      </xsl:if>
    </xsl:for-each>
    <xsl:text>&#xa;</xsl:text>
  </xsl:template>
</xsl:stylesheet>
