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
          visible false
          field :translations, :globalize_tabs
        end

        config.model_translation Cms::MetaTags do
          field :locale, :hidden
          field :title
          field :keywords
          field :description
        end

        config.model Cms::SitemapElement do
          #visible false

          field :display_on_sitemap
          field :changefreq
          field :priority
        end

        config.include_models Attachable::Asset
        config.include_models EventGalleryImage, EventSlide, HomeSlide

        config.model Attachable::Asset do
          field :data
          field :translations, :globalize_tabs
        end

        config.model_translation Attachable::Asset do
          field :locale, :hidden
          field :data_alt
        end

        config.model EventGalleryImage do
          visible false
          field :data do
            help do
              "1400x740#"
            end
          end
          field :translations, :globalize_tabs
        end

        config.model EventSlide do
          visible false
          field :data do
            help do
              "2048x600#"
            end
          end
          field :translations, :globalize_tabs
        end

        config.model HomeSlide do
          visible false
          field :data do
            help do
              "1920x1000#"
            end
          end
          field :translations, :globalize_tabs
        end

        config.include_models User, Administrator, Member
        config.model User do
          visible false

        end

        config.model_translation User do
          field :locale, :hidden
          field :first_name
          field :middle_name
          field :last_name
          #field :description
          field :hobby
        end

        config.model Administrator do
          navigation_label "Users"
          object_label_method do
            :full_name
          end

          field :email
          field :password
          field :password_confirmation
          field :translations, :globalize_tabs
          field :events_with_me_as_speaker
        end

        config.model Member do
          navigation_label "Users"

          list do
            field :confirmed_at do
              date_format do
                :default
              end
            end
            field :approved_at do
              date_format do
                :default
              end
            end
            #field :is_speaker
            field :email
            field :full_name
            field :avatar
          end

          edit do
            field :confirmed_at, :date do
              date_format do
                :default
              end
            end
            field :approved, :boolean
            #field :is_speaker
            field :email
            field :password
            field :password_confirmation
            field :translations, :globalize_tabs
            field :birth_date do
              date_format do
                :default
              end
            end
            field :phones
            field :avatar
            field :companies
          end
        end

        config.include_models Company, CompanyOffice
        config.model Company do
          field :industry
          field :employees_count
          field :translations, :globalize_tabs
          field :company_site
          #:social_networks
          field :company_offices
        end

        config.model_translation Company do
          field :locale, :hidden
          field :name
          field :description
          field :region
          field :position
        end

        config.model CompanyOffice do
          field :company
          field :translations, :globalize_tabs
          field :phones
        end

        config.model_translation CompanyOffice do
            field :locale, :hidden
            field :city
            field :address
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
          field :avatar
          field :slider_images
          field :gallery_images
          field :speakers
          field :seo_tags
          field :sitemap_record
        end

        config.model_translation Event do
          field :locale, :hidden
          field :name
          field :url_fragment do
            help do
              I18n.t("admin.help.#{name}")
            end
          end
          field :content, :ck_editor
          field :text_speakers
          field :place
        end

        config.include_models Article, Cms::Tag, Cms::Tagging

        config.model Cms::Tag do
          field :translations, :globalize_tabs
          field :articles
        end

        config.model_translation Cms::Tag do
          field :locale, :hidden
          field :name
          field :url_fragment do
            help do
              I18n.t("admin.help.#{name}")
            end
          end
        end

        config.model Cms::Tagging do
          visible false
        end

        config.model Article do
          field :published
          field :premium
          field :translations, :globalize_tabs
          field :avatar
          field :banner
          field :release_date do
            date_format do
              :default
            end
          end
          field :author
          field :tags
          field :seo_tags
        end

        config.model_translation Article do
          field :locale, :hidden
          field :name
          field :url_fragment do
            help do
              I18n.t("admin.help.#{name}")
            end
          end
          field :content, :ck_editor
        end

        config.include_models Testimonial
        config.model Testimonial do
          parent Pages::Home
          nestable_list(position_field: :sorting_position, scope: :published)
          field :published
          field :translations, :globalize_tabs
          field :image
        end

        config.model_translation Testimonial do
          field :locale, :hidden
          field :name
          field :position
          field :description
        end

        config.include_models Pages::Home, Pages::AboutUs, Pages::Articles, Pages::Contacts, Pages::Events, Pages::Members, Pages::Partners, Pages::SignIn, Pages::SignUp, Pages::Cabinet, Pages::ForgotPassword, Pages::EditPassword
        config.model Pages::Home do
          field :slider_images
          field :seo_tags
        end

        [Pages::AboutUs, Pages::Articles, Pages::Contacts, Pages::Events, Pages::Members, Pages::Partners, Pages::SignIn, Pages::SignUp, Pages::Cabinet, Pages::ForgotPassword, Pages::EditPassword].each do |m|
          config.model m do
            field :seo_tags
          end
        end


        config.include_models Speaker
        config.model Speaker do
          parent Pages::Home
          nestable_list(position_field: :sorting_position, scope: :published)

          field :published
          field :translations, :globalize_tabs
          field :image
          field :social_facebook
          field :social_google_plus
        end

        config.model_translation Speaker do
          field :locale, :hidden
          field :name
          field :description
        end

        form_configs = [FormConfigs::NewUserWaitingApproval, FormConfigs::UserSubscribedToEvent, FormConfigs::UserUnsubscribedFromEvent]

        config.include_models *form_configs
        form_configs.each do |m|
          config.model m do
            navigation_label "Налаштуваня"
            field :email_receivers, :text
          end
        end

        config.include_models HomeClubCompany
        config.model HomeClubCompany do
          parent Pages::Home
          nestable_list(position_field: :sorting_position, scope: :published)
          field :published
          field :translations, :globalize_tabs
          field :image
          field :company_site
        end

        config.model_translation HomeClubCompany do
          field :locale, :hidden
          field :name
          field :description
        end

        config.include_models PartnerCompany
        config.model PartnerCompany do
          parent Pages::Partners
          nestable_list(position_field: :sorting_position, scope: :published)
          field :published
          field :translations, :globalize_tabs
          field :image
          field :company_site
        end

        config.model_translation PartnerCompany do
          field :locale, :hidden
          field :name
          field :description
        end

        config.include_models ClubMemberValue

        config.model ClubMemberValue do
          parent Pages::AboutUs
          nestable_list(position_field: :sorting_position, scope: :published)
          field :published
          field :translations, :globalize_tabs
        end

        config.model_translation ClubMemberValue do
          field :locale, :hidden
          field :name
          field :description
        end

        config.include_models IndustrySlide

        config.model IndustrySlide do
          parent Pages::AboutUs
          nestable_list(position_field: :sorting_position, scope: :published)
          field :published
          field :translations, :globalize_tabs
          field :image
        end

        config.model_translation IndustrySlide do
          field :locale, :hidden
          field :name
        end

        config.include_models Industry
        config.model Industry do
          field :translations, :globalize_tabs
          field :companies
        end

        config.model_translation Industry do
          field :locale, :hidden
          field :name
        end
      end
    end
  end
end