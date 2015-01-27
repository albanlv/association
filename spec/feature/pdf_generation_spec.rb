# coding: utf-8
require 'feature_helper'
require 'pdf/inspector'

RSpec.feature 'Pdf generation' do
  background do
    visit '/'
  end

  def pdf_text
    @text ||= PDF::Inspector::Text.analyze(page.source).strings.join
  end
  
  scenario 'inputting the first 3 values' do
    fill_in 'name', with: 'Foo association'
    fill_in 'city', with: 'Bar city'
    fill_in 'post_code', with: '1234'
    click_button 'Submit'

    expect(page.response_headers['Content-Type']).to eq('application/pdf')
    expect(pdf_text).to include("une association ayant pour dénomination: Foo association")
    expect(pdf_text).to include("Le siège social est fixé à Bar city")
    expect(pdf_text).to include("(CP 1234)")
  end
end
