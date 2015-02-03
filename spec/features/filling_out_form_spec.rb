# coding: utf-8
require 'feature_helper'

RSpec.feature 'Filling out the form' do
  background do
    visit '/'
  end

  scenario 'inputting the first 3 values' do
    fill_in 'status[name]',         with: 'Foo association'
    fill_in 'status[city]',         with: 'Bar city'
    fill_in 'status[post_code]',    with: '1234'
    click_button "Renseigner l'adresse"
    fill_in 'status[address]',      with: 'Baz address'
    click_button 'Renseigner'
    fill_in 'status[end_duration]', with: 'End duration'
    fill_in 'status[end_date]',     with: 'End date'
    fill_in 'status[end_event]',    with: 'End event'
    fill_in 'status[mean_added]',   with: 'Mean added'

    click_button 'Submit'

    status = JSON.load(page.get_rack_session_key('status'))
    expect(status).to eq('name' => 'Foo association',
                         'city' => 'Bar city',
                         'post_code' => '1234',
                         'address' => 'Baz address',
                         'end_duration' => 'End duration',
                         'end_date' => 'End date',
                         'end_event' => 'End event',
                         'mean_added' => 'Mean added')
  end
end
