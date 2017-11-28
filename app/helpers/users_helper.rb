module UsersHelper
    def logged_in_as_admin?
        logged_in? && current_user.admin?
    end

    def logged_in_owner_or_admin?(resource)
        logged_in? && current_user.owner_or_admin?(resource)
    end

    # for admin view of users
    def admin_yes_or_no(user)
        user.admin? ? "Yes" : "No"
    end
end