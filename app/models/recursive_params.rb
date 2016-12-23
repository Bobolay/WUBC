module RecursiveParams
  def update_params(params = {}, invoke_save = true)

    translation_param_names = (self.class.globalize_attributes rescue []).map(&:to_s)
    if params.blank?
      return false
    end
    puts "params: #{params.inspect}"

    if translation_param_names.any?
      translation_params = params.select{|k,v| k.to_s.in?(translation_param_names) }
      puts "translation_params: #{translation_params.inspect}"

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
    if params[:password].blank? && params[:password_confirmation].blank?
      params.delete(:password)
      params.delete(:password_confirmation)
    end

    puts "params: #{params.inspect}"

    params.each do |k, v|

      self.send("#{k}=", v) if self.respond_to?("#{k}=")
    end




    if invoke_save
      self.save
    end

  end
end