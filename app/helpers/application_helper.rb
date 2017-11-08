module ApplicationHelper
    def flash_error(object)
        object.errors.full_messages.join(", ")
    end
end
