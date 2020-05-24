<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"
   xmlns:ebml="https://ietf.org/cellar/ebml" exclude-result-prefixes="ebml">

  <xsl:template name="GenerateTable">
    <xsl:param name="GitRevision"/>

    <div class="techdef">
      <h1>Matroska v<xsl:value-of select="@version"/> element specification</h1>
      <p>
        Note: this is Matroska version <xsl:value-of select="@version"/> generated from
        <a href="https://github.com/cellar-wg/matroska-specification/blob/master/ebml_matroska.xml">ebml_matroska.xml</a>
        <xsl:if test="$GitRevision">
          git revision <xsl:value-of select="$GitRevision"/>
        </xsl:if>
      </p>
      <table class="specstable">
        <xsl:call-template name="OutputHeader"/>

        <xsl:apply-templates select="//ebml:element"/>

        <xsl:call-template name="OutputHeader"/>
      </table>
    </div>
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

  <xsl:template name="OutputHeader">
    <tr class="toptitle"><th style="white-space: nowrap">Element Name</th>
    <th title="Level"><abbr title="Level">L</abbr> </th>
    <th style="white-space: nowrap">EBML ID</th>
    <th title="Mandatory"><abbr title="Mandatory">Ma</abbr> </th>
    <th title="Multiple"><abbr title="Multiple">Mu</abbr> </th>
    <th title="Range"><abbr title="Range">Rng</abbr> </th>
    <th>Default</th>
    <th title="Element Type"><abbr title="Element Type">T</abbr> </th>
    <th title="Version 1"><abbr title="Version 1">1</abbr> </th>
    <th title="Version 2"><abbr title="Version 2">2</abbr> </th>
    <th title="Version 3"><abbr title="Version 3">3</abbr> </th>
    <th title="Version 4"><abbr title="Version 4">4</abbr> </th>
    <th title="WebM"><abbr title="WebM">W</abbr> </th>
    <th>Description</th>
    </tr>
  </xsl:template>


  <xsl:template match="ebml:element">
    <xsl:variable name="level">
      <xsl:call-template name="GetLevel">
        <xsl:with-param name="String" select="@path"/>
        <xsl:with-param name="Level" select="0"/>
      </xsl:call-template>
    </xsl:variable>

    <!-- <p><xsl:value-of select="$level"/></p> -->

    <xsl:if test="($level=0 or $level=1) and not(contains(@path,'\EBML\'))">
      <xsl:call-template name="OutputHeader"/>
      <tr>
        <xsl:variable name="SectionTitle">
          <xsl:choose>
            <xsl:when test="@name='SeekHead'">
              <xsl:text>Meta Seek Information</xsl:text>
            </xsl:when>
            <xsl:when test="@name='Info'">
              <xsl:text>Segment Information</xsl:text>
            </xsl:when>
            <xsl:when test="@name='Tracks'">
              <xsl:text>Track</xsl:text>
            </xsl:when>
            <xsl:when test="@name='Cues'">
              <xsl:text>Cueing Data</xsl:text>
            </xsl:when>
            <xsl:when test="@name='Attachments'">
              <xsl:text>Attachment</xsl:text>
            </xsl:when>
            <xsl:when test="@name='Tags'">
              <xsl:text>Tagging</xsl:text>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="@name"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:variable>
        <th colspan="14">
          <xsl:attribute name="id">
            <xsl:text>Level</xsl:text>
            <xsl:value-of select="translate($SectionTitle,' ','')"/>
          </xsl:attribute>
          <xsl:value-of select="$SectionTitle"/>
        </th>
      </tr>
    </xsl:if>

    <tr id="{@name}">
      <xsl:attribute name="class">
        <xsl:choose>
          <xsl:when test="@maxver &lt; 4">
            <xsl:text>version2</xsl:text>
          </xsl:when>
          <xsl:otherwise>
            <xsl:text>level</xsl:text><xsl:value-of select="$level"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:attribute>

      <td><xsl:value-of select="@name"/></td>
      <td>
        <xsl:value-of select="$level"/>
        <xsl:if test="@recursive = 1 or @global = 1">
          <xsl:text>+</xsl:text>
        </xsl:if>
      </td>
      <td align="right">
        <xsl:if test="@name='Segment' or @name='Tracks'">
          <xsl:attribute name="style"><xsl:text>white-space: nowrap</xsl:text></xsl:attribute>
        </xsl:if>

        <xsl:value-of select="@id"/>
      </td>
      <td>
        <xsl:choose>
          <xsl:when test="@minOccurs">
            <xsl:text>mand.</xsl:text>
          </xsl:when>
          <xsl:otherwise>
            <xsl:attribute name="class"><xsl:text>unset</xsl:text></xsl:attribute>
            <xsl:text>-</xsl:text>
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td>
        <xsl:choose>
          <xsl:when test="not(@maxOccurs) or @maxOccurs &gt; 1">
            <xsl:text>mult.</xsl:text>
          </xsl:when>
          <xsl:otherwise>
            <xsl:attribute name="class"><xsl:text>unset</xsl:text></xsl:attribute>
            <xsl:text>-</xsl:text>
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td>
        <xsl:choose>
          <xsl:when test="@range">
            <xsl:choose>
              <xsl:when test="contains(@range,'0x0p+0')">
                <xsl:value-of select="substring-before(@range,'0x0p+0')" />
                <xsl:text>0.0</xsl:text>
                <xsl:value-of select="substring-after(@range,'0x0p+0')" />
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="@range"/>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:when>
          <xsl:otherwise>
            <xsl:attribute name="class"><xsl:text>unset</xsl:text></xsl:attribute>
            <xsl:text>-</xsl:text>
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td>
        <xsl:choose>
          <xsl:when test="@default">
            <xsl:choose>
              <xsl:when test="@default='0x0p+0'"><xsl:text>0.0</xsl:text></xsl:when>
              <xsl:when test="@default='0x1p+0'"><xsl:text>1.0</xsl:text></xsl:when>
              <xsl:when test="@default='0x1.f4p+12'"><xsl:text>8000.0</xsl:text></xsl:when>
              <xsl:otherwise><xsl:value-of select="@default"/></xsl:otherwise>
            </xsl:choose>
          </xsl:when>
          <xsl:when test="ebml:implementation_note[@note_attribute='default']">
            <xsl:attribute name="title"><xsl:text>See Description</xsl:text></xsl:attribute>
            <xsl:text>[desc.]</xsl:text>
          </xsl:when>
          <xsl:otherwise>
            <xsl:attribute name="class"><xsl:text>unset</xsl:text></xsl:attribute>
            <xsl:text>-</xsl:text>
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td>
        <abbr>
          <xsl:choose>
            <xsl:when test="@type='master'">
              <xsl:attribute name="title"><xsl:text>Master Elements</xsl:text></xsl:attribute>
              <xsl:text>m</xsl:text>
            </xsl:when>
            <xsl:when test="@type='binary'">
              <xsl:attribute name="title"><xsl:text>Binary</xsl:text></xsl:attribute>
              <xsl:text>b</xsl:text>
            </xsl:when>
            <xsl:when test="@type='utf-8'">
              <xsl:attribute name="title"><xsl:text>Unicode string</xsl:text></xsl:attribute>
              <xsl:text>8</xsl:text>
            </xsl:when>
            <xsl:when test="@type='string'">
              <xsl:attribute name="title"><xsl:text>ASCII String</xsl:text></xsl:attribute>
              <xsl:text>s</xsl:text>
            </xsl:when>
            <xsl:when test="@type='integer'">
              <xsl:attribute name="title"><xsl:text>Signed Integer</xsl:text></xsl:attribute>
              <xsl:text>i</xsl:text>
            </xsl:when>
            <xsl:when test="@type='uinteger'">
              <xsl:attribute name="title"><xsl:text>Unsigned Integer</xsl:text></xsl:attribute>
              <xsl:text>u</xsl:text>
            </xsl:when>
            <xsl:when test="@type='float'">
              <xsl:attribute name="title"><xsl:text>Float</xsl:text></xsl:attribute>
              <xsl:text>f</xsl:text>
            </xsl:when>
            <xsl:when test="@type='date'">
              <xsl:attribute name="title"><xsl:text>Date &amp; time</xsl:text></xsl:attribute>
              <xsl:text>d</xsl:text>
            </xsl:when>
          </xsl:choose>
        </abbr>
      </td>
      <td>
        <xsl:choose>
          <xsl:when test="@maxver=0"/> <!-- Do Nothing -->
          <xsl:when test="(not(@minver) or @minver &lt;= 1) and (not(@maxver) or @maxver &gt;= 1)">
            <abbr title="available in Matroska v1">
              <xsl:text>*</xsl:text>
            </abbr>
          </xsl:when>
          <xsl:otherwise>
            <xsl:attribute name="class"><xsl:text>flagnot</xsl:text></xsl:attribute>
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td>
        <xsl:choose>
          <xsl:when test="@maxver=0"/> <!-- Do Nothing -->
          <xsl:when test="(not(@minver) or @minver &lt;= 2) and (not(@maxver) or @maxver &gt;= 2)">
            <abbr title="available in Matroska v2">
              <xsl:text>*</xsl:text>
            </abbr>
          </xsl:when>
          <xsl:otherwise>
            <xsl:attribute name="class"><xsl:text>flagnot</xsl:text></xsl:attribute>
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td>
        <xsl:choose>
          <xsl:when test="@maxver=0"/> <!-- Do Nothing -->
          <xsl:when test="(not(@minver) or @minver &lt;= 3) and (not(@maxver) or @maxver &gt;= 3)">
            <abbr title="available in Matroska v3">
              <xsl:text>*</xsl:text>
            </abbr>
          </xsl:when>
          <xsl:otherwise>
            <xsl:attribute name="class"><xsl:text>flagnot</xsl:text></xsl:attribute>
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td>
        <xsl:choose>
          <xsl:when test="@maxver=0"/> <!-- Do Nothing -->
          <xsl:when test="(not(@minver) or @minver &lt;= 4) and (not(@maxver) or @maxver &gt;= 4)">
            <abbr title="available in Matroska v4">
              <xsl:text>*</xsl:text>
            </abbr>
          </xsl:when>
          <xsl:otherwise>
            <xsl:attribute name="class"><xsl:text>flagnot</xsl:text></xsl:attribute>
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td>
        <xsl:choose>
          <xsl:when test="@maxver=0"/>
          <xsl:when test="ebml:extension[@webm='0']">
            <xsl:attribute name="class"><xsl:text>flagnot</xsl:text></xsl:attribute>
          </xsl:when>
          <xsl:otherwise>
            <abbr title="available in WebM">
              <xsl:text>*</xsl:text>
            </abbr>
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td>
        <xsl:apply-templates select="ebml:documentation[@purpose='definition']"/>
        <xsl:if test="ebml:documentation[@purpose='rationale']">
          <xsl:text> </xsl:text>
          <xsl:apply-templates select="ebml:documentation[@purpose='rationale']"/>
        </xsl:if>
        <xsl:if test="ebml:documentation[@purpose='usage notes']">
          <xsl:text> </xsl:text>
          <xsl:apply-templates select="ebml:documentation[@purpose='usage notes']"/>
        </xsl:if>
        <xsl:if test="ebml:documentation[@purpose='references']">
          <xsl:text> </xsl:text>
          <xsl:apply-templates select="ebml:documentation[@purpose='references']"/>
        </xsl:if>
        <xsl:if test="ebml:implementation_note[@note_attribute='default']">
          <xsl:text> </xsl:text>
          <xsl:apply-templates select="ebml:implementation_note[@note_attribute='default']"/>
        </xsl:if>
        <xsl:if test="ebml:implementation_note[@note_attribute='minOccurs']">
          <xsl:text> </xsl:text>
          <xsl:apply-templates select="ebml:implementation_note[@note_attribute='minOccurs']"/>
        </xsl:if>
        <xsl:if test="ebml:restriction">
          <br/><xsl:text>&#xa;</xsl:text>
          <xsl:for-each select="ebml:restriction/ebml:enum">
            <xsl:value-of select="@value"/><xsl:text> - </xsl:text>
            <!-- <xsl:value-of select="@label"/> -->
            <xsl:call-template name="OutputCleanedText">
              <xsl:with-param name="String" select="@label" />
            </xsl:call-template>
            <xsl:if test="not(position() = last())">
              <xsl:text>,</xsl:text><br/><xsl:text>&#xa;</xsl:text>
            </xsl:if>
          </xsl:for-each>
        </xsl:if>

      </td>
    </tr>
  </xsl:template>

  <xsl:template match="ebml:documentation">
    <!-- make sure the links are kept -->
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="ebml:implementation_note">
    <!-- make sure the links are kept -->
    <xsl:apply-templates/>
  </xsl:template>

  <!-- HTML tags found in documentation -->
  <xsl:template match="ebml:a">
    <a href="{@href}"><xsl:apply-templates/></a>
  </xsl:template>
  <xsl:template match="ebml:br">
    <br/><xsl:text>&#xa;</xsl:text>
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template name="OutputCleanedText">
    <xsl:param name="String"/>

    <xsl:choose>
      <xsl:when test="contains($String,'`') and contains(substring-after($String,'`'),'`')">
        <xsl:variable name="unmarkdown">
          <xsl:value-of select="substring-before($String,'`')"/>
          <xsl:text disable-output-escaping="yes">&lt;a href="#</xsl:text><xsl:value-of select="substring-before(substring-after($String,'`'),'`')"/><xsl:text disable-output-escaping="yes">"&gt;</xsl:text>
          <xsl:value-of select="substring-before(substring-after($String,'`'),'`')"/>
          <xsl:text disable-output-escaping="yes">&lt;/a&gt;</xsl:text>
          <xsl:value-of select="substring-after(substring-after($String,'`'),'`')"/>
        </xsl:variable>
        <xsl:call-template name="OutputCleanedText">
          <xsl:with-param name="String" select="$unmarkdown" />
        </xsl:call-template>
      </xsl:when>
      <xsl:when test="contains($String,'&amp; ')">
        <xsl:variable name="unmarkdown">
          <xsl:value-of select="substring-before($String,'&amp; ')"/>
          <xsl:text disable-output-escaping="yes">&amp;amp; </xsl:text>
          <xsl:value-of select="substring-after($String,'&amp; ')"/>
        </xsl:variable>
        <xsl:call-template name="OutputCleanedText">
          <xsl:with-param name="String" select="$unmarkdown" />
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise><xsl:value-of select="$String" disable-output-escaping="yes"/></xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- Catch all template -->
  <xsl:template match="text()">
    <xsl:choose>
      <xsl:when test="contains(.,'(minOccurs=1) ')">
        <xsl:call-template name="OutputCleanedText">
          <xsl:with-param name="String" select="concat(substring-before(.,'(minOccurs=1) '),substring-after(.,'(minOccurs=1) '))" />
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="OutputCleanedText">
          <xsl:with-param name="String" select="." />
        </xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

</xsl:stylesheet>
