# coding: utf-8
require 'spec_helper'

RSpec.describe 'The template used for rendering the pdf file' do
  subject do
    @status = Status.new(attrs)
    path = "#{Sinatra::Application.root}/views/pdf.erb"
    ERB.new(File.read(path).force_encoding('utf-8')).result(binding)
  end

  let(:attrs){ {} }

  context 'the address is not present' do
    before do
      attrs.merge!('name'      => 'Foo',
                   'city'      => 'Bar',
                   'post_code' => 'Baz')
    end

    it 'does have the basic data' do
      should include("dénomination : Foo")
      should include("Le siège social est fixé à Bar")
      should include("(CP Baz)")
    end
  end

  context 'the type is "non_declared"' do
    before do
      attrs.merge!('type' => 'non_declared')
    end

    it 'does have the correct data' do
      should include("Les moyens d’action de l’association sont notamment:")
      should include("Les fondateurs de l’association ont décidé de ne pas procéder")
      should include("Les ressources de l’association se composent à l’exclusion")
      should include("Les ressources de l’association se composent à l’exclusion de toute autre ressource")
    end
  end

  def self.x_partial
    {
      'mean_publication'   => "les publications, les conférences, les réunions de travail ;",
      'mean_event'         => "l'organisation de conventions et événements;",
      'mean_manifestation' => "l’organisation de diverses manifestations et toute initiative pouvant aider",
      'mean_other'         => "tout autre moyen permettant l'accomplissement de son objet ;"
    }.each do |field, text|

      context "the '#{field}' is set to 'true'" do
        before{ attrs.merge!(field => 'true') }
        it {should include(text)}
      end

      context "the '#{field}' is set to 'false'" do
        before{ attrs.merge!(field => 'false') }
        it {should_not include(text)}
      end
    end

    context 'the "mean_added" is set' do
      before { attrs.merge!('mean_added' => 'The added mean value') }
      it {should include("The added mean value")}
    end
  end

  context 'the type is "declared"' do
    before{ attrs.merge!('type' => 'declared') }
    x_partial
  end

  context 'the type is "authorized"' do
    before{ attrs.merge!('type' => 'authorized') }
    x_partial
  end

  context '"end_duration", "end_date", "end_event" are blank' do
    it{ should include("La durée de l’association est illimitée.") }
  end

  context '"end_duration" is set' do
    before{ attrs.merge!('end_duration' => '01/01/01') }
    it{ should_not include("La durée de l’association est illimitée.") }
    it{ should include("L’association est constituée pour une durée de 01/01/01") }
  end

  context '"end_date" is set' do
    before{ attrs.merge!('end_date' => '01/01/01') }
    it{ should_not include("La durée de l’association est illimitée.") }
    it{ should include("L’association prendra fin au 01/01/01") }
  end

  context '"end_ecent" is set' do
    before{ attrs.merge!('end_event' => '01/01/01') }
    it{ should_not include("La durée de l’association est illimitée.") }
    it{ should include("la réalisation de l’événement suivant : 01/01/01") }
  end
end
