<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns:ebml="urn:ietf:rfc:8794" xmlns="http://www.iana.org/assignments">
  <xsl:output encoding="UTF-8" method="text" version="1.0" indent="yes"/>

  <xsl:template match="ebml:EBMLSchema">
    <xsl:text>Element ID,Element Name,Change Controller,Reference&#xa;</xsl:text>
    <xsl:apply-templates select="//ebml:element[contains(@path,'\Segment') and string-length(@id)=4]">
        <xsl:sort select="@id"/>
    </xsl:apply-templates>
    <xsl:text>0xFF,Reserved,IETF,[RFC-ietf-cellar-matroska-21]&#xa;</xsl:text>
    <xsl:text>0x0100-0x407E,Not valid for use as an Element ID,,[RFC-ietf-cellar-matroska-21]&#xa;</xsl:text>
    <xsl:apply-templates select="//ebml:element[contains(@path,'\Segment') and string-length(@id)=6]">
        <xsl:sort select="@id"/>
    </xsl:apply-templates>
    <xsl:text>0x7FFF,Reserved,IETF,[RFC-ietf-cellar-matroska-21]&#xa;</xsl:text>
    <xsl:text>0x010000-0x203FFE,Not valid for use as an Element ID,,[RFC-ietf-cellar-matroska-21]&#xa;</xsl:text>
    <xsl:apply-templates select="//ebml:element[contains(@path,'\Segment') and string-length(@id)=8]">
        <xsl:sort select="@id"/>
    </xsl:apply-templates>
    <xsl:text>0x3FFFFF,Reserved,IETF,[RFC-ietf-cellar-matroska-21]&#xa;</xsl:text>
    <xsl:text>0x01000000-0x101FFFFE,Not valid for use as an Element ID,,[RFC-ietf-cellar-matroska-21]&#xa;</xsl:text>
    <xsl:apply-templates select="//ebml:element[contains(@path,'\Segment') and string-length(@id)=10]">
        <xsl:sort select="@id"/>
    </xsl:apply-templates>
    <xsl:text>0x1FFFFFFF,Reserved,IETF,[RFC-ietf-cellar-matroska-21]&#xa;</xsl:text>
  </xsl:template>

  <xsl:template match="ebml:element">
    <xsl:if test="not(@minver) or @minver &lt;= 4">
      <xsl:value-of select="@id"/><xsl:text>,</xsl:text>
      <xsl:value-of select="@name"/><xsl:text>,IETF,"</xsl:text>
      <xsl:choose>
        <xsl:when test="@maxver='0'">
          <xsl:text>Reclaimed ([RFC-ietf-cellar-matroska-21, Section 28.x])</xsl:text>
        </xsl:when>
        <xsl:otherwise>
          <xsl:text>[RFC-ietf-cellar-matroska-21, Section 5.1.x.x]</xsl:text>
        </xsl:otherwise>
      </xsl:choose>
      <xsl:text>"&#xa;</xsl:text>
    </xsl:if>
  </xsl:template>

</xsl:stylesheet>
