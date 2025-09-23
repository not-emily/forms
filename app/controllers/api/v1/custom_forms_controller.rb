class Api::V1::CustomFormsController < ApplicationController
    skip_before_action :verify_authenticity_token, only: [:form_submission]

    def hello_world
        render json: {message: "Hello World"}
    end

    def form_submission
        p "*" * 50
        p "PARAMS"
        p params
        p "*" * 50
        form = CustomForm.find_by_apikey(params[:form_apikey])
        if form && params[:response]
            data = []
            params[:response].each do |response|
                data << [ response[0], response[1].to_s ]
            end

            form_submission = FormSubmission.new(:raw_data => data, :custom_form_id => form.id)
            if form_submission.save
                render json: { message: "Submission saved."}
            else
                render json: { error: "Submission could not be saved."}
            end
        end
    end
end
