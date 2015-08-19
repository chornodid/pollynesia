module Service
  class CreateAdminUser
    def initialize(attrs)
      @attrs = attrs
    end

    def call
      User.create!(@attrs.merge(is_admin: true))
    end
  end
end
