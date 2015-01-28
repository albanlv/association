# coding: utf-8
require 'feature_helper'
require 'pdf/inspector'

RSpec.feature 'Pdf generation' do
  def pdf_text
    @text ||= PDF::Inspector::Text.analyze(page.source).strings.join
  end

  background do
    page.set_rack_session(status: {name: 'Foo',
                                   city: 'Bar',
                                   post_code: '1234'}.to_json)
  end
  
  scenario 'Trying to generate pdf when user was charged' do
    page.set_rack_session(email: 'foo@bar.com')

    visit '/pdf'

    expect(page.response_headers['Content-Type']).to eq('application/pdf')
    expect(pdf_text).to include("une association ayant pour dénomination: Foo")
    expect(pdf_text).to include("Le siège social est fixé à Bar")
    expect(pdf_text).to include("(CP 1234)")
  end

  scenario 'Trying to generate pdf when user was NOT charged' do
    visit '/pdf'

    expect(page.response_headers['Content-Type']).to_not eq('application/pdf')
    expect(page.current_path).to eq('/')
  end
end
