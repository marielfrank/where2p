module ApplicationHelper
    def logged_in_as_admin?
        logged_in? && current_user.admin?
    end
end
