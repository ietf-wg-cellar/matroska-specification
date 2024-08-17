<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns:str="http://exslt.org/strings" xmlns:ebml="urn:ietf:rfc:8794" >
  <xsl:output encoding="UTF-8" method="text" version="1.0" indent="yes"/>
  <xsl:variable name="smallcase" select="'abcdefghijklmnopqrstuvwxyz'"/>
  <xsl:variable name="uppercase" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZ'"/>
  <xsl:template match="ebml:EBMLSchema">
    <xsl:text>Element ID | Element Name            | Reference&#xa;</xsl:text>
    <xsl:text>----------:|:------------------------|:-------------------------------------------&#xa;</xsl:text>
    <xsl:apply-templates select="//ebml:element[contains(@path,'\Segment') and (not(@minver) or @minver&lt;5) and string-length(@id)=4]">
      <xsl:sort select="@id" order="ascending" />
    </xsl:apply-templates>
    <xsl:call-template name="GenerateReserved">
      <xsl:with-param name="id" select="'0xFF'" />
    </xsl:call-template>
    <xsl:apply-templates select="//ebml:element[contains(@path,'\Segment') and (not(@minver) or @minver&lt;5) and string-length(@id)=6]">
      <xsl:sort select="@id" order="ascending" />
    </xsl:apply-templates>
    <xsl:call-template name="GenerateReserved">
      <xsl:with-param name="id" select="'0x7FFF'" />
    </xsl:call-template>
    <xsl:apply-templates select="//ebml:element[contains(@path,'\Segment') and (not(@minver) or @minver&lt;5) and string-length(@id)=8]">
      <xsl:sort select="@id" order="ascending" />
    </xsl:apply-templates>
    <xsl:call-template name="GenerateReserved">
      <xsl:with-param name="id" select="'0x3FFFFF'" />
    </xsl:call-template>
    <xsl:apply-templates select="//ebml:element[contains(@path,'\Segment') and (not(@minver) or @minver&lt;5) and string-length(@id)=10]">
      <xsl:sort select="@id" order="ascending" />
    </xsl:apply-templates>
    <xsl:call-template name="GenerateReserved">
      <xsl:with-param name="id" select="'0x1FFFFFFF'" />
    </xsl:call-template>
    <xsl:text>Table: Initial Contents of "Matroska Element IDs" Registry{#iana-table}&#xa;&#xa;</xsl:text>
  </xsl:template>
  <xsl:template match="ebml:element">
    <xsl:value-of select="@id"/>
    <xsl:text> | </xsl:text>
    <xsl:value-of select="@name"/>
    <xsl:choose>
      <xsl:when test="@maxver='0'">
        <xsl:text> | Reclaimed (RFC 9559, (#</xsl:text>

        <xsl:choose>
          <xsl:when test="@name='Range'">
            <xsl:text>color-range</xsl:text>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="translate(@name, $uppercase, $smallcase)"/>
          </xsl:otherwise>
        </xsl:choose>

        <xsl:text>-element))</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text> | RFC 9559, (#</xsl:text>

        <xsl:choose>
          <xsl:when test="@name='Range'">
            <xsl:text>color-range</xsl:text>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="translate(@name, $uppercase, $smallcase)"/>
          </xsl:otherwise>
        </xsl:choose>

        <xsl:text>-element)</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:text>&#xa;</xsl:text>
  </xsl:template>
  <xsl:template name="GenerateReserved">
    <xsl:param name="id"/>
    <xsl:value-of select="$id"/>
    <xsl:text> | Reserved | RFC 9559</xsl:text>
    <xsl:text>&#xa;</xsl:text>
  </xsl:template>
</xsl:stylesheet>
