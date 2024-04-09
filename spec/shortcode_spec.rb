require "spec_helper"
require "parslet/rig/rspec"

describe Shortcode do
  let(:simple_quote)        { load_fixture :simple_quote }
  let(:simple_quote_output) { load_fixture :simple_quote_output, :html }

  let(:shortcode) { described_class.new }
  let(:configuration) { shortcode.configuration }

  before do
    configuration.template_path = File.join File.dirname(__FILE__), "support/templates/erb"
  end

  context "with simple_quote" do
    before do
      configuration.block_tags = [:quote]
    end

    it "converts into html" do
      expect(shortcode.process(simple_quote).delete("\n")).to eq(simple_quote_output)
    end
  end

  context "with erb templates" do
    before do
      configuration.block_tags = [:quote]
    end

    it "converts into html" do
      expect(shortcode.process(simple_quote).delete("\n")).to eq(simple_quote_output)
    end
  end

  describe "configuration" do
    context "with block_tags" do
      before do
        configuration.block_tags = []
      end

      it "handles an empty array" do
        expect { shortcode.process(simple_quote) }.not_to raise_error
      end
    end

    context "with self_closing_tags" do
      before do
        configuration.self_closing_tags = []
      end

      it "handles an empty array" do
        expect { shortcode.process(simple_quote) }.not_to raise_error
      end
    end
  end

  context "with multiple instances" do
    it "allows having multiple Shortcode instances that have independent configurations" do
      expect(described_class.new.configuration).not_to be(described_class.new.configuration)
    end

    describe "configuration" do
      let(:shortcode1) { described_class.new }
      let(:shortcode2) { described_class.new }

      before do
        shortcode1.setup do |config|
          config.self_closing_tags << :quote
          config.templates = { quote: "i am from shortcode 1" }
        end

        shortcode2.setup do |config|
          config.self_closing_tags << :quote
          config.templates = { quote: "i am from shortcode 2" }
        end
      end

      it "uses the shortcode instance's configuration to process shortcodes" do
        expect(shortcode1.process("[quote]")).to eq("i am from shortcode 1")
        expect(shortcode2.process("[quote]")).to eq("i am from shortcode 2")
      end
    end
  end
end
