class HomeSlide < Attachable::Asset
  default_scope do
    order("id asc")
  end

  has_attached_file :data, styles: proc {|attachment| attachment.instance.attachment_styles },
                    url: "/system/attachable/assets/data/:id_partition/:style/:filename",
                    path: ":rails_root/public:url",
                    processors: [:thumbnail, :tinify]
end