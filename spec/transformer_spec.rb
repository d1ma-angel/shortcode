require "spec_helper"
require "parslet/rig/rspec"

describe Shortcode do
  let(:configuration) {
    described_class.new.tap { |s|
      s.setup do |config|
        config.template_path = File.join File.dirname(__FILE__), "support/templates/erb"
        config.block_tags = %i[quote collapsible_list item timeline_person rails_helper]
        config.self_closing_tags = %i[timeline_event timeline_info]
      end
    }.configuration
  }
  let(:parser)        { Shortcode::Parser.new(configuration) }
  let(:transformer)   { Shortcode::Transformer.new(configuration) }

  let(:simple_quote)          { load_fixture :simple_quote }
  let(:full_quote)            { load_fixture :full_quote }
  let(:quote_with_extras)     { load_fixture :quote_with_extras }
  let(:simple_list)           { load_fixture :simple_list }
  let(:timeline_event)        { load_fixture :timeline_event }
  let(:timeline_info)         { load_fixture :timeline_info }
  let(:timeline_person)       { load_fixture :timeline_person }
  let(:complex_snippet)       { load_fixture :complex_snippet }
  let(:block_with_whitespace) { load_fixture :block_with_whitespace }

  let(:quotes)            { [simple_quote, full_quote, quote_with_extras] }
  let(:collapsible_lists) { [simple_list] }
  let(:timelines)         { [timeline_event, timeline_info, timeline_person] }

  let(:simple_quote_output)          { load_fixture :simple_quote_output, :html }
  let(:full_quote_output)            { load_fixture :full_quote_output, :html }
  let(:quote_with_extras_output)     { load_fixture :quote_with_extras_output, :html }
  let(:simple_list_output)           { load_fixture :simple_list_output, :html }
  let(:timeline_event_output)        { load_fixture :timeline_event_output, :html }
  let(:timeline_info_output)         { load_fixture :timeline_info_output, :html }
  let(:timeline_person_output)       { load_fixture :timeline_person_output, :html }
  let(:complex_snippet_output)       { load_fixture :complex_snippet_output, :html }
  let(:block_with_whitespace_output) { load_fixture :block_with_whitespace_output, :html }

  context "with simple_quote" do
    it "converts into html" do
      obj = parser.parse(simple_quote)
      html = transformer.apply obj, additional_attributes: nil
      expect(html.delete("\n")).to eq(simple_quote_output)
    end
  end

  context "with full_quote" do
    it "converts into html" do
      html = transformer.apply(parser.parse(full_quote), additional_attributes: nil)
      expect(html.delete("\n")).to eq(full_quote_output)
    end
  end

  context "with quote_with_extras" do
    it "converts into html" do
      html = transformer.apply(parser.parse(quote_with_extras), additional_attributes: nil)
      expect(html.delete("\n")).to eq(quote_with_extras_output)
    end
  end

  context "with simple_list" do
    it "converts into html" do
      html = transformer.apply(parser.parse(simple_list), additional_attributes: nil)
      expect(html.delete("\n")).to eq(simple_list_output)
    end
  end

  context "with timeline_event" do
    it "converts into html" do
      html = transformer.apply(parser.parse(timeline_event), additional_attributes: nil)
      expect(html.delete("\n")).to eq(timeline_event_output)
    end
  end

  context "with timeline_info" do
    it "converts into html" do
      html = transformer.apply(parser.parse(timeline_info), additional_attributes: nil)
      expect(html.delete("\n")).to eq(timeline_info_output)
    end
  end

  context "with timeline_person" do
    it "converts into html" do
      html = transformer.apply(parser.parse(timeline_person), additional_attributes: nil)
      expect(html.delete("\n")).to eq(timeline_person_output)
    end
  end

  context "with complex_snippet" do
    it "converts into html" do
      html = transformer.apply(parser.parse(complex_snippet), additional_attributes: nil)
      expect(html.delete("\n")).to eq(complex_snippet_output)
    end
  end

  context "with erb templates" do
    it "converts into html" do
      html = transformer.apply(parser.parse(simple_quote), additional_attributes: nil)
      expect(html.delete("\n")).to eq(simple_quote_output)
    end
  end

  context "with whitespace" do
    it "is preserved after a block tag" do
      html = transformer.apply(parser.parse(block_with_whitespace), additional_attributes: nil)
      expect(html.delete("\n")).to eq(block_with_whitespace_output)
    end
  end
end
