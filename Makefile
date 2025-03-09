VERSION_MATROSKA := 24
VERSION_MATROSKA5 := 01
VERSION_CODEC := 15
VERSION_TAGS := 16
VERSION_CHAPTER_CODECS := 06
VERSION_CONTROL := 06
STATUS_MATROSKA := draft-
STATUS_CODEC := draft-
STATUS_TAGS := draft-
STATUS_CHAPTER_CODECS := draft-
STATUS_CONTROL := draft-
OUTPUT_MATROSKA := $(STATUS_MATROSKA)ietf-cellar-matroska-$(VERSION_MATROSKA)
OUTPUT_MATROSKA5 := $(STATUS_MATROSKA)ietf-cellar-matroska5-$(VERSION_MATROSKA5)
OUTPUT_CODEC := $(STATUS_CODEC)ietf-cellar-codec-$(VERSION_CODEC)
OUTPUT_TAGS := $(STATUS_TAGS)ietf-cellar-tags-$(VERSION_TAGS)
OUTPUT_CHAPTER_CODECS := $(STATUS_CHAPTER_CODECS)ietf-cellar-chapter-codecs-$(VERSION_CHAPTER_CODECS)
OUTPUT_CONTROL := $(STATUS_CONTROL)ietf-cellar-control-$(VERSION_CONTROL)

XML2RFC_CALL := xml2rfc
MMARK_CALL := mmark
EBML_SCHEMA_XSD := EBMLSchema.xsd

-include runtimes.mak

XML2RFC := $(XML2RFC_CALL) --v3
MMARK := $(MMARK_CALL)

MATROSKA_IANA_CSV := matroska-element-ids.csv \
	matroska-track-type-ids.csv \
	matroska-stereo-mode-ids.csv \
	matroska-alpha-mode-ids.csv \
	matroska-display-unit-ids.csv \
	matroska-horizontal-chroma-sitting-ids.csv \
	matroska-vertical-chroma-sitting-ids.csv \
	matroska-color-range-ids.csv \
	matroska-projection-type-ids.csv \
	matroska-track-plane-type-ids.csv \
	matroska-content-encoding-scope-ids.csv \
	matroska-content-encoding-type-ids.csv \
	matroska-compression-algorithm-ids.csv \
	matroska-encryption-algorithm-ids.csv \
	matroska-aes-cipher-mode-ids.csv \
	matroska-chapter-codec-ids.csv \
	matroska-tags-target-type-ids.csv

all: matroska matroska5 codecs tags chapter_codecs control matroska_iana.xml $(MATROSKA_IANA_CSV) rfc9559.notprepped.html
	$(info RFC rendering has been tested with mmark version 2.2.8 and xml2rfc 2.46.0, please ensure these are installed and recent enough.)

matroska: $(OUTPUT_MATROSKA).html $(OUTPUT_MATROSKA).txt $(OUTPUT_MATROSKA).xml
matroska5: $(OUTPUT_MATROSKA5).html $(OUTPUT_MATROSKA5).txt $(OUTPUT_MATROSKA5).xml
codecs: $(OUTPUT_CODEC).html $(OUTPUT_CODEC).txt $(OUTPUT_CODEC).xml
tags: $(OUTPUT_TAGS).html $(OUTPUT_TAGS).txt $(OUTPUT_TAGS).xml
chapter_codecs: $(OUTPUT_CHAPTER_CODECS).html $(OUTPUT_CHAPTER_CODECS).txt $(OUTPUT_CHAPTER_CODECS).xml
control: $(OUTPUT_CONTROL).html $(OUTPUT_CONTROL).txt $(OUTPUT_CONTROL).xml

matroska_xsd.xml: transforms/schema_clean.xsl ebml_matroska.xml
	xsltproc transforms/schema_clean.xsl ebml_matroska.xml > $@

control_xsd.xml: transforms/schema_clean_control.xsl ebml_matroska.xml
	xsltproc transforms/schema_clean_control.xsl ebml_matroska.xml > $@

check: matroska_xsd.xml control_xsd.xml $(EBML_SCHEMA_XSD)
	xmllint --version
	xmllint --noout --schema $(EBML_SCHEMA_XSD) matroska_xsd.xml
	xmllint --noout --schema $(EBML_SCHEMA_XSD) control_xsd.xml

ebml_matroska_elements4rfc.md: transforms/ebml_schema2markdown4rfc.xsl matroska_xsd.xml
	xsltproc transforms/ebml_schema2markdown4rfc.xsl matroska_xsd.xml > $@

matroska_iana_ids.md: transforms/ebml_schema2markdown4iana_ids.xsl matroska_xsd.xml
	xsltproc transforms/ebml_schema2markdown4iana_ids.xsl matroska_xsd.xml > $@

matroska_iana.md: transforms/ebml_schema2matroska_iana.xsl matroska_xsd.xml
	xsltproc transforms/ebml_schema2matroska_iana.xsl matroska_xsd.xml > $@

