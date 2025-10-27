<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns:str="http://exslt.org/strings" xmlns:ebml="urn:ietf:rfc:8794" >
  <xsl:output encoding="UTF-8" method="text" version="1.0" indent="yes"/>
  <xsl:variable name="smallcase" select="'abcdefghijklmnopqrstuvwxyz'"/>
  <xsl:variable name="uppercase" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZ'"/>
  <xsl:template match="ebml:EBMLSchema">
    <xsl:text>Element ID | Element Name            | Reference&#xa;</xsl:text>
    <xsl:text>----------:|:------------------------|:-------------------------------------------&#xa;</xsl:text>
    <xsl:apply-templates select="//ebml:element[contains(@path,'\Segment') and (@minver=5) and string-length(@id)=4]">
      <xsl:sort select="@id" order="ascending" />
    </xsl:apply-templates>
    <xsl:apply-templates select="//ebml:element[contains(@path,'\Segment') and (@minver=5) and string-length(@id)=6]">
      <xsl:sort select="@id" order="ascending" />
    </xsl:apply-templates>
    <xsl:apply-templates select="//ebml:element[contains(@path,'\Segment') and (@minver=5) and string-length(@id)=8]">
      <xsl:sort select="@id" order="ascending" />
    </xsl:apply-templates>
    <xsl:apply-templates select="//ebml:element[contains(@path,'\Segment') and (@minver=5) and string-length(@id)=10]">
      <xsl:sort select="@id" order="ascending" />
    </xsl:apply-templates>
    <xsl:text>Table: Additional "Matroska Element IDs" Registry Values{#iana-table}&#xa;&#xa;</xsl:text>
  </xsl:template>
  <xsl:template match="ebml:element">
    <xsl:value-of select="@id"/>
    <xsl:text> | </xsl:text>
    <xsl:value-of select="@name"/>
    <xsl:text> | Described in (#</xsl:text>

    <xsl:value-of select="translate(@name, $uppercase, $smallcase)"/>

    <xsl:text>-element)</xsl:text>
    <xsl:text>&#xa;</xsl:text>
  </xsl:template>
</xsl:stylesheet>
