class RecipesController < ApplicationController
    rescue_from ActiveRecord::RecordInvalid, with: :render_unprocessable_entity
    def index
        user = User.find_by(id: session[:user_id])

        if user
            recipes = Recipe.all 
            render json: recipes, status: :created
        else
            render json: {errors: ["Must Log In to View"]}, status: :unauthorized
        end
    end

    def create
        user = User.find_by(id: session[:user_id])
            if user
            recipe = user.recipes.create!(recipe_params)
            render json: recipe, status: :created
            else
                render json: {errors: ["Not Logged In"]}, status: :unauthorized
            end
    end

    private

    def recipe_params
        params.permit(:title, :instructions, :minutes_to_complete)

    end

    def render_unprocessable_entity(exception)
        
        render json: {errors: exception.record.errors.full_messages}, status: :unprocessable_entity
    end
end