matroska_iana.xml: transforms/ebml_schema2xml4iana_ids.xsl matroska_xsd.xml
	xsltproc transforms/ebml_schema2xml4iana_ids.xsl matroska_xsd.xml | sed -e "s/@BUILD_DATE@/$(shell date +'%F')/"  > $@

matroska-element-ids.csv: transforms/ebml_schema2iana_csv.xsl matroska_xsd.xml
	xsltproc transforms/ebml_schema2iana_csv.xsl matroska_xsd.xml > $@

matroska-track-type-ids.csv: EBML_PATH='\Segment\Tracks\TrackEntry\TrackType'
matroska-stereo-mode-ids.csv: EBML_PATH='\Segment\Tracks\TrackEntry\Video\StereoMode'
matroska-alpha-mode-ids.csv: EBML_PATH='\Segment\Tracks\TrackEntry\Video\AlphaMode'
matroska-display-unit-ids.csv: EBML_PATH='\Segment\Tracks\TrackEntry\Video\DisplayUnit'
matroska-horizontal-chroma-sitting-ids.csv: EBML_PATH='\Segment\Tracks\TrackEntry\Video\Colour\ChromaSitingHorz'
matroska-vertical-chroma-sitting-ids.csv: EBML_PATH='\Segment\Tracks\TrackEntry\Video\Colour\ChromaSitingVert'
matroska-color-range-ids.csv: EBML_PATH='\Segment\Tracks\TrackEntry\Video\Colour\Range'
matroska-projection-type-ids.csv: EBML_PATH='\Segment\Tracks\TrackEntry\Video\Projection\ProjectionType'
matroska-track-plane-type-ids.csv: EBML_PATH='\Segment\Tracks\TrackEntry\TrackOperation\TrackCombinePlanes\TrackPlane\TrackPlaneType'
matroska-content-encoding-scope-ids.csv: EBML_PATH='\Segment\Tracks\TrackEntry\ContentEncodings\ContentEncoding\ContentEncodingScope'
matroska-content-encoding-type-ids.csv: EBML_PATH='\Segment\Tracks\TrackEntry\ContentEncodings\ContentEncoding\ContentEncodingType'
matroska-compression-algorithm-ids.csv: EBML_PATH='\Segment\Tracks\TrackEntry\ContentEncodings\ContentEncoding\ContentCompression\ContentCompAlgo'
matroska-encryption-algorithm-ids.csv: EBML_PATH='\Segment\Tracks\TrackEntry\ContentEncodings\ContentEncoding\ContentEncryption\ContentEncAlgo'
matroska-aes-cipher-mode-ids.csv: EBML_PATH='\Segment\Tracks\TrackEntry\ContentEncodings\ContentEncoding\ContentEncryption\ContentEncAESSettings\AESSettingsCipherMode'
matroska-chapter-codec-ids.csv: EBML_PATH='\Segment\Chapters\EditionEntry\+ChapterAtom\ChapProcess\ChapProcessCodecID'
matroska-tags-target-type-ids.csv: EBML_PATH='\Segment\Tags\Tag\Targets\TargetTypeValue'

%.csv: transforms/ebml_schema_enum2iana_csv.xsl matroska_xsd.xml
	xsltproc --stringparam ebmlpath $(EBML_PATH) transforms/ebml_schema_enum2iana_csv.xsl matroska_xsd.xml > $@

matroska_deprecated4rfc.md: transforms/ebml_schema2markdown4deprecated.xsl matroska_xsd.xml
	xsltproc transforms/ebml_schema2markdown4deprecated.xsl matroska_xsd.xml > $@

control_elements4rfc.md: transforms/ebml_schema2markdown4rfc.xsl control_xsd.xml
	xsltproc transforms/ebml_schema2markdown4rfc.xsl control_xsd.xml > $@

$(OUTPUT_MATROSKA).md: index_matroska.md diagram.md matroska_schema_section_header.md ebml_matroska_elements4rfc.md ordering.md notes.md chapters.md attachments.md cues.md streaming.md tags-precedence.md matroska_implement.md matroska_security.md iana_matroska_ids.md matroska_iana_ids.md matroska_iana.md iana.md rfc_backmatter_matroska.md matroska_annex.md matroska_deprecated4rfc.md
	cat $^ > $@

$(OUTPUT_MATROSKA5).md: index_matroska5.md matroska5_body.md matroska5_security.md matroska5_iana.md rfc_backmatter_matroska5.md
	cat $^ | sed -e "s/@BUILD_DATE@/$(shell date +'%F')/" \
	             -e "s/@BUILD_VERSION@/$(OUTPUT_MATROSKA5)/" > $@

