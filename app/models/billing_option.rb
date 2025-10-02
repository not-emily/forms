class BillingOption < ApplicationRecord
    belongs_to :plan

    validates :interval, presence: true
    validates :interval, uniqueness: { scope: :plan_id }


    enum interval: {
        monthly: "monthly",
        yearly: "yearly",
        golden_ticket: "golden_ticket"
    }
end
