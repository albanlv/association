# coding: utf-8
require 'feature_helper'

RSpec.feature 'Charging' do
  background do
    visit '/charge'
  end

  pending "it is hard to test stripe integration" do
    scenario 'inputting correct card details', js: true do
      click_button 'Pay with Card'

      within_frame 'stripe_checkout_app' do
        fill_in 'email', with: 'foo@bar.com'
        fill_in 'card_number', with: '4242 4242 4242 4242'
        fill_in 'cc-exp', with: "10/#{Date.today.year.divmod(100).last + 1}"
        fill_in 'cc-csc', with: '999'
        click_button 'Pay €50.00'
      end

      expect(page.response_headers['Content-Type']).to eq('application/pdf')
    end
  end
end
