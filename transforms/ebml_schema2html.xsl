<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"
   xmlns:ebml="https://ietf.org/cellar/ebml" exclude-result-prefixes="ebml">
  <xsl:output encoding="UTF-8" method="xml" version="1.0" indent="yes"/>
  <xsl:template match="ebml:EBMLSchema">
    <html>
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
      </style>
      <div class="techdef">
      <h1><xsl:value-of select="@docType"/></h1>
      <p>Version: <xsl:value-of select="@version"/></p>
      <table class="specstable">
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
          <th>Description</th>
        </tr>
        <xsl:apply-templates select="//ebml:element"/>
      </table>
    </div>
    </html>
  </xsl:template>
  <xsl:template match="ebml:element">
    <tr class="level{@level}">
      <td>
        <xsl:value-of select="@name"/>
      </td>
      <td>
        <xsl:value-of select="@level"/>
        <xsl:if test="@recursive = 1 or @global = 1">
          <xsl:text>+</xsl:text>
        </xsl:if>
      </td>
      <td>
        <xsl:value-of select="@id"/>
      </td>
      <td>
        <xsl:choose>
          <xsl:when test="@minOccurs">
            <xsl:value-of select="@minOccurs"/>
          </xsl:when>
          <xsl:otherwise>0</xsl:otherwise>
        </xsl:choose>
      </td>
      <td>
        <xsl:choose>
          <xsl:when test="@maxOccurs">
            <xsl:value-of select="@maxOccurs"/>
          </xsl:when>
          <xsl:otherwise>1</xsl:otherwise>
        </xsl:choose>
      </td>
      <td>
        <xsl:value-of select="@range"/>
      </td>
      <td>
        <xsl:value-of select="@default"/>
      </td>
      <td>
        <xsl:value-of select="@type"/>
      </td>
      <td>
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
        <xsl:value-of select="ebml:documentation"/>
      </td>
    </tr>
  </xsl:template>
</xsl:stylesheet>
