# Use the app.rb file to load Ruby code, modify or extend the models, or
# do whatever else you fancy when the theme is loaded.

require 'will_paginate'
require 'will_paginate/array'
require 'will_paginate/view_helpers/sinatra'

module Nesta
  class App
    # Uncomment the Rack::Static line below if your theme has assets
    # (i.e images or JavaScript).
    #
    # Put your assets in themes/<%= @name %>/public/<%= @name %>.
    #
    # use Rack::Static, urls: ["/<%= @name %>"], root: "themes/<%= @name %>/public"

    helpers WillPaginate::Sinatra::Helpers

    helpers do
      def list_articles(articles)
        haml_tag :ol do
          articles.each do |article|
            haml_tag :li do
              haml_tag :a, article.heading, :href => path_to(article.abspath)
            end
          end
        end
      end

      def article_years
        articles = Page.find_articles
        last, first = articles[0].date.year, articles[-1].date.year
        (first..last).to_a.reverse
      end

      def archive_by_year
        article_years.each do |year|
          haml_tag :li do
            haml_tag :a, :id => "#{year}"
            haml_tag :h2, year
            haml_tag :ol do
              articles = Page.find_articles.select { |a| a.date.year == year }
              list_articles(articles)
            end
          end
        end
      end
    end

    # Add new routes here.
  end
end
