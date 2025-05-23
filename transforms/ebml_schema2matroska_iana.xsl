<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns:ebml="urn:ietf:rfc:8794" xmlns="http://www.iana.org/assignments">
  <xsl:output encoding="UTF-8" method="text" version="1.0" indent="yes"/>
  <xsl:variable name="smallcase" select="'abcdefghijklmnopqrstuvwxyz'"/>
  <xsl:variable name="uppercase" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZ'"/>

  <xsl:variable name="liaisonin"  select="'abcdefghijklmnopqrstuvwxyz'"/>
  <xsl:variable name="liaisonout" select="'n   n   n     n     n   n '"/>

  <xsl:template match="ebml:EBMLSchema">
    <xsl:text>&#xa;&#xa;&#xa;</xsl:text>
    <xsl:apply-templates select="//ebml:element[contains(@path,'\Segment') and (not(@minver) or @minver&lt;5)]">
      <xsl:sort select="@id" order="ascending" />
    </xsl:apply-templates>
  </xsl:template>

  <xsl:template match="ebml:element">
    <xsl:if test="ebml:extension[@type='enum source']/@registry">
      <xsl:text>## </xsl:text>
      <xsl:call-template name="RegistryToTitle">
        <xsl:with-param name="registry" select="ebml:extension[@type='enum source']/@registry" />
      </xsl:call-template>
      <xsl:text> Registry&#xa;&#xa;</xsl:text>
      <xsl:text>IANA has created a new registry called the "</xsl:text>
      <xsl:call-template name="RegistryToTitle">
        <xsl:with-param name="registry" select="ebml:extension[@type='enum source']/@registry" />
      </xsl:call-template>
      <xsl:text>" registry.&#xa;</xsl:text>
      <xsl:text>The values correspond to the unsigned integer `</xsl:text><xsl:value-of select="@name"/><xsl:text>`</xsl:text>
      <xsl:choose>
        <xsl:when test="@name='ChapProcessCodecID'">
          <!-- FIXME use a query to find all the elements using this registry name -->
          <xsl:text>, `ChapterTranslateCodec`, and `TrackTranslateCodec` values </xsl:text>
        </xsl:when>
        <xsl:otherwise>
          <xsl:text> value </xsl:text>
        </xsl:otherwise>
      </xsl:choose>
      <xsl:text>described in </xsl:text>

      <xsl:call-template name="NameToElement">
        <xsl:with-param name="name" select="@name" />
      </xsl:call-template>

      <xsl:text>.&#xa;&#xa;</xsl:text>

      <xsl:text>To register a new </xsl:text>
      <xsl:call-template name="RegistryToName">
        <xsl:with-param name="registry" select="ebml:extension[@type='enum source']/@registry" />
      </xsl:call-template>
      <xsl:text> in this registry, one needs </xsl:text>
      <xsl:call-template name="NameWithLiaison">
        <xsl:with-param name="name" select="ebml:extension[@type='enum source']/@registry" />
      </xsl:call-template>
      <xsl:text> value,&#xa;</xsl:text>
      <xsl:text>a description, a Change Controller, and&#xa;a</xsl:text>
      <xsl:if test="ebml:extension[@type='enum source']/@policy='First Come First Served'">
        <xsl:text>n optional</xsl:text>
      </xsl:if>
      <xsl:text> Reference to a document describing the </xsl:text>
      <xsl:call-template name="RegistryToName">
        <xsl:with-param name="registry" select="ebml:extension[@type='enum source']/@registry" />
      </xsl:call-template>
      <xsl:text>.&#xa;&#xa;</xsl:text>

      <xsl:text>The </xsl:text>
      <xsl:call-template name="RegistryToName">
        <xsl:with-param name="registry" select="ebml:extension[@type='enum source']/@registry" />
      </xsl:call-template>
      <xsl:text>s are to be allocated according to the "</xsl:text>
      <xsl:value-of select="ebml:extension[@type='enum source']/@policy"/>
      <xsl:text>" policy [@!RFC8126].</xsl:text>
      <xsl:text> Available values range from </xsl:text>
      <xsl:choose>
        <xsl:when test="ebml:extension[@type='enum source']/@bitfield">
          <xsl:text>0x</xsl:text><xsl:value-of select="substring(ebml:restriction/ebml:enum[last()]/@value,3) * 2"/><xsl:text>-0x8000000000000000</xsl:text>
        </xsl:when>
        <xsl:otherwise>
          <xsl:for-each select="ebml:restriction/ebml:enum">
                <xsl:if test="(position() &gt; 0)">
                    <xsl:variable name="prev_value">
                        <xsl:choose>
                            <xsl:when test="position() &gt; 1">
                                <xsl:variable name="prev" select="position() - 1"/>
                                <xsl:value-of select="../ebml:enum[$prev]/@value"/>
                            </xsl:when>
                            <xsl:otherwise>
                              <xsl:choose>
                                  <xsl:when test="../../@range='not 0'">
                                    <!-- first element, unsigned integers start at 1 -->
                                    <xsl:value-of select="0"/>
                                  </xsl:when>
                                  <xsl:otherwise>
                                    <!-- first element, unsigned integers start at 0 -->
                                    <xsl:value-of select="-1"/>
                                  </xsl:otherwise>
                              </xsl:choose>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:variable>
                    <xsl:if test="not($prev_value + 1 = @value) and (not(@value = 1) or not(../../@range='not 0'))">
                        <xsl:value-of select="$prev_value + 1"/>
                        <xsl:text>-</xsl:text>
                        <xsl:value-of select="@value - 1"/>
                        <xsl:text>, </xsl:text>
                        <xsl:if test="position() = (last() - 1) and (@value + 1 = ../ebml:enum[last()]/@value)"><xsl:text>and </xsl:text></xsl:if>
                        <xsl:if test="position() = last()"><xsl:text>and </xsl:text></xsl:if>
                    </xsl:if>
                </xsl:if>
          </xsl:for-each>
          <xsl:value-of select="ebml:restriction/ebml:enum[last()]/@value + 1"/><xsl:text>-18446744073709551615</xsl:text>
        </xsl:otherwise>
      </xsl:choose>
      <xsl:text>.&#xa;&#xa;</xsl:text>

      <xsl:if test="ebml:extension[@type='enum source']/@bitfield">
        <xsl:text>The </xsl:text>
        <xsl:call-template name="RegistryToName">
          <xsl:with-param name="registry" select="ebml:extension[@type='enum source']/@registry" />
        </xsl:call-template>
        <xsl:text> is a bit-field value, so only power of 2 values can be registered.&#xa;&#xa;</xsl:text>
      </xsl:if>

      <xsl:if test="@range='not 0'">
        <xsl:text>The value 0 is not valid for use as </xsl:text>
        <xsl:call-template name="NameWithLiaison">
          <xsl:with-param name="name" select="ebml:extension[@type='enum source']/@registry" />
        </xsl:call-template>
        <xsl:text>.&#xa;&#xa;</xsl:text>
      </xsl:if>

      <xsl:text>(</xsl:text>
      <xsl:call-template name="RegistryToTable">
        <xsl:with-param name="registry" select="ebml:extension[@type='enum source']/@registry" />
      </xsl:call-template>
      <xsl:text>) shows the initial contents of the "</xsl:text>
      <xsl:call-template name="RegistryToTitle">
        <xsl:with-param name="registry" select="ebml:extension[@type='enum source']/@registry" />
      </xsl:call-template>
      <xsl:text>" registry. The Change Controller for the initial entries is the IETF.&#xa;&#xa;</xsl:text>

      <xsl:call-template name="RegistryToName">
        <xsl:with-param name="registry" select="ebml:extension[@type='enum source']/@registry" />
      </xsl:call-template>
      <xsl:text> | Description            | Reference&#xa;</xsl:text>
      <xsl:text>----------:|:------------------------|:-------------------------------------------&#xa;</xsl:text>

      <!-- not 0 -->
      <xsl:if test="not(@name='TargetTypeValue')">
        <xsl:if test="@range='not 0'">
          <xsl:choose>
            <xsl:when test="ebml:extension[@type='enum source']/@bitfield">
              <xsl:text>0x0 | </xsl:text>
            </xsl:when>
            <xsl:otherwise>
              <xsl:text>0 | </xsl:text>
            </xsl:otherwise>
          </xsl:choose>
          <xsl:text>Not valid for use as </xsl:text>
          <xsl:call-template name="NameWithLiaison">
            <xsl:with-param name="name" select="ebml:extension[@type='enum source']/@registry" />
          </xsl:call-template>
          <xsl:text> | RFC 9559, </xsl:text>

          <xsl:call-template name="NameToElement">
            <xsl:with-param name="name" select="@name" />
          </xsl:call-template>

          <xsl:text>&#xa;</xsl:text>
        </xsl:if>
      </xsl:if>

      <xsl:choose>
        <xsl:when test="@name='TargetTypeValue'">
          <xsl:for-each select="ebml:restriction/ebml:enum">
            <xsl:sort select="string-length(@value)"/>
            <xsl:sort select="@value" order="descending"/>
            <xsl:value-of select="@value"/>
            <xsl:text> | </xsl:text>
            <xsl:value-of select="@label"/>
            <xsl:text> | RFC 9559, </xsl:text>

            <xsl:call-template name="NameToElement">
              <xsl:with-param name="name" select="../../@name" />
            </xsl:call-template>

            <xsl:text>&#xa;</xsl:text>
          </xsl:for-each>
        </xsl:when>
        <xsl:otherwise>
          <xsl:for-each select="ebml:restriction/ebml:enum">
            <xsl:value-of select="@value"/>
            <xsl:text> | </xsl:text>
            <xsl:value-of select="@label"/>
            <xsl:text> | RFC 9559, </xsl:text>

            <xsl:call-template name="NameToElement">
              <xsl:with-param name="name" select="../../@name" />
            </xsl:call-template>

            <xsl:text>&#xa;</xsl:text>
          </xsl:for-each>
        </xsl:otherwise>
      </xsl:choose>

      <!-- not 0 -->
      <xsl:if test="@name='TargetTypeValue'">
        <xsl:if test="@range='not 0'">
          <xsl:text>0 | </xsl:text>
          <xsl:text>Not valid for use as </xsl:text>
          <xsl:call-template name="NameWithLiaison">
            <xsl:with-param name="name" select="ebml:extension[@type='enum source']/@registry" />
          </xsl:call-template>
          <xsl:text> | RFC 9559, </xsl:text>

          <xsl:call-template name="NameToElement">
            <xsl:with-param name="name" select="@name" />
          </xsl:call-template>

          <xsl:text>&#xa;</xsl:text>
        </xsl:if>
      </xsl:if>


      <xsl:text>Table: Initial Contents of "</xsl:text>
      <xsl:call-template name="RegistryToTitle">
        <xsl:with-param name="registry" select="ebml:extension[@type='enum source']/@registry" />
      </xsl:call-template>
      <xsl:text>" Registry{</xsl:text>
      <xsl:call-template name="RegistryToTable">
        <xsl:with-param name="registry" select="ebml:extension[@type='enum source']/@registry" />
      </xsl:call-template>
      <xsl:text>}&#xa;&#xa;&#xa;</xsl:text>

    </xsl:if>
  </xsl:template>

  <xsl:template name="NameToLink">
    <xsl:param name="name"/>
    <xsl:choose>
      <xsl:when test="$name='Range'">
        <xsl:text>color-range</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="translate($name, $uppercase, $smallcase)"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="RegistryToTable">
    <xsl:param name="registry"/>
    <xsl:text>#</xsl:text>
    <xsl:value-of select="translate(translate($registry, $uppercase, $smallcase), ' ', '-')"/>
    <xsl:text>-registry-table</xsl:text>
  </xsl:template>

  <xsl:template name="RegistryToTitle">
    <xsl:param name="registry"/>

    <xsl:text>Matroska </xsl:text>
    <xsl:value-of select="$registry"/>
    <xsl:text>s</xsl:text>
  </xsl:template>

  <xsl:template name="RegistryToName">
    <xsl:param name="registry"/>
    <xsl:value-of select="$registry"/>
  </xsl:template>

  <xsl:template name="NameToElement">
    <xsl:param name="name"/>

    <xsl:text>(#</xsl:text>
    <xsl:call-template name="NameToLink">
      <xsl:with-param name="name" select="$name" />
    </xsl:call-template>
    <xsl:text>-element)</xsl:text>
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
