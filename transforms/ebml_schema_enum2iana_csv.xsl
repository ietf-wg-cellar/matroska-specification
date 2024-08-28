<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns:ebml="urn:ietf:rfc:8794" xmlns="http://www.iana.org/assignments">
  <xsl:param name="ebmlpath" />
  <xsl:output encoding="UTF-8" method="text"/>

  <xsl:variable name="smallcase" select="'abcdefghijklmnopqrstuvwxyz'"/>
  <xsl:variable name="uppercase" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZ'"/>
  <xsl:variable name="liaisonin"  select="'abcdefghijklmnopqrstuvwxyz'"/>
  <xsl:variable name="liaisonout" select="'n   n   n     n     n   n '"/>

  <xsl:template match="ebml:EBMLSchema">
    <xsl:apply-templates select="//ebml:element[@path=$ebmlpath]"/>
  </xsl:template>

  <xsl:template match="ebml:element">
    <xsl:if test="ebml:extension[@type='enum source']">
        <xsl:value-of select="ebml:extension[@type='enum source']/@registry"/>
        <xsl:text>,Description,Change Controller,Reference&#xa;</xsl:text>
        <xsl:if test="@range='not 0'">
            <xsl:choose>
                <xsl:when test="ebml:extension[@type='enum source']/@bitfield"><xsl:text>0x0</xsl:text></xsl:when>
                <xsl:otherwise><xsl:text>0</xsl:text></xsl:otherwise>
            </xsl:choose>
            <xsl:text>,Not valid for use as </xsl:text>
            <xsl:call-template name="NameWithLiaison">
                <xsl:with-param name="name" select="ebml:extension[@type='enum source']/@registry" />
            </xsl:call-template>
            <xsl:text>,,[RFC-ietf-cellar-matroska-21]&#xa;</xsl:text>
        </xsl:if>

        <xsl:for-each select="ebml:restriction/ebml:enum">
            <!-- <xsl:sort select="string-length(@value)"/>
            <xsl:sort select="@value"/> -->

            <!-- holes in the numbers -->
            <xsl:if test="not(../../ebml:extension[@type='enum source']/@bitfield)">
                    <!-- <xsl:value-of select="position()"/><xsl:text>&#xa;</xsl:text> -->
                <xsl:if test="(position() &gt; 0)">
                    <xsl:variable name="prev_value">
                        <xsl:choose>
                            <xsl:when test="position() &gt; 1">
                                <xsl:variable name="prev" select="position() - 1"/>
                                <xsl:value-of select="../ebml:enum[$prev]/@value"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <!-- first element, unsigned integers start at 0 -->
                                <xsl:value-of select="-1"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:variable>
                    <!-- <xsl:value-of select="$prev_value"/><xsl:text>&#xa;</xsl:text> -->
                    <!-- <xsl:if test="not($prev_value + 1 = @value) and (not($prev_value + 1 = 0) or not(../../@range='not 0'))"> -->
                    <xsl:if test="not($prev_value + 1 = @value) and (not(@value = 1) or not(../../@range='not 0'))">
                        <xsl:value-of select="$prev_value + 1"/>
                        <xsl:text>-</xsl:text>
                        <xsl:value-of select="@value - 1"/>
                        <xsl:text>,Unassigned,,&#xa;</xsl:text>
                    </xsl:if>
                </xsl:if>
            </xsl:if>

            <xsl:value-of select="@value"/>
            <xsl:text>,</xsl:text>
            <xsl:value-of select="@label"/>
            <xsl:text>,IETF,[RFC-ietf-cellar-matroska-21]&#xa;</xsl:text>
            <xsl:if test="position() = last()">
                <xsl:choose>
                    <xsl:when test="../../ebml:extension[@type='enum source']/@bitfield">
                        <xsl:text>0x</xsl:text><xsl:value-of select="substring(@value,3) * 2"/><xsl:text>-0x8000000000000000,Unassigned,,&#xa;</xsl:text>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="@value + 1"/><xsl:text>-18446744073709551615,Unassigned,,&#xa;</xsl:text>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:if>
        </xsl:for-each>
    </xsl:if>
  </xsl:template>

  <xsl:template name="NameWithLiaison">
    <xsl:param name="name"/>
    <xsl:text>a</xsl:text>
    <xsl:if test="translate(translate(substring($name,1,1), $uppercase, $smallcase), $liaisonin, $liaisonout)='n'">
      <xsl:text>n</xsl:text>
    </xsl:if>
    <xsl:text> </xsl:text>
    <xsl:value-of select="$name"/>
  </xsl:template>

</xsl:stylesheet>
