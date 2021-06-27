<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns:str="http://exslt.org/strings" xmlns:ebml="urn:ietf:rfc:8794" >
  <xsl:output encoding="UTF-8" method="text" version="1.0" indent="yes"/>
  <xsl:variable name="smallcase" select="'abcdefghijklmnopqrstuvwxyz'"/>
  <xsl:variable name="uppercase" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZ'"/>
  <xsl:template match="ebml:EBMLSchema">
    <xsl:apply-templates select="//ebml:element[contains(@path,'\Segment') and not(@maxver='0')]"/>
  </xsl:template>
  <xsl:template match="ebml:element">
    <xsl:text>#</xsl:text>
    <xsl:value-of select="substring('#####',1,count(str:tokenize(@path,'\')))"/>
    <xsl:text> </xsl:text>
    <xsl:value-of select="@name"/>
    <xsl:text> Element&#xa;&#xa;</xsl:text>
    <xsl:if test="@name">
      <xsl:text>name:&#xa;: </xsl:text>
      <xsl:value-of select="@name"/>
      <xsl:text>&#xa;&#xa;</xsl:text>
    </xsl:if>
    <xsl:if test="@path">
      <xsl:text>path:&#xa;: `</xsl:text>
      <xsl:value-of select="@path"/>
      <xsl:text>`&#xa;&#xa;</xsl:text>
    </xsl:if>
    <xsl:if test="@id">
      <xsl:text>id:&#xa;: </xsl:text>
      <xsl:value-of select="@id"/>
      <xsl:text>&#xa;&#xa;</xsl:text>
    </xsl:if>
    <xsl:if test="@minOccurs | ebml:implementation_note[@note_attribute='minOccurs']">
      <xsl:choose>
        <xsl:when test="ebml:implementation_note[@note_attribute='minOccurs']">
          <xsl:text>minOccurs: see implementation notes&#xa;&#xa;</xsl:text>
        </xsl:when>
        <xsl:otherwise>
          <xsl:text>minOccurs:&#xa;: </xsl:text>
          <xsl:value-of select="@minOccurs"/>
          <xsl:text>&#xa;&#xa;</xsl:text>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:if>
    <xsl:if test="@maxOccurs">
      <xsl:text>maxOccurs:&#xa;: </xsl:text>
      <xsl:value-of select="@maxOccurs"/>
      <xsl:text>&#xa;&#xa;</xsl:text>
    </xsl:if>
    <xsl:if test="@range">
      <xsl:text>range:&#xa;: </xsl:text>
      <xsl:value-of select="@range"/>
      <xsl:text>&#xa;&#xa;</xsl:text>
    </xsl:if>
    <xsl:if test="@size">
      <xsl:text>size:&#xa;: </xsl:text>
      <xsl:value-of select="@size"/>
      <xsl:text>&#xa;&#xa;</xsl:text>
    </xsl:if>
    <xsl:if test="@default | ebml:implementation_note[@note_attribute='default']">
      <xsl:choose>
        <xsl:when test="ebml:implementation_note[@note_attribute='default']">
          <xsl:text>default: see implementation notes&#xa;&#xa;</xsl:text>
        </xsl:when>
        <xsl:otherwise>
          <xsl:text>default:&#xa;: </xsl:text>
          <xsl:value-of select="@default"/>
          <xsl:text>&#xa;&#xa;</xsl:text>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:if>
    <xsl:if test="@type">
      <xsl:text>type:&#xa;: </xsl:text>
      <xsl:value-of select="@type"/>
      <xsl:text>&#xa;&#xa;</xsl:text>
    </xsl:if>
    <xsl:if test="@unknownsizeallowed">
      <xsl:text>unknownsizeallowed:&#xa;: </xsl:text>
      <xsl:value-of select="@unknownsizeallowed"/>
      <xsl:text>&#xa;&#xa;</xsl:text>
    </xsl:if>
    <xsl:if test="@recursive">
      <xsl:text>recursive:&#xa;: </xsl:text>
      <xsl:value-of select="@recursive"/>
      <xsl:text>&#xa;&#xa;</xsl:text>
    </xsl:if>
    <xsl:if test="@recurring">
      <xsl:text>recurring:&#xa;: </xsl:text>
      <xsl:value-of select="@recurring"/>
      <xsl:text>&#xa;&#xa;</xsl:text>
    </xsl:if>
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
    <xsl:for-each select="ebml:documentation">
      <xsl:choose>
        <xsl:when test="@purpose">
          <xsl:value-of select="@purpose"/>
        </xsl:when>
        <xsl:otherwise>documentation</xsl:otherwise>
      </xsl:choose>
      <xsl:text>:&#xa;: </xsl:text>
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
    <xsl:for-each select="ebml:restriction">
      <xsl:text>restrictions:&#xa;&#xa;</xsl:text>
      <xsl:choose>
        <xsl:when test="ebml:enum/ebml:documentation">
          <xsl:text>|value|label|documentation|&#xa;</xsl:text>
          <xsl:text>|:---|:---|:---|&#xa;</xsl:text>
          <xsl:for-each select="ebml:enum">
            <xsl:text>|`</xsl:text>
            <xsl:value-of select="@value"/>
            <xsl:text>` |</xsl:text>
            <xsl:value-of select="@label"/>
            <xsl:text> |</xsl:text>
            <xsl:value-of select="ebml:documentation"/>
            <xsl:text> |&#xa;</xsl:text>
          </xsl:for-each>
        </xsl:when>
        <xsl:otherwise>
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
    <xsl:text>&#xa;</xsl:text>
  </xsl:template>
</xsl:stylesheet>
