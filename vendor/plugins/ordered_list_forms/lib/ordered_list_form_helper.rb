module OrderedListFormHelper

    
    # -------------------------------------------------------------------------
    # class OrderedListFormBuilder
    # Allows automatic generation of form field HTML for fields within the scope of 
    # a form build using ordered_list_form_for
    # Example:
    # <%- ordered_list_form_for(:user, :url => users_url ) do |f| -%>
    # <%= f.text_field :login, :html => {:label => "Login", 
    #                                    :hint => "must be at least 3 characters"} %> 
    #
    # creates the following HTML
    #  <li>
    #    <label for="user_login">Login
    #      <span class="hint">must be at least 3 characters</span>
    #    </label>
    #    <input id="user_login" name="user[login]" size="30" type="text" />
    #  </li>
    class OrderedListFormBuilder < ActionView::Helpers::FormBuilder
      (%w(date_select datetime_select) +
           ActionView::Helpers::FormHelper.instance_methods - 
           %w(hidden_field radio_button form_for fields_for)).each do |selector|
        src = <<-END_SRC
          def #{selector}(field, options = {})
            options[:label] ? label = options[:label] : label = field.to_s.humanize
            options[:hint] ? hint = options[:hint] : hint = ""
            options.delete_if { |k,v| k == :hint || k == :label }
            @template.content_tag("li", 
              @template.content_tag("label", label + @template.content_tag("span", hint, :class => "hint"), :for => object_name.to_s.downcase << "_" << field.to_s) + super)
          end
        END_SRC
        class_eval src, __FILE__, __LINE__
      end
    end
    
    def ordered_list_form_remote_for(object_name, *args, &proc)
      options = args.last.is_a?(Hash) ? args.pop : {}
      options.merge!(:builder => OrderedListFormBuilder)
      legend = "#{object_name.to_s.humanize} Details"
      if options[:html]
        options[:html][:legend] ? legend = options[:html][:legend] : false
        options[:html].delete_if { |k,v| k == :legend }
      end
      concat(form_remote_tag(options), proc.binding)
      concat("\n",proc.binding)
      concat("<fieldset>\n", proc.binding)
      #concat("<legend>#{legend}</legend>\n", proc.binding)
      concat("<ol>\n", proc.binding)
      
      fields_for(object_name, *(args << options), &proc)
      
      concat("</ol>\n", proc.binding) 
      concat("</fieldset>\n", proc.binding)
      concat("</form>\n", proc.binding)
    end
    
    def ordered_list_form_for(object_name, *args, &proc)
      raise ArgumentError, "Missing block" unless block_given?
      options = args.last.is_a?(Hash) ? args.pop : {}
      options.merge!(:builder => OrderedListFormBuilder)
      legend = "#{object_name.to_s.humanize} Details"
      if options[:html]
        options[:html][:legend] ? legend = options[:html][:legend] : false
        options[:html].delete_if { |k,v| k == :legend }
      end
      concat(form_tag(options.delete(:url) || {}, options.delete(:html) || {}), proc.binding)
      concat("\n",proc.binding)
      concat("<fieldset>\n", proc.binding)
      #concat("<legend>#{legend}</legend>\n", proc.binding)
      concat("<ol>\n", proc.binding)

      fields_for(object_name, *(args << options), &proc)
      
      concat("</ol>\n", proc.binding) 
      concat("</fieldset>\n", proc.binding)
      concat("</form>\n", proc.binding)
    end
end
  