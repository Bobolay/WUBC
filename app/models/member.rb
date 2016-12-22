class Member < User

  default_scope do
    where(role: "member")
  end
end