$(OUTPUT_CODEC).md: index_codec.md codec_specs.md wavpack.md subtitles.md block_additional_mappings_intro.md block_additional_mappings/*.md codec_security.md codec_iana.md rfc_backmatter_codec.md
	cat $^ | sed -e "s/@BUILD_DATE@/$(shell date +'%F')/" \
	             -e "s/@BUILD_VERSION@/$(OUTPUT_CODEC)/" > $@

$(OUTPUT_TAGS).md: index_tags.md tagging.md matroska_tagging_registry.md tags_security.md tags_iana.md tags_iana_names.md rfc_backmatter_tags.md
	cat $^ | sed -e "s/@BUILD_DATE@/$(shell date +'%F')/" \
	             -e "s/@BUILD_VERSION@/$(OUTPUT_TAGS)/" > $@

$(OUTPUT_CHAPTER_CODECS).md: index_chapter_codecs.md chapter_codecs.md chapter_codecs_security.md chapter_codecs_iana.md rfc_backmatter_chapter_codecs.md
	cat $^ | sed -e "s/@BUILD_DATE@/$(shell date +'%F')/" \
	             -e "s/@BUILD_VERSION@/$(OUTPUT_CHAPTER_CODECS)/" > $@

$(OUTPUT_CONTROL).md: index_control.md control.md control_elements4rfc.md menu.md control_security.md control_iana.md rfc_backmatter_control.md
	cat $^ | sed -e "s/@BUILD_DATE@/$(shell date +'%F')/" \
	             -e "s/@BUILD_VERSION@/$(OUTPUT_CONTROL)/" > $@

%.xml: %.md
	$(MMARK) $< | sed -e "s/submissionType=/sortRefs=\"true\" tocDepth=\"4\" submissionType=/" \
	             -e 's@<?xml version="1.0" encoding="utf-8"?>@<?xml version="1.0" encoding="UTF-8"?>\n<!DOCTYPE rfc \[\n <!ENTITY nbsp    "\&#160;">\n <!ENTITY zwsp   "\&#8203;">\n <!ENTITY nbhy   "\&#8209;">\n <!ENTITY wj     "\&#8288;">\n\]>@' \
	             -e "s@\"http://www.w3.org/2001/XInclude\"@\"http://www.w3.org/2001/XInclude\" tocInclude=\"true\" symRefs=\"true\"@" \
	             -e 's@<street></street>@@g' \
	             -e 's@<date></date>@@g' \
	             -e 's@></xref>@/>@g' \
	             -e 's@<reference @\n<reference @g' \
	             -e 's@&quot;@"@g' \
	             -e 's@</table></section>@</table>\n</section>@g' \
		> $@

%.html: %.xml
	$(XML2RFC) --html $< -o $@

%.txt: %.xml
	$(XML2RFC) $< -o $@

matroska_tagging_registry.md: matroska_tags.xml transforms/matroska_tags2markdown4rfc.xsl
	xsltproc transforms/matroska_tags2markdown4rfc.xsl $< > $@

tags_iana_names.md: matroska_tags.xml transforms/matroska_tags2markdown4iana.xsl
	xsltproc transforms/matroska_tags2markdown4iana.xsl $< > $@

rfc9559.notprepped.xml: $(OUTPUT_MATROSKA).xml
	sed -e 's@<!\[CDATA\[@\n@g' \
	-e 's@\]\]>@@g' \
	$< > $@

%.html: rfc9559.notprepped.xml
	$(XML2RFC) --html $< -o $@

%.txt: rfc9559.notprepped.xml
	$(XML2RFC) $< -o $@

website:
	jekyll b

clean:
	$(RM) -f $(OUTPUT_MATROSKA).txt $(OUTPUT_MATROSKA).html $(OUTPUT_MATROSKA).md $(OUTPUT_MATROSKA).xml ebml_matroska_elements4rfc.md matroska_tagging_registry.md matroska_deprecated4rfc.md matroska_iana.xml matroska_iana_ids.md matroska_xsd.xml matroska_iana.md rfc9559.notprepped.xml rfc9559.notprepped.html
	$(RM) -f $(MATROSKA_IANA_CSV)
	$(RM) -f $(OUTPUT_MATROSKA5).txt $(OUTPUT_MATROSKA5).html $(OUTPUT_MATROSKA5).md $(OUTPUT_MATROSKA5).xml
	$(RM) -f $(OUTPUT_CODEC).txt $(OUTPUT_CODEC).html $(OUTPUT_CODEC).md $(OUTPUT_CODEC).xml
	$(RM) -f $(OUTPUT_TAGS).txt $(OUTPUT_TAGS).html $(OUTPUT_TAGS).md $(OUTPUT_TAGS).xml tags_iana_names.md
	$(RM) -f $(OUTPUT_CHAPTER_CODECS).txt $(OUTPUT_CHAPTER_CODECS).html $(OUTPUT_CHAPTER_CODECS).md $(OUTPUT_CHAPTER_CODECS).xml
	$(RM) -f $(OUTPUT_CONTROL).txt $(OUTPUT_CONTROL).html $(OUTPUT_CONTROL).md control_elements4rfc.md $(OUTPUT_CONTROL).xml control_xsd.xml
	$(RM) -rf _site

distclean: clean
	$(RM) -rf bootstrap.mak runtimes.mak

.PHONY: clean check website matroska codecs tags all
