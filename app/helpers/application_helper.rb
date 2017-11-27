module ApplicationHelper
    def logged_in_as_admin?
        logged_in? && current_user.admin?
    end

    def admin_yes_or_no(user)
        user.admin? ? "Yes" : "No"
    end
end
