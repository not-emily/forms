module CustomFormsHelper
    # CONTROLLER
    def form_field(field)
        field_type = FormField::TYPES[field.field_type]
        case field_type[:element].downcase
        when "input"
            if !field_type[:has_children]
                input_field(field)
            else
                input_children_field(field)
            end
        when "select"
            select_field(field)
        when "textarea"
            textarea_field(field)
        end
    end

    # FIELDS
    def input_field(field)
        "
        #{field_label(field)}
        <input class='form-control' #{'required' if field.required} id='#{response_id(field.field_id)}[value]' name='#{response_id(field.field_id)}[value]' type='#{ field.field_type }' placeholder='#{field.label_as_placeholder ? field.name : field.placeholder}' />
        ".html_safe
    end

    def input_children_field(field)
        children = ''
        case field.field_type
        when "radio"
            children =  collection_radio_buttons('response[' + field.field_id + ']', 'value', field.form_field_children.all, :name, :name, {}, required: field.required) do |b|
                "<div>
                #{ b.label { b.radio_button(style: "margin-right: .5rem") + b.text } }
                </div>".html_safe
            end
        when "checkbox"
            # TODO: Make it so not all checkboxes have to be required
            children = collection_check_boxes('response[' + field.field_id + ']', 'value', field.form_field_children.all, :name, :name, { :include_hidden => false }, required: field.required ) do |b|
                "<div>
                #{ b.label { b.check_box(style: "margin-right: .5rem") + b.text } }
                </div>".html_safe
            end
        end
            "
            #{field_label(field)}
            <div class='col'>
            #{children}
            </div>
            ".html_safe
    end

    def select_field(field)
        options = ''
        field.form_field_children.each do |child|
            options += "<option value='#{child.name}'>#{child.name}</option>"
        end

        "
        #{field_label(field)}
        <select class='form-control' #{'required' if field.required} id='#{response_id(field.field_id)}[value]' name='#{response_id(field.field_id)}[value]'>
        #{options}
        </select>
        ".html_safe
    end

    def textarea_field(field)
        "
        #{field_label(field)}
        <textarea class='form-control' #{'required' if field.required} id='#{response_id(field.field_id)}[value]' name='#{response_id(field.field_id)}[value]' type='#{ field.field_type }' >#{field.label_as_placeholder ? field.name : field.placeholder}</textarea>
        ".html_safe
    end

    # CONSTANTS
    def field_label(field)
        field.label_as_placeholder ? '' :
        "<label for='#{response_id(field.field_id)}[value]' >#{ field.name }#{'<span class="text-danger"> *</span>' if field.required }</label>".html_safe
    end

    def response_id(field_id)
        "response[#{ field_id }]"
    end
end
