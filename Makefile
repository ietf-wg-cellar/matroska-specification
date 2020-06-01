VERSION_MATROSKA := 05
VERSION_CODEC := 04
VERSION_TAGS := 04
STATUS_MATROSKA := draft-
STATUS_CODEC := draft-
STATUS_TAGS := draft-
OUTPUT_MATROSKA := $(STATUS_MATROSKA)ietf-cellar-matroska-$(VERSION_MATROSKA)
OUTPUT_CODEC := $(STATUS_CODEC)ietf-cellar-codec-$(VERSION_CODEC)
OUTPUT_TAGS := $(STATUS_TAGS)ietf-cellar-tags-$(VERSION_TAGS)

XML2RFC_CALL := xml2rfc
MMARK_CALL := mmark
EBML_SCHEMA_XSD := ../ebml-specification/EBMLSchema.xsd

-include runtimes.mak

XML2RFC := $(XML2RFC_CALL) --v3
MMARK := $(MMARK_CALL)

matroska: $(OUTPUT_MATROSKA).html $(OUTPUT_MATROSKA).txt $(OUTPUT_MATROSKA).xml
codecs: $(OUTPUT_CODEC).html $(OUTPUT_CODEC).txt $(OUTPUT_CODEC).xml
tags: $(OUTPUT_TAGS).html $(OUTPUT_TAGS).txt $(OUTPUT_TAGS).xml

all: matroska codecs tags
	$(info RFC rendering has been tested with mmark version 2.1.1 and xml2rfc 2.30.0, please ensure these are installed and recent enough.)

matroska_xsd.xml: transforms/schema_clean.xsl ebml_matroska.xml
	xsltproc transforms/schema_clean.xsl ebml_matroska.xml > $@

check: matroska_xsd.xml $(EBML_SCHEMA_XSD)
	xmllint --noout --schema $(EBML_SCHEMA_XSD) matroska_xsd.xml

ebml_matroska_elements4rfc.md: transforms/ebml_schema2markdown4rfc.xsl matroska_xsd.xml
	xsltproc transforms/ebml_schema2markdown4rfc.xsl matroska_xsd.xml > $@

$(OUTPUT_MATROSKA).md: index_matroska.md diagram.md matroska_schema_section_header.md ebml_matroska_elements4rfc.md ordering.md chapters.md attachments.md cues.md streaming.md menu.md notes.md rfc_backmatter_matroska.md
	sed -e '/^---/,/^---/d' $^ > $@

$(OUTPUT_CODEC).md: index_codec.md codec_specs.md subtitles.md block_additional_mappings_intro.md block_additional_mappings/*.md rfc_backmatter_codec.md
	cat $^ > $@

$(OUTPUT_TAGS).md: index_tags.md tagging.md matroska_tagging_registry.md tagging_end.md rfc_backmatter_tags.md
	cat $^ > $@

%.xml: %.md
	$(MMARK) $< | awk '/<?rfc toc=/ && !modif { printf("<?rfc tocdepth=\"6\"?>\n"); modif=1 } {print}' > $@

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
	$(RM) -rf _site

.PHONY: clean check website matroska codecs tags
