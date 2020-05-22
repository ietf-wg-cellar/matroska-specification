<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"
   xmlns:ebml="https://ietf.org/cellar/ebml" exclude-result-prefixes="ebml">
  <xsl:output encoding="UTF-8" method="xml" version="1.0" indent="yes"/>
  <xsl:template match="ebml:EBMLSchema">
    <html>
      <head>
        <style>
          .techdef table{
            font-family:sans-serif;
            background:#fff;
            margin:0;
            padding:0;
          }

          .techdef th{
            font-size:larger;
            border:5px solid #ddd;
            background:#eee;
            padding:.5em 0 .5em 0;
            margin:0;
          }

          .techdef tr{
            margin:0;
            padding:0;
          }

          .techdef td{
            margin:0;
            border:1px solid #eee;
            padding:2px;
          }

          .level0{
            background:#fff;
          }

          .level1{
            background:#eff;
          }

          .level2{
            background:#eef;
          }

          .level3{
            background:#dde;
          }

          .level4{
            background:#ccd;
          }

          .level5{
            background:#bbc;
          }

          .level6{
            background:#aab;
          }

          .level7{
            background:#99a;
          }

          .level8{
            background:#889;
          }
        </style>
      </head>
      <body>
        <div class="techdef">
          <h1>Matroska v<xsl:value-of select="@version"/> element specification</h1>
          <p>
            Note: this is Matroska version <xsl:value-of select="@version"/> generated from
            <a href="https://github.com/cellar-wg/matroska-specification/blob/master/ebml_matroska.xml">ebml_matroska.xml</a>
            git revision <xsl:value-of select="$GitRevision"/>
          </p>
          <table class="specstable">
            <xsl:call-template name="TableHeading"/>
            <xsl:apply-templates select="//ebml:element"/>
          </table>
        </div>
      </body>
    </html>
  </xsl:template>

  <xsl:template name="TableHeading">
    <tr>
      <th>Element Name</th>
      <th>Level</th>
      <th>Element ID</th>
      <th>min</th>
      <th>max</th>
      <th>Range</th>
      <th>Default</th>
      <th>Type</th>
      <th>Version</th>
      <th>WebM</th>
      <th>Description</th>
    </tr>
  </xsl:template>

  <xsl:template name="SectionHeading">
    <xsl:param name="Name"/>

    <tr>
      <th colspan="11" id="Level{ $Name }">
        <xsl:choose>
          <xsl:when test="$Name = 'SeekHead'">Meta Seek Information</xsl:when>
          <xsl:when test="$Name = 'Info'">Segment Information</xsl:when>
          <xsl:when test="$Name = 'Cues'">Cueing Data</xsl:when>
          <xsl:when test="$Name = 'Cluster'">Clusters</xsl:when>
          <xsl:when test="$Name = 'Tags'">Tagging</xsl:when>
          <xsl:otherwise><xsl:value-of select="$Name"/></xsl:otherwise>
        </xsl:choose>
      </th>
    </tr>
  </xsl:template>

  <xsl:template name="ElementType">
    <xsl:param name="Type"/>

    <xsl:choose>
      <xsl:when test="$Type = 'utf-8'">Unicode string</xsl:when>
      <xsl:when test="$Type = 'string'">ASCII string</xsl:when>
      <xsl:when test="$Type = 'uinteger'">unsigned integer</xsl:when>
      <xsl:when test="$Type = 'integer'">signed integer</xsl:when>
      <xsl:when test="$Type = 'date'">date &amp; time</xsl:when>
      <xsl:otherwise><xsl:value-of select="$Type"/></xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="GetLevel">
    <xsl:param name="String"/>
    <xsl:param name="Level"/>

    <xsl:variable name="sa" select="substring-after($String, '\')" />

    <xsl:choose>
      <xsl:when test="$sa != '' or contains($String, '\')">
        <xsl:call-template name="GetLevel">
          <xsl:with-param name="String"  select="$sa" />
          <xsl:with-param name="Level"   select="$Level + 1" />
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$Level - 1" />
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="ebml:restriction">
    <ul>
      <li>point!</li>
    </ul>
  </xsl:template>

  <xsl:template match="ebml:enum">
    <li>
      <xsl:value-of select="@value"/>
      <xsl:if test="@value != @label">
        —
        <xsl:value-of select="@label"/>
      </xsl:if>
      <xsl:if test="boolean(ebml:documentation[@lang='en'])">
        (
        <xsl:value-of select="ebml:documentation[@lang='en']" disable-output-escaping="yes"/>
        )
      </xsl:if>
    </li>
  </xsl:template>

  <xsl:template match="ebml:restriction">
    <ul>
      <xsl:apply-templates select="ebml:enum"/>
    </ul>
  </xsl:template>

  <xsl:template match="ebml:element">
    <xsl:variable name="level">
      <xsl:call-template name="GetLevel">
          <xsl:with-param name="String" select="@path"/>
          <xsl:with-param name="Level" select="0"/>
      </xsl:call-template>
    </xsl:variable>

    <xsl:if test="($level &lt;= 1) and not(starts-with(@name, 'EBML'))">
      <xsl:call-template name="TableHeading"/>
      <xsl:call-template name="SectionHeading">
        <xsl:with-param name="Name" select="@name"/>
      </xsl:call-template>
    </xsl:if>

    <tr class="level{$level}">
      <td style="white-space: nowrap">
        <xsl:value-of select="@name"/>
      </td>
      <td align="right">
        <xsl:value-of select="$level"/>
        <xsl:if test="@recursive = 1 or @global = 1">
          <xsl:text>+</xsl:text>
        </xsl:if>
      </td>
      <td align="right" style="white-space: nowrap">
        <xsl:value-of select="@id"/>
      </td>
      <td align="right">
        <xsl:choose>
          <xsl:when test="@minOccurs">
            <xsl:value-of select="@minOccurs"/>
          </xsl:when>
          <xsl:otherwise>0</xsl:otherwise>
        </xsl:choose>
      </td>
      <td align="right">
        <xsl:choose>
          <xsl:when test="@maxOccurs">
            <xsl:value-of select="@maxOccurs"/>
          </xsl:when>
          <xsl:otherwise>-</xsl:otherwise>
        </xsl:choose>
      </td>
      <td align="right" style="white-space: nowrap">
        <xsl:value-of select="@range"/>
      </td>
      <td align="right">
        <xsl:value-of select="@default"/>
      </td>
      <td>
        <xsl:call-template name="ElementType">
          <xsl:with-param name="Type" select="@type"/>
        </xsl:call-template>
      </td>
      <td align="right" style="white-space: nowrap">
        <xsl:choose>
          <xsl:when test="@minver">
            <xsl:value-of select="@minver"/>
          </xsl:when>
          <xsl:otherwise>1</xsl:otherwise>
        </xsl:choose>
        <xsl:text>-</xsl:text>
        <xsl:choose>
          <xsl:when test="@maxver">
            <xsl:value-of select="@maxver"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="//ebml:EBMLSchema/@version"/>
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td>
        <xsl:if test="not(boolean(ebml:extension[@webm='0']))">yes</xsl:if>
      </td>
      <td>
        <xsl:value-of select="ebml:documentation[@lang='en']" disable-output-escaping="yes"/>
        <xsl:apply-templates select="ebml:restriction"/>
      </td>
    </tr>
  </xsl:template>
</xsl:stylesheet>
