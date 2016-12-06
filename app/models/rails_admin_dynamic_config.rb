def host?(*hosts)


  if hosts.blank? || !defined?(REQUEST_HOST)
    return true
  end

  hosts.include? REQUEST_HOST
end

module RailsAdminDynamicConfig
  class << self
    def configure_rails_admin(initial = true)
      RailsAdmin.config do |config|

        ### Popular gems integration

        ## == Devise ==
        config.authenticate_with do
          warden.authenticate! scope: :user
        end
        config.current_user_method(&:current_user)

        ## == Cancan ==
        config.authorize_with :cancan

        ## == Pundit ==
        # config.authorize_with :pundit

        ## == PaperTrail ==
        # config.audit_with :paper_trail, 'User', 'PaperTrail::Version' # PaperTrail >= 3.0.0

        ### More at https://github.com/sferik/rails_admin/wiki/Base-configuration



        if initial
          config.actions do
            dashboard                     # mandatory
            index                         # mandatory
            new
            export
            bulk_delete
            show
            edit
            delete
            show_in_app
            props do
              #only()
            end
            #edit_model
            nestable do
              #only [HomeBanner, Collection]
            end

            ## With an audit adapter, you can add:
            # history_index
            # history_show
          end
        end

        #config.include_models Attachable::Asset

        config.include_models Cms::Text
        config.model Cms::Text do
          navigation_label "Локалізація"

          edit do
            field :key
            field :translations, :globalize_tabs
          end

          list do
            field :key
            field :translations do
              pretty_value do
                o = @bindings[:object]
                translation_locales = Hash[I18n.available_locales.map{|locale| [locale, (t = o.translations_by_locale[locale]) && t.content.present?] }]
                translation_locales.map{|locale, translated| color = translated ? 'green' : 'red'; "<span style='color: #{color}'>#{locale}</span>" }.join(", ").html_safe
              end
            end
          end
        end

        config.model_translation Cms::Text do
          field :locale, :hidden
          field :content
        end

        config.include_models Cms::SitemapElement, Cms::MetaTags

        config.model Cms::MetaTags do
          field :translations, :globalize_tabs
        end

        config.model_translation Cms::MetaTags do
          visible false

          field :locale, :hidden
          field :title
          field :keywords
          field :description
        end

        config.model Cms::SitemapElement do
          field :display_on_sitemap
          field :changefreq
          field :priority
        end

        config.include_models User, Administrator, Member
        config.model User do
          visible false
        end

        config.model_translation User do
          field :locale, :hidden
          field :first_name
          field :last_name
          field :middle_name
        end

        config.model Administrator do
          navigation_label "Users"

          field :email
          field :password
          field :password_confirmation
        end

        config.model Member do
          navigation_label "Users"

          edit do
            field :email
            field :password
            field :password_confirmation
            field :translations, :globalize_tabs
            field :birth_date
            field :phone
            field :avatar
          end
        end

        config.include_models Event
        config.model Event do
          field :published
          field :premium
          field :translations, :globalize_tabs
          field :date do
            date_format do
              :default
            end
          end
          field :start_time
          field :end_time
          field :seo_tags
          field :sitemap_record
        end

        config.model_translation Event do
          field :locale, :hidden
          field :name
          field :url_fragment
          field :content, :ck_editor
        end
      end
    end
  end
end