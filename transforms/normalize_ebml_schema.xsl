<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns:str="http://exslt.org/strings" exclude-result-prefixes="str">
    <!-- TODO: make purpose mandatory or default to "definition" -->
  <xsl:output encoding="UTF-8" method="xml" version="1.0" indent="yes" />
  <xsl:template match="EBMLSchema">
    <EBMLSchema docType="matroska" version="4">
    <xsl:apply-templates select="element|comment()"/>
    </EBMLSchema>
  </xsl:template>
  <xsl:template match="element">
    <element>
        <xsl:attribute name="name">placeholder before parsePath is called</xsl:attribute>
        <xsl:attribute name="path"><xsl:value-of select="@path" /></xsl:attribute>
        <xsl:attribute name="id"><xsl:value-of select="@id" /></xsl:attribute>
        <xsl:attribute name="type"><xsl:value-of select="@type" /></xsl:attribute>
        <xsl:if test="@minver and @minver!='1'">
            <xsl:attribute name="minver"><xsl:value-of select="@minver" /></xsl:attribute>
        </xsl:if>
        <xsl:if test="@maxver">
            <xsl:attribute name="maxver"><xsl:value-of select="@maxver" /></xsl:attribute>
        </xsl:if>
        <xsl:if test="@range">
            <xsl:attribute name="range"><xsl:value-of select="@range" /></xsl:attribute>
        </xsl:if>
        <xsl:if test="@length">
            <xsl:attribute name="length"><xsl:value-of select="@length" /></xsl:attribute>
        </xsl:if>
        <xsl:if test="@default">
            <xsl:attribute name="default"><xsl:value-of select="@default" /></xsl:attribute>
        </xsl:if>
        <xsl:call-template name="parsePath">
            <xsl:with-param name="Path"><xsl:value-of select="@path" /></xsl:with-param>
        </xsl:call-template>
        <xsl:if test="@recurring">
            <xsl:attribute name="recurring"><xsl:value-of select="@recurring" /></xsl:attribute>
        </xsl:if>
        <xsl:if test="@unknownsizeallowed">
            <xsl:attribute name="unknownsizeallowed"><xsl:value-of select="@unknownsizeallowed" /></xsl:attribute>
        </xsl:if>
        <!-- REMOVE THIS tag -->
        <xsl:if test="@webm">
            <xsl:attribute name="webm"><xsl:value-of select="@webm" /></xsl:attribute>
        </xsl:if>
        <!-- REMOVE THIS tag -->
        <xsl:if test="@divx">
            <xsl:attribute name="divx"><xsl:value-of select="@divx" /></xsl:attribute>
        </xsl:if>
        <!-- REMOVE THIS tag -->
        <xsl:if test="@cppname">
            <xsl:attribute name="cppname"><xsl:value-of select="@cppname" /></xsl:attribute>
        </xsl:if>
        <xsl:apply-templates select="documentation"/>
        <xsl:if test="restriction">
            <restriction>
                <xsl:for-each select="restriction/enum">
                    <xsl:sort select="value"/>
                    <enum value="{@value}">
                        <xsl:if test="@label">
                            <xsl:attribute name="label"><xsl:value-of select="@label" /></xsl:attribute>
                        </xsl:if>
                        <xsl:apply-templates select="documentation"/>
                    </enum>
                </xsl:for-each>
            </restriction>
        </xsl:if>
    </element>
  </xsl:template>
  <xsl:template match="documentation">
    <documentation>
        <xsl:attribute name="lang"><xsl:value-of select="@lang" /></xsl:attribute>
        <xsl:if test="@purpose">
            <xsl:attribute name="purpose"><xsl:value-of select="@purpose" /></xsl:attribute>
        </xsl:if>
        <!-- <xsl:attribute name="type">
            <xsl:choose>
                <xsl:when test="@type">
                    <xsl:value-of select="@type"/>
                </xsl:when>
                <xsl:otherwise>documentation</xsl:otherwise>
            </xsl:choose>
        </xsl:attribute> -->
        <!-- make sure the links are kept -->
        <xsl:apply-templates/>
    </documentation>
  </xsl:template>

  <!-- HTML tags found in documentation -->
  <xsl:template match="a">
    <a href="{@href}"><xsl:apply-templates/></a>
  </xsl:template>
  <xsl:template match="strong">
    <strong><xsl:apply-templates/></strong>
  </xsl:template>
  <xsl:template match="br">
    <br/><xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="comment()">
    <xsl:comment>
      <xsl:value-of select="."/>
    </xsl:comment>
  </xsl:template>

  <xsl:template name="parsePath">
    <xsl:param name="Path"/>
    <xsl:variable name="EBMLElementOccurrence" select="substring-before($Path,'(')"/>
    <xsl:variable name="EBMLMinOccurrence"     select="substring-before($EBMLElementOccurrence,'*')"/>
    <xsl:variable name="EBMLMaxOccurrence"     select="substring-after($EBMLElementOccurrence,'*')"/>
    <xsl:variable name="EBMLMasterPath"   select="substring-before(substring-after($Path,'('),')')"/>
    <xsl:call-template name="get-element-name">
        <xsl:with-param name="value"><xsl:value-of select="$EBMLMasterPath" /></xsl:with-param>
    </xsl:call-template>
    <xsl:if test="$EBMLMinOccurrence and $EBMLMinOccurrence!='0'">
      <xsl:attribute name="minOccurs"><xsl:value-of select="$EBMLMinOccurrence" /></xsl:attribute>
    </xsl:if>
    <xsl:if test="$EBMLMaxOccurrence">
      <xsl:attribute name="maxOccurs"><xsl:value-of select="$EBMLMaxOccurrence" /></xsl:attribute>
    </xsl:if>
  </xsl:template>

  <xsl:template name="get-element-name">
    <xsl:param name="value"/>
    <xsl:param name="separator"/>
    <xsl:choose>
        <xsl:when test="contains($value, '\')">
            <xsl:call-template name="get-element-name">
                <xsl:with-param name="value"><xsl:value-of select="substring-after($value, '\')" /></xsl:with-param>
            </xsl:call-template>
        </xsl:when>
        <xsl:otherwise>
            <xsl:attribute name="name"><xsl:value-of select="$value" /></xsl:attribute>
        </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
</xsl:stylesheet>
