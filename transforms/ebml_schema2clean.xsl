<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns:str="http://exslt.org/strings" xmlns:xhtml="http://www.w3.org/1999/xhtml" exclude-result-prefixes="str xhtml ebml"
  xmlns="https://ietf.org/cellar/ebml" xmlns:ebml="https://ietf.org/cellar/ebml">
    <!-- TODO: make purpose mandatory or default to "definition" -->
  <xsl:output encoding="utf-8" method="xml" version="1.0" indent="yes"/>
  <xsl:template match="ebml:EBMLSchema">
    <EBMLSchema>
      <xsl:attribute name="docType"><xsl:value-of select="@docType"/></xsl:attribute>
      <xsl:attribute name="version"><xsl:value-of select="@version"/></xsl:attribute>
      <xsl:apply-templates select="ebml:element|comment()"/>
    </EBMLSchema>
  </xsl:template>

  <xsl:template match="ebml:element">
    <element>
        <xsl:attribute name="name">placeholder before parsePath is called</xsl:attribute>
        <xsl:attribute name="path"><xsl:value-of select="@path"/></xsl:attribute>
        <xsl:attribute name="id"><xsl:value-of select="@id"/></xsl:attribute>
        <xsl:attribute name="type"><xsl:value-of select="@type"/></xsl:attribute>
        <xsl:if test="@minver and @minver!='1'">
            <xsl:attribute name="minver"><xsl:value-of select="@minver"/></xsl:attribute>
        </xsl:if>
        <xsl:if test="@maxver">
            <xsl:attribute name="maxver"><xsl:value-of select="@maxver"/></xsl:attribute>
        </xsl:if>
        <xsl:if test="@range">
            <xsl:attribute name="range"><xsl:value-of select="@range"/></xsl:attribute>
        </xsl:if>
        <xsl:if test="@length">
            <xsl:attribute name="length"><xsl:value-of select="@length"/></xsl:attribute>
        </xsl:if>
        <xsl:if test="@default">
            <xsl:attribute name="default"><xsl:value-of select="@default"/></xsl:attribute>
        </xsl:if>
        <xsl:call-template name="parsePath">
            <xsl:with-param name="Path"><xsl:value-of select="@path"/></xsl:with-param>
        </xsl:call-template>
        <xsl:if test="@minOccurs and @minOccurs!=0">
            <xsl:attribute name="minOccurs"><xsl:value-of select="@minOccurs"/></xsl:attribute>
        </xsl:if>
        <xsl:if test="@maxOccurs">
            <xsl:attribute name="maxOccurs"><xsl:value-of select="@maxOccurs"/></xsl:attribute>
        </xsl:if>
        <xsl:if test="@recurring">
            <xsl:attribute name="recurring"><xsl:value-of select="@recurring"/></xsl:attribute>
        </xsl:if>
        <xsl:if test="@recusive">
            <xsl:attribute name="recusive"><xsl:value-of select="@recusive"/></xsl:attribute>
        </xsl:if>
        <xsl:if test="@unknownsizeallowed">
            <xsl:attribute name="unknownsizeallowed"><xsl:value-of select="@unknownsizeallowed"/></xsl:attribute>
        </xsl:if>
        <xsl:apply-templates select="ebml:documentation"/>
        <xsl:if test="ebml:restriction">
            <restriction>
                <xsl:for-each select="ebml:restriction/ebml:enum">
                    <xsl:sort select="ebml:value"/>
                    <enum value="{@value}">
                        <xsl:if test="@label">
                            <xsl:attribute name="label"><xsl:value-of select="@label"/></xsl:attribute>
                        </xsl:if>
                        <xsl:apply-templates select="ebml:documentation"/>
                    </enum>
                </xsl:for-each>
            </restriction>
        </xsl:if>
        <xsl:if test="@webm">
          <extension>
            <xsl:attribute name="webm"><xsl:value-of select="@webm"/></xsl:attribute>
          </extension>
        </xsl:if>
        <xsl:if test="@cppname">
          <extension>
            <xsl:attribute name="cppname"><xsl:value-of select="@cppname"/></xsl:attribute>
          </extension>
        </xsl:if>
        <xsl:if test="@divx">
          <extension>
            <xsl:attribute name="divx"><xsl:value-of select="@divx"/></xsl:attribute>
          </extension>
        </xsl:if>
    </element>
  </xsl:template>
  <xsl:template match="ebml:documentation">
    <documentation>
      <xsl:attribute name="lang"><xsl:value-of select="@lang"/></xsl:attribute>
      <xsl:attribute name="purpose">
        <xsl:choose>
          <xsl:when test="@purpose">
            <xsl:value-of select="@purpose"/>
          </xsl:when>
          <xsl:otherwise>definition</xsl:otherwise>
        </xsl:choose>
      </xsl:attribute>
      <!-- make sure the links are kept -->
      <xsl:apply-templates/>
    </documentation>
  </xsl:template>

  <!-- HTML tags found in documentation -->
  <xsl:template match="ebml:a">
    <a href="{@href}"><xsl:apply-templates/></a>
  </xsl:template>
  <xsl:template match="ebml:br">
    <br/><xsl:apply-templates/>
  </xsl:template>
  <xsl:template match="ebml:strong">
    <strong><xsl:apply-templates/></strong>
  </xsl:template>

  <xsl:template match="comment()">
    <xsl:comment>
      <xsl:value-of select="."/>
    </xsl:comment>
  </xsl:template>

  <xsl:template name="parsePath">
    <xsl:param name="Path"/>
    <xsl:choose>
        <xsl:when test="contains($Path, '(')">
            <xsl:call-template name="get-element-name">
                <xsl:with-param name="value"><xsl:value-of select="substring-before(substring-after($Path,'('),')')"/></xsl:with-param>
            </xsl:call-template>
        </xsl:when>
        <xsl:otherwise>
            <xsl:call-template name="get-element-name">
                <xsl:with-param name="value"><xsl:value-of select="$Path"/></xsl:with-param>
            </xsl:call-template>
        </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="get-element-name">
    <xsl:param name="value"/>
    <!-- <xsl:param name="separator"/> -->
    <xsl:choose>
      <xsl:when test="contains($value, '+')">
        <xsl:call-template name="get-element-name">
          <xsl:with-param name="value"><xsl:value-of select="substring-after($value, '+')"/></xsl:with-param>
        </xsl:call-template>
      </xsl:when>
      <xsl:when test="contains($value, '\')">
        <xsl:call-template name="get-element-name">
          <xsl:with-param name="value"><xsl:value-of select="substring-after($value, '\')"/></xsl:with-param>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:attribute name="name"><xsl:value-of select="$value"/></xsl:attribute>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
</xsl:stylesheet>
