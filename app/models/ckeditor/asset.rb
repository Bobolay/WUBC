require 'ckeditor/orm/active_record'
require 'ckeditor/backend/paperclip'

class Ckeditor::Asset < ActiveRecord::Base
  include Ckeditor::Orm::ActiveRecord::AssetBase
  include Ckeditor::Backend::Paperclip
end
