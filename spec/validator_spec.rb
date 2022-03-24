# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Lobanov::Validator do
  let(:subject) do
    described_class.call(new_schema: new_schema, stored_schema: stored_schema)
  end

  context 'with nullable fields' do
    let(:stored_schema) do
      YAML.load <<~YAML
        type: object
        required: [name]
        properties:
          name:
            type: string
            example: Alex
          rejection_comment:
            type: string
            example: rejected
            nullable: true
          this_key_will_be_missing:
            type: string
            example: secret
          apps:
            type: object
            properties:
              tags:
                type: array
                minItems: 0
                uniqueItems: true
                items:
                  type: string
                  example:
                    - btc
                    - eth
                    - usdt
      YAML
    end

    let(:new_schema) do
      YAML.load <<~YAML
        type: object
        required: [name]
        properties:
          name:
            type: string
            example: Alex
          rejection_comment:
            nullable: true
          apps:
            type: object
            properties:
              tags:
                type: array
                minItems: 0
                uniqueItems: true
                items: {}
      YAML
    end

    it 'allows to not have nullable property' do
      expect(subject).to eq(nil), subject
    end
  end
end