<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns:str="http://exslt.org/strings" xmlns:ebml="urn:ietf:rfc:8794" >
  <xsl:output encoding="UTF-8" method="text" version="1.0" indent="yes"/>
  <xsl:variable name="smallcase" select="'abcdefghijklmnopqrstuvwxyz'"/>
  <xsl:variable name="uppercase" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZ'"/>
  <xsl:template match="ebml:EBMLSchema">
    <xsl:apply-templates select="//ebml:element[contains(@path,'\Segment') and not(@maxver='0') and (not(@minver) or @minver&lt;5)]"/>
  </xsl:template>
  <xsl:template match="ebml:element">
    <xsl:text>#</xsl:text>
    <xsl:value-of select="substring('#####',1,count(str:tokenize(@path,'\')))"/>
    <xsl:text> </xsl:text>
    <xsl:value-of select="@name"/>
    <xsl:text> Element&#xa;&#xa;</xsl:text>
    <xsl:choose>
      <xsl:when test="@default">
       <xsl:text>id / type / default:&#xa;: </xsl:text>
       <xsl:value-of select="@id"/>
       <xsl:text> / </xsl:text>
       <xsl:value-of select="@type"/>
       <xsl:text> / </xsl:text>
       <xsl:value-of select="@default"/>
       <xsl:text>&#xa;&#xa;</xsl:text>
      </xsl:when>
      <xsl:otherwise>
       <xsl:text>id / type:&#xa;: </xsl:text>
       <xsl:value-of select="@id"/>
       <xsl:text> / </xsl:text>
       <xsl:value-of select="@type"/>
       <xsl:text>&#xa;&#xa;</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:if test="@path">
      <xsl:text>path:&#xa;: `</xsl:text>
      <xsl:value-of select="@path"/>
      <xsl:text>`&#xa;&#xa;</xsl:text>
    </xsl:if>
    <xsl:if test="@minOccurs | ebml:implementation_note[@note_attribute='minOccurs']">
      <xsl:text>minOccurs</xsl:text>
      <xsl:if test="@maxOccurs">
        <xsl:text> - maxOccurs</xsl:text>
      </xsl:if>
      <xsl:text>:&#xa;: </xsl:text>
      <xsl:choose>
        <xsl:when test="ebml:implementation_note[@note_attribute='minOccurs']">
          <xsl:text>see implementation notes</xsl:text>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="@minOccurs"/>
        </xsl:otherwise>
      </xsl:choose>
      <xsl:if test="@maxOccurs">
        <xsl:text> - </xsl:text>
        <xsl:value-of select="@maxOccurs"/>
      </xsl:if>
      <xsl:text>&#xa;&#xa;</xsl:text>
    </xsl:if>
    <xsl:if test="@maxOccurs and not(@minOccurs | ebml:implementation_note[@note_attribute='minOccurs'])">
      <xsl:text>maxOccurs:&#xa;: </xsl:text>
      <xsl:value-of select="@maxOccurs"/>
      <xsl:text>&#xa;&#xa;</xsl:text>
    </xsl:if>
    <xsl:if test="@range">
      <xsl:text>range:&#xa;: </xsl:text>
      <xsl:value-of select="@range"/>
      <xsl:text>&#xa;&#xa;</xsl:text>
    </xsl:if>
    <xsl:if test="@length">
      <xsl:text>length:&#xa;: </xsl:text>
      <xsl:value-of select="@length"/>
      <xsl:text>&#xa;&#xa;</xsl:text>
    </xsl:if>
    <xsl:if test="@unknownsizeallowed=1">
      <xsl:text>unknownsizeallowed: True&#xa;&#xa;</xsl:text>
    </xsl:if>
    <xsl:if test="@recursive=1">
      <xsl:text>recursive: True&#xa;&#xa;</xsl:text>
    </xsl:if>
    <xsl:if test="@recurring=1">
      <xsl:text>recurring: True&#xa;&#xa;</xsl:text>
    </xsl:if>
    <xsl:for-each select="ebml:extension[@type='stream copy']">
      <xsl:text>stream copy: True ((#stream-copy))&#xa;&#xa;</xsl:text>
    </xsl:for-each>
    <xsl:if test="@minver">
      <xsl:text>minver:&#xa;: </xsl:text>
      <xsl:value-of select="@minver"/>
      <xsl:text>&#xa;&#xa;</xsl:text>
    </xsl:if>
    <xsl:if test="@maxver">
      <xsl:text>maxver:&#xa;: </xsl:text>
      <xsl:value-of select="@maxver"/>
      <xsl:text>&#xa;&#xa;</xsl:text>
    </xsl:if>

    <xsl:for-each select="ebml:documentation[@purpose='definition']">
      <xsl:text>definition:&#xa;: </xsl:text>
      <xsl:value-of select="."/>
      <xsl:text>&#xa;&#xa;</xsl:text>
    </xsl:for-each>

    <xsl:for-each select="ebml:documentation[@purpose='rationale']">
      <xsl:text>rationale:&#xa;: </xsl:text>
      <xsl:value-of select="."/>
      <xsl:text>&#xa;&#xa;</xsl:text>
    </xsl:for-each>

    <xsl:for-each select="ebml:restriction">
      <xsl:choose>
        <xsl:when test="ebml:enum/ebml:documentation">
          <xsl:text>defined values:&#xa;&#xa;</xsl:text>
          <xsl:text>|value|label|</xsl:text>
          <xsl:choose>
            <xsl:when test="../@name='TrackType'">
              <xsl:text>each frame contains</xsl:text>
            </xsl:when>
            <xsl:otherwise>
              <xsl:text>definition</xsl:text>
            </xsl:otherwise>
          </xsl:choose>
          <xsl:text>|&#xa;</xsl:text>
          <xsl:text>|:---|:---|:---|&#xa;</xsl:text>
          <xsl:for-each select="ebml:enum">
            <xsl:text>|`</xsl:text>
            <xsl:value-of select="@value"/>
            <xsl:text>` |</xsl:text>
            <xsl:value-of select="@label"/>
            <xsl:text> |</xsl:text>
            <xsl:value-of select="ebml:documentation[@purpose='definition']"/>
            <xsl:value-of select="ebml:documentation[@purpose='usage notes']"/>
            <xsl:text> |&#xa;</xsl:text>
          </xsl:for-each>
        </xsl:when>

        <xsl:otherwise>
          <xsl:text>restrictions:&#xa;&#xa;</xsl:text>
          <xsl:text>|value|label|&#xa;</xsl:text>
          <xsl:text>|:---|:---|&#xa;</xsl:text>
          <xsl:for-each select="ebml:enum">
            <xsl:text>|`</xsl:text>
            <xsl:value-of select="@value"/>
            <xsl:text>` |</xsl:text>
            <xsl:value-of select="@label"/>
            <xsl:text> |&#xa;</xsl:text>
          </xsl:for-each>
        </xsl:otherwise>
      </xsl:choose>
      <xsl:text>Table: </xsl:text><xsl:value-of select="../@name"/><xsl:text> values{#</xsl:text><xsl:value-of select="../@name"/><xsl:text>Values}&#xa;</xsl:text>
      <xsl:text>&#xa;&#xa;</xsl:text>
    </xsl:for-each>

    <xsl:for-each select="ebml:documentation[@purpose='usage notes']">
      <xsl:text>usage notes:&#xa;: </xsl:text>
      <xsl:value-of select="."/>
      <xsl:text>&#xa;&#xa;</xsl:text>
    </xsl:for-each>

    <xsl:if test="ebml:implementation_note">
      <xsl:text>notes:&#xa;&#xa;</xsl:text>
      <xsl:text>|attribute|note|&#xa;</xsl:text>
      <xsl:text>|:---|:---|&#xa;</xsl:text>
      <xsl:for-each select="ebml:implementation_note">
        <xsl:text>| </xsl:text>
        <xsl:value-of select="@note_attribute"/>
        <xsl:text> | </xsl:text>
        <xsl:value-of select="translate(.,'&#xa;','')"/>
        <xsl:text> |&#xa;</xsl:text>
      </xsl:for-each>
      <xsl:text>Table: </xsl:text><xsl:value-of select="@name"/><xsl:text> implementation notes{#</xsl:text><xsl:value-of select="@name"/><xsl:text>Notes}&#xa;</xsl:text>
      <xsl:text>&#xa;&#xa;</xsl:text>
    </xsl:if>

    <xsl:for-each select="ebml:documentation[@purpose='references']">
      <xsl:text>references:&#xa;: </xsl:text>
      <xsl:value-of select="."/>
      <xsl:text>&#xa;&#xa;</xsl:text>
    </xsl:for-each>

    <xsl:text>&#xa;</xsl:text>
  </xsl:template>
</xsl:stylesheet>
