module ApplicationHelper
    def bootstrap_class_for flash_type
        { success: "alert-success", error: "alert-danger", alert: "alert-warning", notice: "alert-info" }.stringify_keys[flash_type.to_s] || flash_type.to_s
    end

    def flash_messages(opts = {})
        flash.each do |msg_type, message|
            msg = ""
            #if its a hash, I want to hide the field name that failed
            if message.class == Hash
                message.each do |k, v|
                    msg = msg + v[0] + " : "
                end
            else
                msg = message.class == String ? message.html_safe : message
            end
            concat(content_tag(:div, class: "alert #{bootstrap_class_for(msg_type)}", role: "alert") do
                concat content_tag(:div, msg, class: "alert-text")
            end)
        end
        nil
    end

    def user_avatar
        if @current_user && @current_user.gsi_pic && !@current_user.gsi_pic.empty?
        "<img class='rounded-circle' src='#{@current_user.gsi_pic}' />".html_safe
      else
        "<div class='empty-avatar'><svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 448 512'><!--!Font Awesome Free 6.7.2 by @fontawesome - https://fontawesome.com License - https://fontawesome.com/license/free Copyright 2025 Fonticons, Inc.--><path fill='#85898B' d='M224 256A128 128 0 1 0 224 0a128 128 0 1 0 0 256zm-45.7 48C79.8 304 0 383.8 0 482.3C0 498.7 13.3 512 29.7 512l388.6 0c16.4 0 29.7-13.3 29.7-29.7C448 383.8 368.2 304 269.7 304l-91.4 0z'/></svg></div>".html_safe
      end
    end
end
