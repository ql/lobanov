# frozen_string_literal: true

require 'spec_helper'
require 'fileutils'

RSpec.describe Lobanov::Support::BundleSchema do 
  describe 'saves a single-file schema bundle given a path to index.yaml' do 
    context 'with concise schema' do 
      let(:index_folder) { 'spec/fixtures/bundle_schema/examples/verbose' }
      let(:etalon_path) { "#{index_folder}/verbose_etalon.yaml" } 
      let(:result_path) { "#{index_folder}/openapi_single.yaml" }

      def clear_file
        FileUtils.rm_f(result_path)
      end

      before do
        clear_file 
      end

      it 'writes expected content to expected file' do
        Lobanov::Support::BundleSchema.call(index_folder: index_folder)
        generated_bundle = YAML.load_file(result_path)
        etalon = YAML.load_file(etalon_path)
        if generated_bundle != etalon
          File.write("#{index_folder}/verbose_generated.yaml", generated_bundle.to_yaml)
          puts "❌" * 30
          puts "Files don't match. Generated file is saved to #{index_folder}/verbose_generated.yaml"
          puts "Compare with #{index_folder}/verbose_etalon.yaml"
          puts "❌" * 30
        end
        expect(generated_bundle).to eq(etalon)
      end

      after do 
        clear_file
      end
    end
  end

  describe 'postprocess_yaml' do
    context 'when yaml has trailing spaces' do
      let(:yaml) do 
        # There is a trailing space after `type: `
        <<~YAML
          ---
          components:
            schemas:
              User:
                type: 
                other_prop: 1
        YAML
      end

      # No trailing space here
      let(:expected_yaml) do 
        <<~YAML
          ---
          components:
            schemas:
              User:
                type:
                other_prop: 1
        YAML
      end
      
      it 'removes these trailing spaces' do 
        expect(described_class.postprocess_yaml!(+yaml)).to eq(expected_yaml)
      end
    end
  end
end

