$(info RFC rendering has been tested with mmark version 1.3.4 and xml2rfc 2.5.1, please ensure these are installed and recent enough.)

VERSION_MATROSKA := 02
VERSION_CODEC := 01
VERSION_TAGS := 01
STATUS_MATROSKA := draft-
STATUS_CODEC := draft-
STATUS_TAGS := draft-
OUTPUT_MATROSKA := $(STATUS_MATROSKA)ietf-cellar-matroska-$(VERSION_MATROSKA)
OUTPUT_CODEC := $(STATUS_CODEC)ietf-cellar-codecs-$(VERSION_CODEC)
OUTPUT_TAGS := $(STATUS_TAGS)ietf-cellar-tags-$(VERSION_TAGS)

all: $(OUTPUT_MATROSKA).html $(OUTPUT_MATROSKA).txt $(OUTPUT_MATROSKA).xml $(OUTPUT_CODEC).html $(OUTPUT_CODEC).txt $(OUTPUT_CODEC).xml $(OUTPUT_TAGS).html $(OUTPUT_TAGS).txt $(OUTPUT_TAGS).xml

ebml_matroska_valid.xml: ebml_matroska.xml transforms/schema_valid_matroska.xsl
	xsltproc transforms/schema_valid_matroska.xsl $< > $@

ebml_matroska_elements4rfc.md: ebml_matroska_valid.xml transforms/ebml_schema2markdown4rfc.xsl
	xsltproc transforms/ebml_schema2markdown4rfc.xsl $< > $@

$(OUTPUT_MATROSKA).md: index_matroska.md diagram.md matroska_schema_section_header.md ebml_matroska_elements4rfc.md ordering.md chapters.md attachments.md cues.md streaming.md menu.md notes.md
	cat $^ | grep -v '^---' > $@

$(OUTPUT_CODEC).md: index_codec.md codec_specs.md subtitles.md
	cat $^ > $@

$(OUTPUT_TAGS).md: index_tags.md tagging.md matroska_tagging_registry.md tagging_end.md
	cat $^ > $@

%.xml: %.md
	mmark -xml2 -page $< | awk '/<?rfc toc=/ && !modif { printf("<?rfc tocdepth=\"6\"?>\n"); modif=1 } {print}' > $@

%.html: %.xml
	xml2rfc --html $< -o $@

%.txt: %.xml
	xml2rfc $< -o $@

matroska_tagging_registry.md: matroska_tags.xml transforms/matroska_tags2markdown4rfc.xsl
	xsltproc transforms/matroska_tags2markdown4rfc.xsl $< > $@

website:
	jekyll b

clean:
	$(RM) -f $(OUTPUT_MATROSKA).txt $(OUTPUT_MATROSKA).html $(OUTPUT_MATROSKA).md $(OUTPUT_MATROSKA).xml ebml_matroska_valid.xml ebml_matroska_elements4rfc.md matroska_tagging_registry.md
	$(RM) -f $(OUTPUT_CODEC).txt $(OUTPUT_CODEC).html $(OUTPUT_CODEC).md $(OUTPUT_CODEC).xml
	$(RM) -f $(OUTPUT_TAGS).txt $(OUTPUT_TAGS).html $(OUTPUT_TAGS).md $(OUTPUT_TAGS).xml
	$(RM) -rf _site
