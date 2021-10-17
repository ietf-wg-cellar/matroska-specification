VERSION_MATROSKA := 09
VERSION_CODEC := 08
VERSION_TAGS := 08
VERSION_CHAPTER_CODECS := 01
VERSION_CONTROL := 01
STATUS_MATROSKA := draft-
STATUS_CODEC := draft-
STATUS_TAGS := draft-
STATUS_CHAPTER_CODECS := draft-
STATUS_CONTROL := draft-
OUTPUT_MATROSKA := $(STATUS_MATROSKA)ietf-cellar-matroska-$(VERSION_MATROSKA)
OUTPUT_CODEC := $(STATUS_CODEC)ietf-cellar-codec-$(VERSION_CODEC)
OUTPUT_TAGS := $(STATUS_TAGS)ietf-cellar-tags-$(VERSION_TAGS)
OUTPUT_CHAPTER_CODECS := $(STATUS_CHAPTER_CODECS)ietf-cellar-chapter-codecs-$(VERSION_CHAPTER_CODECS)
OUTPUT_CONTROL := $(STATUS_CONTROL)ietf-cellar-control-$(VERSION_CONTROL)

XML2RFC_CALL := xml2rfc
MMARK_CALL := mmark
EBML_SCHEMA_XSD := ../ebml-specification/EBMLSchema.xsd

-include runtimes.mak

XML2RFC := $(XML2RFC_CALL) --v3
MMARK := $(MMARK_CALL)

all: matroska codecs tags chapter_codecs control
	$(info RFC rendering has been tested with mmark version 2.2.8 and xml2rfc 2.46.0, please ensure these are installed and recent enough.)

matroska: $(OUTPUT_MATROSKA).html $(OUTPUT_MATROSKA).txt $(OUTPUT_MATROSKA).xml
codecs: $(OUTPUT_CODEC).html $(OUTPUT_CODEC).txt $(OUTPUT_CODEC).xml
tags: $(OUTPUT_TAGS).html $(OUTPUT_TAGS).txt $(OUTPUT_TAGS).xml
chapter_codecs: $(OUTPUT_CHAPTER_CODECS).html $(OUTPUT_CHAPTER_CODECS).txt $(OUTPUT_CHAPTER_CODECS).xml
control: $(OUTPUT_CONTROL).html $(OUTPUT_CONTROL).txt $(OUTPUT_CONTROL).xml

matroska_xsd.xml: transforms/schema_clean.xsl ebml_matroska.xml
	xsltproc transforms/schema_clean.xsl ebml_matroska.xml > $@

control_xsd.xml: transforms/schema_clean_control.xsl ebml_matroska.xml
	xsltproc transforms/schema_clean_control.xsl ebml_matroska.xml > $@

check: matroska_xsd.xml control_xsd.xml $(EBML_SCHEMA_XSD)
	xmllint --noout --schema $(EBML_SCHEMA_XSD) matroska_xsd.xml
	xmllint --noout --schema $(EBML_SCHEMA_XSD) control_xsd.xml

ebml_matroska_elements4rfc.md: transforms/ebml_schema2markdown4rfc.xsl matroska_xsd.xml
	xsltproc transforms/ebml_schema2markdown4rfc.xsl matroska_xsd.xml > $@

matroska_deprecated4rfc.md: transforms/ebml_schema2markdown4deprecated.xsl matroska_xsd.xml
	xsltproc transforms/ebml_schema2markdown4deprecated.xsl matroska_xsd.xml > $@

control_elements4rfc.md: transforms/ebml_schema2markdown4rfc.xsl control_xsd.xml
	xsltproc transforms/ebml_schema2markdown4rfc.xsl control_xsd.xml > $@

$(OUTPUT_MATROSKA).md: index_matroska.md diagram.md matroska_schema_section_header.md ebml_matroska_elements4rfc.md ordering.md notes.md chapters.md attachments.md cues.md streaming.md iana.md matroska_deprecated4rfc.md rfc_backmatter_matroska.md
	cat $^ | sed -e '/^---/,/^---/d' \
	             -e "s/@BUILD_DATE@/$(shell date +'%F')/" \
	             -e "s/@BUILD_VERSION@/$(OUTPUT_MATROSKA)/" > $@

$(OUTPUT_CODEC).md: index_codec.md codec_specs.md subtitles.md block_additional_mappings_intro.md block_additional_mappings/*.md rfc_backmatter_codec.md
	cat $^ | sed -e "s/@BUILD_DATE@/$(shell date +'%F')/" \
	             -e "s/@BUILD_VERSION@/$(OUTPUT_CODEC)/" > $@

$(OUTPUT_TAGS).md: index_tags.md tagging.md matroska_tagging_registry.md tagging_end.md rfc_backmatter_tags.md
	cat $^ | sed -e "s/@BUILD_DATE@/$(shell date +'%F')/" \
	             -e "s/@BUILD_VERSION@/$(OUTPUT_TAGS)/" > $@
$(OUTPUT_CHAPTER_CODECS).md: index_chapter_codecs.md chapter_codecs.md rfc_backmatter_chapter_codecs.md
	cat $^ | sed -e "s/@BUILD_DATE@/$(shell date +'%F')/" \
	             -e "s/@BUILD_VERSION@/$(OUTPUT_CHAPTER_CODECS)/" > $@


$(OUTPUT_CONTROL).md: index_control.md control.md control_elements4rfc.md menu.md rfc_backmatter_control.md
	cat $^ | sed -e "s/@BUILD_DATE@/$(shell date +'%F')/" \
	             -e "s/@BUILD_VERSION@/$(OUTPUT_CONTROL)/" > $@

%.xml: %.md
	$(MMARK) $< | sed -e "s/submissionType=/sortRefs=\"true\" tocDepth=\"4\" submissionType=/" \
		> $@

%.html: %.xml
	$(XML2RFC) --html $< -o $@

%.txt: %.xml
	$(XML2RFC) $< -o $@

matroska_tagging_registry.md: matroska_tags.xml transforms/matroska_tags2markdown4rfc.xsl
	xsltproc transforms/matroska_tags2markdown4rfc.xsl $< > $@

website:
	jekyll b

clean:
	$(RM) -f $(OUTPUT_MATROSKA).txt $(OUTPUT_MATROSKA).html $(OUTPUT_MATROSKA).md $(OUTPUT_MATROSKA).xml ebml_matroska_elements4rfc.md matroska_tagging_registry.md
	$(RM) -f $(OUTPUT_CODEC).txt $(OUTPUT_CODEC).html $(OUTPUT_CODEC).md $(OUTPUT_CODEC).xml
	$(RM) -f $(OUTPUT_TAGS).txt $(OUTPUT_TAGS).html $(OUTPUT_TAGS).md $(OUTPUT_TAGS).xml
	$(RM) -f $(OUTPUT_CHAPTER_CODECS).txt $(OUTPUT_CHAPTER_CODECS).html $(OUTPUT_CHAPTER_CODECS).md $(OUTPUT_CHAPTER_CODECS).xml
	$(RM) -f $(OUTPUT_CONTROL).txt $(OUTPUT_CONTROL).html $(OUTPUT_CONTROL).md $(OUTPUT_CONTROL).xml
	$(RM) -rf _site

.PHONY: clean check website matroska codecs tags all
