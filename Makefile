$(info RFC rendering has been tested with mmark version 1.3.4 and xml2rfc 2.5.1, please ensure these are installed and recent enough.)

VERSION_MATROSKA := 03
VERSION_CODEC := 01
VERSION_TAGS := 01
STATUS_MATROSKA := draft-
STATUS_CODEC := draft-
STATUS_TAGS := draft-
OUTPUT_MATROSKA := $(STATUS_MATROSKA)lhomme-cellar-matroska-$(VERSION_MATROSKA)
OUTPUT_CODEC := $(STATUS_CODEC)lhomme-cellar-codecs-$(VERSION_CODEC)
OUTPUT_TAGS := $(STATUS_TAGS)lhomme-cellar-tags-$(VERSION_TAGS)

all: $(OUTPUT_MATROSKA).html $(OUTPUT_MATROSKA).txt $(OUTPUT_MATROSKA).xml $(OUTPUT_CODEC).html $(OUTPUT_CODEC).txt $(OUTPUT_CODEC).xml $(OUTPUT_TAGS).html $(OUTPUT_TAGS).txt $(OUTPUT_TAGS).xml

ebml_matroska_elements4rfc.md: ebml_matroska.xml transforms/ebml_schema2markdown4rfc.xsl
	xsltproc transforms/ebml_schema2markdown4rfc.xsl ebml_matroska.xml > $@

$(OUTPUT_MATROSKA).md: index_matroska.md diagram.md matroska_schema_section_header.md ebml_matroska_elements4rfc.md notes.md order_guidelines.md chapters.md attachments.md cues.md streaming.md menu.md
	cat $^ | grep -v '^---' > $@

$(OUTPUT_CODEC).md: index_codec.md codec_specs.md subtitles.md
	cat $^ > $@

$(OUTPUT_TAGS).md: index_tags.md tagging.md
	cat $^ > $@

%.xml: %.md
	mmark -xml2 -page $< > $@

%.html: %.xml
	xml2rfc --html $< -o $@

%.txt: %.xml
	xml2rfc $< -o $@

ebml_matroska_elements.md: ebml_matroska.xml transforms/ebml_schema2markdown.xsl
	xsltproc transforms/ebml_schema2markdown.xsl $< > $@

website:
	jekyll b

clean:
	$(RM) -f $(OUTPUT_MATROSKA).txt $(OUTPUT_MATROSKA).html $(OUTPUT_MATROSKA).md $(OUTPUT_MATROSKA).xml ebml_matroska_elements.md ebml_matroska_elements4rfc.md
	$(RM) -f $(OUTPUT_CODEC).txt $(OUTPUT_CODEC).html $(OUTPUT_CODEC).md $(OUTPUT_CODEC).xml
	$(RM) -f $(OUTPUT_TAGS).txt $(OUTPUT_TAGS).html $(OUTPUT_TAGS).md $(OUTPUT_TAGS).xml
	$(RM) -rf _site
