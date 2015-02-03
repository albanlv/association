# coding: utf-8
require 'spec_helper'

RSpec.describe 'POST /charge' do
  before do
    allow(Stripe::Customer).to receive(:create).and_return double('customer', id: nil)
    allow(Stripe::Charge).to receive(:create)
    allow(Mandrill::API).to receive(:new).and_return api
  end

  let(:api){ double('api', messages: double('messages', send: [{}])) }

  def pdf_text(body)
    @text ||= PDF::Inspector::Text.analyze(body).strings.join
  end

  let(:session) do
    {'rack.session' => {'status' => {'name'      => 'Foo',
                                     'city'      => 'Bar',
                                     'post_code' => 'Baz'}.to_json}}
  end

  it 'generates pdf' do
    response = post('/charge', {}, session)
    pdf = pdf_text(response.body)

    expect(response.header['Content-Type']).to eq('application/pdf')

    expect(pdf).to include("dénomination: Foo")
    expect(pdf).to include("Le siège social est fixé à Bar")
    expect(pdf).to include("(CP Baz)")
  end
end
