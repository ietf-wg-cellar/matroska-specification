<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns:ebml="urn:ietf:rfc:8794" xmlns="http://www.iana.org/assignments">
  <xsl:output encoding="UTF-8" version="1.0" indent="yes"/>
  <xsl:strip-space elements="ref"/>
  <!-- <xsl:variable name="smallcase" select="'abcdefghijklmnopqrstuvwxyz'"/> -->
  <!-- <xsl:variable name="uppercase" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZ'"/> -->

  <xsl:template match="ebml:EBMLSchema">
    <?xml-stylesheet type="text/xsl" href="matroska.xsl"?>
    <registry id="matroska">
      <title>Matroska</title>
      <created>2023-10-27</created>
      <updated>@BUILD_DATE@</updated>

      <!-- Element IDs -->
      <registry id="matroska-element-ids">
        <title>Matroska Element IDs</title>
        <xref type="draft" data="RFC-ietf-cellar-matroska-21"/>
        <range>
          <value>0x80-0xFE</value>
          <registration_rule>RFC Required</registration_rule>
        </range>
        <range>
          <value>0x407F-0x7FFE</value>
          <registration_rule>Specification Required</registration_rule>
        </range>
        <range>
          <value>0x203FFF-0x3FFFFE</value>
          <registration_rule>First Come First Served</registration_rule>
        </range>
        <range>
          <value>0x101FFFFF-0x1FFFFFFE</value>
          <registration_rule>First Come First Served</registration_rule>
        </range>
        <expert>Unassigned</expert>
        <xsl:apply-templates select="//ebml:element[contains(@path,'\Segment') and string-length(@id)=4]">
          <xsl:sort select="@id"/>
        </xsl:apply-templates>
        <record date="2024-06-07">
          <value>0xFF</value>
          <description>Reserved</description>
          <controller>IETF</controller>
          <ref><xref type="draft" data="RFC-ietf-cellar-matroska-21"/></ref>
        </record>
        <record date="2024-06-18">
          <value>0x0100-0x407E</value>
          <description>Not valid for use as an Element ID</description>
          <controller/>
          <ref><xref type="draft" data="RFC-ietf-cellar-matroska-21"/></ref>
        </record>
        <xsl:apply-templates select="//ebml:element[contains(@path,'\Segment') and string-length(@id)=6]">
          <xsl:sort select="@id"/>
        </xsl:apply-templates>
        <record date="2024-06-07">
          <value>0x7FFF</value>
          <description>Reserved</description>
          <controller>IETF</controller>
          <ref><xref type="draft" data="RFC-ietf-cellar-matroska-21"/></ref>
        </record>
        <record date="2024-06-18">
          <value>0x010000-0x203FFE</value>
          <description>Not valid for use as an Element ID</description>
          <controller/>
          <ref><xref type="draft" data="RFC-ietf-cellar-matroska-21"/></ref>
        </record>
        <xsl:apply-templates select="//ebml:element[contains(@path,'\Segment') and string-length(@id)=8]">
          <xsl:sort select="@id"/>
        </xsl:apply-templates>
        <record date="2024-06-07">
          <value>0x3FFFFF</value>
          <description>Reserved</description>
          <controller>IETF</controller>
          <ref><xref type="draft" data="RFC-ietf-cellar-matroska-21"/></ref>
        </record>
        <record date="2024-06-18">
          <value>0x01000000-0x101FFFFE</value>
          <description>Not valid for use as an Element ID</description>
          <controller/>
          <ref><xref type="draft" data="RFC-ietf-cellar-matroska-21"/></ref>
        </record>
        <xsl:apply-templates select="//ebml:element[contains(@path,'\Segment') and string-length(@id)=10]">
          <xsl:sort select="@id"/>
        </xsl:apply-templates>
        <record date="2024-06-07">
          <value>0x1FFFFFFF</value>
          <description>Reserved</description>
          <controller>IETF</controller>
          <ref><xref type="draft" data="RFC-ietf-cellar-matroska-21"/></ref>
        </record>
      </registry>

      <!-- Chapter Codec IDs -->
      <registry id="matroska-chapter-codec-ids">
        <title>Matroska Chapter Codec IDs</title>
        <xref type="draft" data="RFC-ietf-cellar-matroska-21"/>
        <registration_rule>First Come First Served</registration_rule>
        <record date="2023-10-27">
          <value>0</value>
          <description>Reserved</description>
          <controller>IETF</controller>
          <xref type="draft" data="RFC-ietf-cellar-matroska-21">RFC-ietf-cellar-matroska-21, Section 5.1.x.x</xref>
        </record>
        <record date="2023-10-27">
          <value>1</value>
          <description>Reserved</description>
          <controller>IETF</controller>
          <xref type="draft" data="RFC-ietf-cellar-matroska-21">RFC-ietf-cellar-matroska-21, Section 5.1.x.x</xref>
        </record>
        <record>
          <value>2-4294967295</value>
          <description>Unassigned</description>
          <controller/>
        </record>
      </registry>

    <people/>
    </registry>

  </xsl:template>

  <xsl:template match="ebml:element">
    <xsl:if test="not(@minver) or @minver &lt;= 4">
    <record date="2023-10-27">
      <value><xsl:value-of select="@id"/></value>
      <description><xsl:value-of select="@name"/></description>
      <controller>IETF</controller>
      <ref>
      <xsl:choose>
        <xsl:when test="@maxver='0'">
          Reclaimed (<xref type="draft" data="RFC-ietf-cellar-matroska-21">RFC-ietf-cellar-matroska-21, Section 28.x</xref>)
        </xsl:when>
        <xsl:otherwise>
          <xref type="draft" data="RFC-ietf-cellar-matroska-21">RFC-ietf-cellar-matroska-21, Section 5.1.x.x</xref>
        </xsl:otherwise>
      </xsl:choose>
      </ref>
      <!-- , (#<xsl:choose>
          <xsl:when test="maxver='0'">
            <xsl:value-of select="translate(@name, $uppercase, $smallcase)"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="translate(@name, $uppercase, $smallcase)"/>
          </xsl:otherwise>
        </xsl:choose>)</xref> -->
    </record>
    </xsl:if>
  </xsl:template>

</xsl:stylesheet>
