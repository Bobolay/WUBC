module RecursiveParams
  def update_params(params = {}, invoke_save = true)

    translation_param_names = (self.class.globalize_attributes rescue []).map(&:to_s)
    if params.blank? || params.is_a?(String)
      return false
    end

    if translation_param_names.any?
      translation_params = params.select{|k,v| k.to_s.in?(translation_param_names) }
      translation_params[:locale] ||= I18n.locale

      t = self.translations_by_locale[I18n.locale]

      if !t
        t = self.translations.new(translation_params)
      else
        translation_params.each do |k, v|
          t.send("#{k}=", v)
        end
      end
    end

    params = params.keep_if{|k, v| next false if k.to_s == "locale";  !translation_param_names.include?(k.to_s) }
    if ((params[:password].blank? && params[:password_confirmation].blank?) rescue false)
      params.delete(:password)
      params.delete(:password_confirmation)
    end


    params.each do |k, v|
      self.send("#{k}=", v) if self.respond_to?("#{k}=")
    end




    if invoke_save
      save_result = self.save

      if !save_result
        puts "#{self.class.name}##{self.id || 'new'}: errors: #{self.errors.inspect}"
      end
    end

  end
end