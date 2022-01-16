<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns:ebml="urn:ietf:rfc:8794" xmlns="http://www.iana.org/assignments">
  <xsl:output encoding="UTF-8" version="1.0" indent="yes"/>
  <xsl:variable name="smallcase" select="'abcdefghijklmnopqrstuvwxyz'"/>
  <xsl:variable name="uppercase" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZ'"/>

  <xsl:template match="ebml:EBMLSchema">
    <registry id="matroska">
      <title>Matroska</title>
      <created>@BUILD_DATE@</created>

      <!-- Element IDs -->
      <registry id="matroska-element-ids">
        <title>Matroska Element IDs</title>
        <xref type="rfc" data="rfc8794"/>
        <xsl:apply-templates select="//ebml:element[contains(@path,'\Segment') and string-length(@id)=4]">
          <xsl:sort select="@id"/>
        </xsl:apply-templates>
        <xsl:apply-templates select="//ebml:element[contains(@path,'\Segment') and string-length(@id)=6]">
          <xsl:sort select="@id"/>
        </xsl:apply-templates>
        <xsl:apply-templates select="//ebml:element[contains(@path,'\Segment') and string-length(@id)=8]">
          <xsl:sort select="@id"/>
        </xsl:apply-templates>
        <xsl:apply-templates select="//ebml:element[contains(@path,'\Segment') and string-length(@id)=10]">
          <xsl:sort select="@id"/>
        </xsl:apply-templates>
      </registry>

    </registry>
  </xsl:template>
  <xsl:template match="ebml:element">
    <record date="@BUILD_DATE@">
      <value><xsl:value-of select="@id"/></value>
      <description><xsl:value-of select="@name"/></description>
      <xref type="draft" data="draft-ietf-cellar-matroska-09">Matroska Media Container Format, (#<xsl:choose>
          <xsl:when test="maxver='0'">
            <xsl:value-of select="translate(@name, $uppercase, $smallcase)"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="translate(@name, $uppercase, $smallcase)"/>
          </xsl:otherwise>
        </xsl:choose>)</xref>
    </record>
  </xsl:template>
</xsl:stylesheet>
