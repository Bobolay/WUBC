class Administrator < User
  default_scope do
    where(role: "administrator")
  end
end