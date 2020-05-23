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

        .level7{
          background:#99a;
        }

        .level8{
          background:#889;
        }

        .version2{
          color:#aaa;
          background:#eee;
        }
      </style>

      <body>
        <xsl:call-template name="GenerateTable">
          <xsl:with-param name="GitRevision" select="$GitRevision" />
        </xsl:call-template>
      </body>
    </html>
  </xsl:template>

  <xsl:include href="ebml_schema2spec_common.xsl"/>

</xsl:stylesheet>
