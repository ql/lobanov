# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Lobanov::Support::BundleSchema do 
  let(:subject) do 
    Lobanov::Support::ExpandRefs.call(schema, index_folder)
  end

  describe 'call' do
    context 'with schema without internal #references' do
      let(:index_folder) { 'spec/fixtures/bundle_schema/examples/verbose' }
      let(:schema) { YAML.load_file(index_folder + '/index.yaml') } 
      let(:etalon) { YAML.load_file(index_folder + '/verbose_etalon.yaml') }
      it 'returns expected etalon result' do 
        File.write('result.yaml', YAML.dump(subject))
        expect(subject).to eq(etalon)
      end
    end
  end
end
