class Plan < ApplicationRecord
    has_many :accounts
    has_many :billing_options, dependent: :destroy

    before_validation               :set_apikey,
                                    :on => :create


    enum slug: {
        developer: "developer",
        basic: "basic",
        business: "business"
    }

    def display_price(interval)
        option = self.billing_options.find_by(interval: interval)

        (option.price_cents / 100).to_i
    end

    def display_count(count)
        if count == -1
            "Unlimited"
        else
            "#{count}"
        end
    end

    def display_count_with_label(count, label)
        if count == -1
            "Unlimited #{label}s"
        else
            "#{count} #{label}#{'s' if count != 1}"
        end
    end

    private

    def set_apikey
        model = self.class.name.capitalize.constantize
        begin
            self.apikey = SecureRandom.urlsafe_base64
        end while model.exists?(apikey: self.apikey)
    end
end
