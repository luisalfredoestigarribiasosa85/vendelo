class ProductsController < ApplicationController
    def index
        @products = Product.all.with_attached_image
    end
    def show
        set_product
        if set_product.nil?
            redirect_to products_path, alert: t('.not_found')
        end
    end
    def new
        @product = Product.new
    end
    def create
        @product = Product.new(product_params)
        if @product.save
            redirect_to products_path, notice: t('.created_successfully')
        else
            flash.now[:alert] = t('.creation_error')
            render :new, status: :unprocessable_entity
        end
    end
    def edit
        set_product
        if @product.nil?
            redirect_to products_path, alert: t('.not_found')
        end
    end
    def update
        if set_product.update(product_params)
            redirect_to products_path, notice: t('.updated_successfully')
        else
            flash.now[:alert] = t('.update_error')
            render :edit, status: :unprocessable_entity
        end
    end
    def destroy
        if set_product.destroy
            redirect_to products_path, notice: t('.deleted_successfully')
        else
            redirect_to products_path, alert: t('.deletion_error')
        end
    end

    private
    def product_params
        params.require(:product).permit(:title, :description, :price, :image)
    end

    def set_product
        @product = Product.find(params[:id])
    rescue ActiveRecord::RecordNotFound
        redirect_to products_path, alert: t('.not_found')
    end
end