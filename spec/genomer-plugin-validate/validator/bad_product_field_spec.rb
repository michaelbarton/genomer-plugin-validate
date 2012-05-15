require 'spec_helper'
require 'genomer-plugin-validate/validator/bad_product_field'

describe GenomerPluginValidate::Validator::BadProductField do

  subject{ described_class }

  describe "where there are no annotations" do
    it{ should return_no_errors_for [] }
  end

  describe "where there is valid annotation product field" do
    it{ should return_no_errors_for [annotation_with_product("transmembrane protein")]}
  end

  describe "where the product field begins with hypothetical" do
    it do
      should return_errors_for(
        [annotation_with_product("hypothetical protein")],
        ["Bad product field for '1:' start with 'putative' instead of 'hypothetical.'"]
      )
    end

    it do
      should return_errors_for(
        [annotation_with_product("Hypothetical protein")],
        ["Bad product field for '1:' start with 'putative' instead of 'hypothetical.'"]
      )
    end
  end

  describe "where the product ends with with like/domain/related" do
    start = "Bad product field for '1:' "
    ['like','related','domain'].each do |word|
      [word, word.capitalize].each do |cased|
        [' '+cased, '-'+cased].each do |prefixed|
          [prefixed+'.', prefixed].each do |formatted|
            it do
              should return_errors_for(
                [annotation_with_product("membrane" + formatted)],
                [start + "products ending with '#{word}' are not allowed."]
              )
            end
          end
        end
      end
    end
  end

  describe "where the product field contains n-term" do
    it do
      should return_errors_for(
        [annotation_with_product("n-term membrane region")],
        ["Bad product field for '1:' products containing 'n-term' are not allowed."]
      )
    end

    it do
      should return_errors_for(
        [annotation_with_product("N terminal membrane region")],
        ["Bad product field for '1:' products containing 'n terminal' are not allowed."]
      )
    end
  end

  describe "where the product field is in all caps" do
    it do
      should return_errors_for(
        [annotation_with_product("PROTEIN")],
        ["Bad product field for '1:' all caps product fields are not allowed."]
      )
    end

    it do
      should return_errors_for(
        [annotation_with_product("MEMBRANE PROTEIN")],
        ["Bad product field for '1:' all caps product fields are not allowed."]
      )
    end
  end

end
